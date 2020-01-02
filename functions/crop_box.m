function [box_cropped, rotated, M] = crop_box(box_image, vertices, crop_padding)

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
        M = [n1(2) -n1(1) 0; n1(1) n1(2) 0; 0 0 1];
    else
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

    rotated_v1    = round(M(1:2, 1:2) * v1);
    rotated_v2    = round(M(1:2, 1:2) * v2);
    rotated_pivot = round(M(1:2, 1:2) * pivot);

    %% Find new origin after rotation
    rotated_origin = find_new_origin(rotated, M);

    %% Evaluate new vertices
    rotated_origin_x = rotated_origin(1);
    rotated_origin_y = rotated_origin(2);

    new_v1    = [rotated_origin(1) + rotated_v1(1);    rotated_origin(2) - rotated_v1(2)   ];
    new_v2    = [rotated_origin(1) + rotated_v2(1);    rotated_origin(2) - rotated_v2(2)   ];
    new_pivot = [rotated_origin(1) + rotated_pivot(1); rotated_origin(2) - rotated_pivot(2)];

    %% Find vectors relative to pivot as origin
    box_edge1 = point_to_vector(new_pivot, new_v1);
    box_edge2 = point_to_vector(new_pivot, new_v2);

    if (norm(box_edge1) > norm(box_edge2))
        longest  = new_v1;
        shortest = new_v2;
    else
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
        % Add padding
        rectangle_width  = rectangle_width + rectangle_width * crop_padding;
        rectangle_height = rectangle_height + rectangle_height * crop_padding;
    elseif( (box_edge2(2) == 0 && box_edge2(1) < 0 && box_edge1(2) < 0) || ...
            (box_edge1(1) == 0 && box_edge1(2) < 0 && box_edge2(1) < 0) || ...
            (box_edge1(2) == 0 && box_edge1(1) < 0 && box_edge2(2) < 0) || ...
            (box_edge2(1) == 0 && box_edge2(2) < 0 && box_edge1(1) < 0))
        % NE
        rectangle_x = longest(1);
        rectangle_y = longest(2);
        rectangle_width  = new_pivot(1) - longest(1);
        rectangle_height = longest(2) - shortest(2);
        % Add padding
        rectangle_x = rectangle_x - rectangle_x * crop_padding;
        rectangle_height = rectangle_height - rectangle_height * crop_padding;
    elseif( (box_edge1(1) == 0 && box_edge1(2) > 0 && box_edge2(1) > 0) || ...
            (box_edge2(2) == 0 && box_edge2(1) > 0 && box_edge1(2) > 0) || ...
            (box_edge2(1) == 0 && box_edge2(2) > 0 && box_edge1(1) > 0) || ...
            (box_edge1(2) == 0 && box_edge1(1) > 0 && box_edge2(2) > 0) )
        % SW
        rectangle_x = shortest(1);
        rectangle_y = shortest(2);
        rectangle_width  = longest(1) - new_pivot(1);
        rectangle_height = new_pivot(2) - shortest(2);
        % Add padding
        rectangle_y = rectangle_y - rectangle_y * crop_padding;
        rectangle_width  = rectangle_width + rectangle_width * crop_padding;
    elseif( (box_edge1(2) == 0 && box_edge1(1) < 0 && box_edge2(2) > 0) || ...
            (box_edge2(1) == 0 && box_edge2(2) > 0 && box_ede1(1) < 0)  || ...
            (box_edge2(2) == 0 && box_edge2(1) < 0 && box_edge1(2) > 0) || ...
            (box_edge1(1) == 0 && box_edge1(2) > 0 && box_edge2(1) < 0))
        % SE
        rectangle_width  = new_pivot(1) - longest(1);
        rectangle_height = new_pivot(2) - shortest(2);
        rectangle_x = new_pivot(1) - rectangle_width;
        rectangle_y = longest(2) - rectangle_height;
        % Add padding

         padding_horizontal = rectangle_width * crop_padding * 0.5;
        padding_vertical = rectangle_height * crop_padding * 0.5;
        rectangle_x = rectangle_x - padding_horizontal;
        rectangle_y = rectangle_y - padding_vertical;
        rectangle_width  = rectangle_width  + padding_horizontal;
        rectangle_height = rectangle_height + padding_vertical; 

    end

    %% Crop box
    crop_rec = [rectangle_x, rectangle_y, rectangle_width, rectangle_height];
    box_cropped = imcrop(rotated, crop_rec); 

end