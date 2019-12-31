function [box_cropped, M] = crop_box(box_image, vertices, crop_padding)
    box_cropped = box_image;
    
    vector1 = vertices(2).value - vertices(1).value;
    vector2 = vertices(2).value - vertices(3).value;
    pivot = vertices(3).value;

    len1 = norm(vector1);
    len2 = norm(vector2);
    
    
    vec1 = point_to_vector(vertices(2), vertices(1));
    vec2 = point_to_vector(vertices(2), vertices(3));
    
    n1 = vec1 / len1;
    n2 = vec2 / len2;


    R = makeresampler({'cubic','nearest'},'fill');
    
    %% Rotate longest vector
    if (len1 < len2)
        longest = vec2;
        shortest = vec1;
        M = [n1(2) -n1(1) 0; n1(1) n1(2) 0; 0 0 1];
    else
        longest = vec1;
        shortest = vec2;
        M =  [n2(2) -n2(1) 0; n2(1) n2(2) 0; 0 0 1];
    end
    T = maketform('affine', M);
    rotated_image = imtransform(box_image, T, R,'FillValues',0);

    %% Evaluate vector after rotation
    vector1 = round(M(1:2, 1:2) * vector1);
    vector2 = round(M(1:2, 1:2) * vector2);
    vec1 = round(M(1:2, 1:2) * vec1);
    vec2 = round(M(1:2, 1:2) * vec2);
    
    len_edge = max(abs(longest));
    len_edge = len_edge + len_edge * crop_padding;

    
    %imcrop(rotated_image, )
    x_rectangle = min(abs([vector1(1), vector2(1), pivot(1)]));
    y_rectangle = min(abs([vector1(2), vector2(2), pivot(2)]));
    box_cropped = imcrop(rotated_image, [x_rectangle, y_rectangle, 20, 20]);
end