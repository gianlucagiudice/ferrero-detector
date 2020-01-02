function [box_cropped, rotated, M] = crop_box(box_image, vertices, crop_padding)
    box_cropped = box_image;
    
    %% Find vectors relative to pivot as origin
    box_edge1 = point_to_vector(vertices(2), vertices(1));
    box_edge2 = point_to_vector(vertices(2), vertices(3));
    
    len1 = norm(box_edge1);
    len2 = norm(box_edge2);
    
    n1 = box_edge1 / len1;
    n2 = box_edge2 / len2;

    %% Rotate longest edge
    R = makeresampler({'cubic','nearest'},'fill');
    if (len1 < len2)
        longest = box_edge2;
        shortest = box_edge1;
        M = [n1(2) -n1(1) 0; n1(1) n1(2) 0; 0 0 1];
    else
        longest = box_edge1;
        shortest = box_edge2;
        M =  [n2(2) -n2(1) 0; n2(1) n2(2) 0; 0 0 1];
    end
    T = maketform('affine', M);
    rotated = imtransform(box_image, T, R,'FillValues',0);
    
    %% Find vertex after rotating using top-left side as origin
    origin.pivot = 'origin';
    origin.value = [1; 1];
    v1 =    point_to_vector(origin, vertices(1));
    v2 =    point_to_vector(origin, vertices(3));
    pivot = point_to_vector(origin, vertices(2));

    v1_rotated    = round(M(1:2, 1:2) * v1);
    v2_rotated    = round(M(1:2, 1:2) * v2);
    pivot_rotated = round(M(1:2, 1:2) * pivot);

    %% Find new origin after rotation
    origin_rotated = find_new_origin(rotated, M);

    %% Evaluate new vertices
    x_origin = origin_rotated(1);
    y_origin = origin_rotated(2);

    new_v1    = [x_origin + v1_rotated(1); y_origin - v1_rotated(2)];
    new_v2    = [x_origin + v2_rotated(1); y_origin - v2_rotated(2)];
    new_pivot = [x_origin + pivot_rotated(1); y_origin - pivot_rotated(2)];

    %[x, y, width, height]

    %% Find vectors relative to pivot as origin
    box_edge1 = point_to_vector(new_pivot, new_v1);
    box_edge2 = point_to_vector(new_pivot, new_v2);
    
    %% Construct the rectangle to crop
    if(box_edge1(1) == 0 && len1 <= len2)
        if (box_edge1(2) >= 0)
            disp('sw');
        else
            disp('nw');
        end
    elseif(box_edge1(2) == 0 && len1 <= len2)
        if (box_edge1(1) >= 0)
            disp('nw');
        else
            disp('ne');
        end
    elseif(box_edge2(1) == 0 && len1 <= len2)
        if (box_edge2(2) >= 0)
            disp('sw');
        else
            disp('nw');
        end
    elseif(box_edge2(1) == 0 && len1 <= len2)
        if (box_edge2(2) >= 0)
            disp('sw');
        else
            disp('nw');
        end
    end

%{
 
    box_cropped = imcrop(rotated, [x_rectangle, y_rectangle, 20, 20]); 
 
%}

end