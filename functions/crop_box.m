function [box_cropped, rotated, sheared, M] = ...
    crop_box(box_image, vertices, crop_padding)
    
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


    %% ---------- ROTATION ----------ì
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
    new_v1    = round([rotated_o(1) + rotated_o_v1(1);    rotated_o(2) - rotated_o_v1(2)   ]);
    new_v2    = round([rotated_o(1) + rotated_o_v2(1);    rotated_o(2) - rotated_o_v2(2)   ]);
    new_pivot = round([rotated_o(1) + rotated_o_pivot(1); rotated_o(2) - rotated_o_pivot(2)]);
    rotated.vertices = [new_v1, new_pivot, new_v2];


    %% Find vectors relative to pivot as origin
    box_edge1 = point_to_vector(new_pivot, new_v1);
    box_edge2 = point_to_vector(new_pivot, new_v2);
    
    if (norm(box_edge1) > norm(box_edge2))
        longest_edge = box_edge1;
    else
        longest_edge = box_edge2;
    end


    %% ---------- SHEAR ----------
    n_longest = longest_edge / norm(longest_edge);
    m = n_longest(2);
    

    %% Pivot is in rigth position relative to other vertices
    if (new_pivot(1) > new_v1(1) || new_pivot(1) > new_v2(1))
       m = -m;
    end
    

    %% Shear image horizontal
    M = [1 m 0; 0 1 0; 0 0 1];
    T = maketform('affine', M);
    sheared.image = imtransform(rotated.image, T, R,'FillValues',0);


    %% Find new origin
    left_corner_y_rotated = find(sum(rotated.image(:, 1, :), 3) > 0, 1); 
    left_corner_y_sheared = find(sum(sheared.image(:, 1, :), 3) > 0, 1); 
    y_padding = left_corner_y_sheared - left_corner_y_rotated;
    padding = [0; abs(y_padding)];
    

    %% Evaluate new vertices after shear
    M = [1 0 0; m 1 0 ; 0 0 1];
    new_v1    = M(1:2, 1:2) * new_v1    + padding;
    new_v2    = M(1:2, 1:2) * new_v2    + padding;
    new_pivot = M(1:2, 1:2) * new_pivot + padding;
    sheared.vertices = [new_v1, new_pivot, new_v2];
    
    if (norm(box_edge1) > norm(box_edge2))
        longest  = new_v1;
        shortest = new_v2;
        shortest_edge = box_edge2;
    else
        shortest = new_v1;
        longest  = new_v2;
        shortest_edge = box_edge1;
    end
     

    %% Consider all cases to figure out the Pivot orientation
    if( (box_edge1(1) == 0 && box_edge1(2) > 0 && box_edge2(1) > 0) || ...
            (box_edge2(2) == 0 && box_edge2(1) > 0 && box_edge1(2) > 0) || ...
            (box_edge2(1) == 0 && box_edge2(2) > 0 && box_edge1(1) > 0) || ...
            (box_edge1(2) == 0 && box_edge1(1) > 0 && box_edge2(2) > 0) )
        %% SW
        rectangle_x = shortest(1);
        rectangle_y = shortest(2);
        rectangle_width  = longest(1) - new_pivot(1);
        rectangle_height = new_pivot(2) - shortest(2);
        %% Add padding
        rectangle_y      = rectangle_y      - rectangle_height * crop_padding;
        rectangle_width  = rectangle_width  + rectangle_width  * crop_padding;
        rectangle_height = rectangle_height + rectangle_height * crop_padding;
    elseif( (box_edge1(2) == 0 && box_edge1(1) < 0 && box_edge2(2) > 0) || ...
            (box_edge2(1) == 0 && box_edge2(2) > 0 && box_ede1(1)  < 0) || ...
            (box_edge2(2) == 0 && box_edge2(1) < 0 && box_edge1(2) > 0) || ...
            (box_edge1(1) == 0 && box_edge1(2) > 0 && box_edge2(1) < 0))
        %% SE
        rectangle_width  = new_pivot(1) - longest(1);
        rectangle_height = new_pivot(2) - shortest(2);
        rectangle_x = new_pivot(1) - rectangle_width;
        rectangle_y = longest(2) - rectangle_height;
        %% Add padding
        rectangle_x      = rectangle_x      - rectangle_width  * crop_padding;
        rectangle_y      = rectangle_y      - rectangle_height * crop_padding;
        rectangle_width  = rectangle_width  + rectangle_width  * crop_padding;
        rectangle_height = rectangle_height + rectangle_height * crop_padding;
    end


    %% Crop box
    crop_rec = [rectangle_x, rectangle_y, rectangle_width, rectangle_height];
    box_cropped = imcrop(sheared.image, crop_rec); 

end