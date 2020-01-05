function [box_cropped, rotated, sheared, M] = crop_box(box_image, vertices, crop_padding)
    %% Find vectors relative to pivot as origin
    box_edge1 = point_to_vector(vertices(2), vertices(1));
    box_edge2 = point_to_vector(vertices(2), vertices(3));
    
    len1 = norm(box_edge1);
    len2 = norm(box_edge2);
    
    n1 = box_edge1 / len1;
    n2 = box_edge2 / len2;

    %% Find vectors before lineare transformation using top-left side as origin
    origin.pivot = 'origin';
    origin.value = [1; 1];
    origin_v1 =    point_to_vector(origin, vertices(1));
    origin_v2 =    point_to_vector(origin, vertices(3));
    origin_pivot = point_to_vector(origin, vertices(2));

    %% Rotate longest edge
    R = makeresampler({'cubic','nearest'},'fill');
    if (len1 < len2)
        M = [n1(2) -n1(1) 0; n1(1) n1(2) 0; 0 0 1];
    else
        M =  [n2(2) -n2(1) 0; n2(1) n2(2) 0; 0 0 1];
    end
    T = maketform('affine', M);
    rotated.image = imtransform(box_image, T, R,'FillValues',0);

    %% Find new origin after rotation
    rotated_o = find_new_origin(rotated.image, M);
    
    %% Find vectors after rotation
    rotated_o_v1    = (M(1:2, 1:2) * origin_v1);
    rotated_o_v2    = (M(1:2, 1:2) * origin_v2);
    rotated_o_pivot = (M(1:2, 1:2) * origin_pivot);
    
    %% Evaluate new vertices after rotation using rotated top-left as origin
    new_v1    = [rotated_o(1) + rotated_o_v1(1);    rotated_o(2) - rotated_o_v1(2)   ];
    new_v2    = [rotated_o(1) + rotated_o_v2(1);    rotated_o(2) - rotated_o_v2(2)   ];
    new_pivot = [rotated_o(1) + rotated_o_pivot(1); rotated_o(2) - rotated_o_pivot(2)];
    rotated.vertices = round([new_v1, new_pivot, new_v2]);

    %% Find vectors relative to pivot as origin
    box_edge1 = point_to_vector(new_pivot, new_v1);
    box_edge2 = point_to_vector(new_pivot, new_v2);
    
    if (norm(box_edge1) > norm(box_edge2))
        longest  = new_v1;
        shortest = new_v2;
        longest_pivot = box_edge1;
    else
        % Posso anche non farli e farli dopo
        shortest = new_v1;
        longest  = new_v2;

        longest_pivot = box_edge2;
    end

    %% Shear horizontal longest edge
    n_longest = longest_pivot / norm(longest_pivot);
    % M is the negative sine of the longest vector
    %% Il sengo dipende dal coseno/seno di n_longest (?)
    
    m = n_longest(2);
    save_M = M;
    
    %% Pivot is in rigth position relative to other vertices
    if (new_pivot(1) > new_v1(1) || new_pivot(1) > new_v2(1))
       m = -m;
       flag = 1;
    end
    %M = [1 0 0; m 1 0; 0 0 1];
    
    M = [1 m 0; 0 1 0; 0 0 1];
    T = maketform('affine', M);
    sheared.image = imtransform(rotated.image, T, R,'FillValues',0);
    
    if (n_longest(2) < 0 )
        m = m;
        sheared_o = find_new_origin(rotated.image, save_M);
        padding = 72;
        padding = [0; sheared_o(2)];
        padding = 72;
        r = rotated.image(:,1,1);
        g = rotated.image(:,1,2);
        b = rotated.image(:,1,3);
        left_corner_y_rotated = find(sum(rotated.image(:, 1, :), 3) > 0, 1); 
        left_corner_y_sheared = find(sum(sheared.image(:, 1, :), 3) > 0, 1); 
        y_padding = left_corner_y_sheared - left_corner_y_rotated;
        padding = [0; abs(y_padding)];
    else
        padding = [0; 0];
    end
    


    M = [1 0 0; m 1 0 ; 0 0 1];
    %M = [1 -m 0; 0 1 0 ; 0 0 1];
    new_v1    = M(1:2, 1:2) * new_v1;
    new_v2    = M(1:2, 1:2) * new_v2;
    new_pivot = M(1:2, 1:2) * new_pivot;
    
    %padding = [0; 329];
    new_v1 = new_v1 + padding;
    new_v2 = new_v2 + padding;
    new_pivot = new_pivot + padding;
    
    
    
    figure(7);
    imshow(sheared.image);
    plot_vertices(round([new_v1, new_pivot, new_v2]));
    
    m;
    
%{
 
    %% Find vectors before lineare transformation using top-left side as origin
    origin.pivot = 'origin';
    origin.value = [1; 1];
    origin_v1 =    point_to_vector(origin, new_v1);
    origin_v2 =    point_to_vector(origin, new_v2);
    origin_pivot = point_to_vector(origin, new_pivot);

    if (norm(box_edge1) > norm(box_edge2))
        longest  = new_v1;
        shortest = new_v2;
        longest_pivot = box_edge1;
    else
        % Posso anche non farli e farli dopo
        shortest = new_v1;
        longest  = new_v2;

        longest_pivot = box_edge2;
    end


 
%}



    
%{
 
    %% Find new origin after shear
    sheared_o = find_new_origin(sheared, save_M);
    
    %% Find vectors after rotation
    shear_v1    = (M(1:2, 1:2) * origin_v1);
    shear_v2    = (M(1:2, 1:2) * origin_v2);
    shear_pivot = (M(1:2, 1:2) * origin_pivot);
    
    %% Evaluate new vertices after shear using top-left as origin
    new_v1    = [sheared_o(1) + shear_v1(1);    sheared_o(2) - shear_v1(2)   ];
    new_v2    = [sheared_o(1) + shear_v2(1);    sheared_o(2) - shear_v2(2)   ];
    new_pivot = [sheared_o(1) + shear_pivot(1); sheared_o(2) - shear_pivot(2)];
    
    
    %% Find vectors relative to pivot as origin
    box_edge1 = point_to_vector(new_pivot, new_v1);
    box_edge2 = point_to_vector(new_pivot, new_v2);
    


    %% ---------- Shear ----------
    %%% Find new origin after rotation
    %[n_rows_rotated, n_cols_rotated] = size(rotated);
    
    %% Non sono sicuro di questa cosa
    sheared_o = rotated_o;
    sheared_o = find_new_origin(sheared, save_M);
    
    %% Find vectors after rotation
    shear_v1    = M(1:2, 1:2) * rotated_o_v1;
    shear_v2    = M(1:2, 1:2) * rotated_o_v2;
    shear_pivot = M(1:2, 1:2) * rotated_o_pivot;
    
    %% Evaluate new vertices after shear using top-left as origin
    new_v1    = [sheared_o(1) + shear_v1(1);    sheared_o(2) - shear_v1(2)   ];
    new_v2    = [sheared_o(1) + shear_v2(1);    sheared_o(2) - shear_v2(2)   ];
    new_pivot = [sheared_o(1) + shear_pivot(1); sheared_o(2) - shear_pivot(2)];
    
    %% Find vectors relative to pivot as origin
    box_edge1 = point_to_vector(new_pivot, new_v1);
    box_edge2 = point_to_vector(new_pivot, new_v2); 
%}

    
    if (norm(box_edge1) > norm(box_edge2))
        longest  = new_v1;
        shortest = new_v2;
    else
        % Posso anche non farli e farli dopo
        shortest = new_v1;
        longest  = new_v2;
    end
     

    
    %% Consider all cases to figure out the orientation
    if(     (box_edge1(2) == 0 && box_edge1(1) > 0 && box_edge2(2) < 0) || ...
            (box_edge2(1) == 0 && box_edge2(2) < 0 && box_edge1(2) > 0) || ...
            (box_edge2(2) == 0 && box_edge2(1) > 0 && box_edge1(2) < 0) || ...
            (box_edge1(1) == 0 && box_edge1(2) < 0 && box_edge2(2) > 0))
        %% NW
        rectangle_x = new_pivot(1);
        rectangle_y = new_pivot(2);
        rectangle_width  = new_pivot(1) - longest(1);
        rectangle_height = new_pivot(2) - shortest(2);

    elseif( (box_edge2(2) == 0 && box_edge2(1) < 0 && box_edge1(2) < 0) || ...
            (box_edge1(1) == 0 && box_edge1(2) < 0 && box_edge2(1) < 0) || ...
            (box_edge1(2) == 0 && box_edge1(1) < 0 && box_edge2(2) < 0) || ...
            (box_edge2(1) == 0 && box_edge2(2) < 0 && box_edge1(1) < 0))
        %% NE
        rectangle_x = longest(1);
        rectangle_y = longest(2);
        rectangle_width  = new_pivot(1) - longest(1);
        rectangle_height = longest(2) - shortest(2);

    elseif( (box_edge1(1) == 0 && box_edge1(2) > 0 && box_edge2(1) > 0) || ...
            (box_edge2(2) == 0 && box_edge2(1) > 0 && box_edge1(2) > 0) || ...
            (box_edge2(1) == 0 && box_edge2(2) > 0 && box_edge1(1) > 0) || ...
            (box_edge1(2) == 0 && box_edge1(1) > 0 && box_edge2(2) > 0) )
        %% SW
        rectangle_x = shortest(1);
        rectangle_y = shortest(2);
        rectangle_width  = longest(1) - new_pivot(1);
        rectangle_height = new_pivot(2) - shortest(2);

    elseif( (box_edge1(2) == 0 && box_edge1(1) < 0 && box_edge2(2) > 0) || ...
            (box_edge2(1) == 0 && box_edge2(2) > 0 && box_ede1(1) < 0)  || ...
            (box_edge2(2) == 0 && box_edge2(1) < 0 && box_edge1(2) > 0) || ...
            (box_edge1(1) == 0 && box_edge1(2) > 0 && box_edge2(1) < 0))
        %% SE
        rectangle_width  = new_pivot(1) - longest(1);
        rectangle_height = new_pivot(2) - shortest(2);
        rectangle_x = new_pivot(1) - rectangle_width;
        rectangle_y = longest(2) - rectangle_height;
        
        %{
        % Add padding
        padding_horizontal = rectangle_width * crop_padding * 0.5;
        padding_vertical = rectangle_height * crop_padding * 0.5;
        rectangle_x = rectangle_x - padding_horizontal;
        rectangle_y = rectangle_y - padding_vertical;
        rectangle_width  = rectangle_width  + padding_horizontal;
        rectangle_height = rectangle_height + padding_vertical;  
        %}


    end

    %% Add padding

    %{
    padding_horizontal = rectangle_width * crop_padding * 0.5;
    padding_vertical = rectangle_height * crop_padding * 0.5;
    
    rectangle_x = rectangle_x - padding_horizontal;
    rectangle_y = rectangle_y - padding_vertical;
    rectangle_width  = rectangle_width  + padding_horizontal;
    rectangle_height = rectangle_height + padding_vertical;  
    %}


    %% Crop box
    crop_rec = [rectangle_x, rectangle_y, rectangle_width, rectangle_height];
    box_cropped = imcrop(sheared.image, crop_rec); 

    figure(5);
    imshow(box_cropped);
end