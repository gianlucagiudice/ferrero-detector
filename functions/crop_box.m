function box_cropped = crop_box(box_image, vertices, crop_padding)
    box_cropped = box_image;
    
    

    vector1 = vertices(2).value - vertices(1).value;
    vector2 = vertices(2).value - vertices(3).value;

    len1 = norm(vector1);
    len2 = norm(vector2);
    
    % Forse non serve
    n1 = vector1 / len1;
    n2 = vector2 / len2;

    vec1 = vector_point_pivot(vertices(1), vertices(2));
    vec2 = vector_point_pivot(vertices(3), vertices(2));
    

    %% Shear factor = Cotangent 
    m1 = vec1(2) / vec1(1);
    m2 = vec2(2) / vec2(1);

    %% Provare con vector anzichè vec
    m1 = +(min(vec1(1), vec1(2)) / max(vec1(1), vec1(2)));
    m2 = -(min(vec2(1), vec2(2)) / max(vec2(1), vec2(2)));


    R = makeresampler({'cubic','nearest'},'fill');
    
    %% hardcoded image 32
    s_f = -0.06;
    s_f = m1;
    T = maketform('affine', [1 0 0; s_f 1 0; 0 0 1]);
    shear_vertical = imtransform(box_image, T, R,'FillValues',0); 

    s_f = +0.1826;
    s_f = m2;
    T = maketform('affine', [1 s_f 0; 0 1 0; 0 0 1]);
    shear = imtransform(shear_vertical, T, R,'FillValues',0); 



    box_cropped = shear;
end