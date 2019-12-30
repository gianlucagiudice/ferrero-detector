function box_cropped = crop_box(box_image, vertices, crop_padding)
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

    %% Shear factor = Cotangent 
    m1 = vec1(2) / vec1(1);
    m2 = vec2(2) / vec2(1);

    %% Provare con vector anzichè vec
    m1 = -(min(vec1(1), vec1(2)) / max(vec1(1), vec1(2)));
    m2 = +(min(vec2(1), vec2(2)) / max(vec2(1), vec2(2)));

    R = makeresampler({'cubic','nearest'},'fill');
    
    %{
 
    %% hardcoded image 32
    s_f = -0.06;
    s_f = m1;
    T = maketform('affine', [1 0 0; s_f 1 0; 0 0 1]);
    shear_vertical = imtransform(box_image, T, R,'FillValues',0); 

    s_f = +0.1826;
    s_f = m2;
    T = maketform('affine', [1 s_f 0; 0 1 0; 0 0 1]);
    shear = imtransform(shear_vertical, T, R,'FillValues',0); 
    
    %}

    %% Rotate longest vector
    if (len1 > len2)
        M = [n1(2) -n1(1) 0; n1(1) n1(2) 0; 0 0 1];
    else
        M =  [n2(2) -n2(1) 0; n2(1) n2(2) 0; 0 0 1];
    end
    T = maketform('affine', M);
    rotated_image = imtransform(box_image, T, R,'FillValues',0);

    figure(3);
    imshow(rotated_image);

    %% Calculate vector after rotation
    vec1 = round(M(1:2, 1:2) * vec1);
    vec2 = round(M(1:2, 1:2) * vec2);
    pivot = round(M(1:2, 1:2) * pivot);

    %% Shear Image
    if (abs(vec1(1)) > abs(vec1(2)))

        %% Shear horizontal vec1
        % Mettere max e min
        m1 = min(vec1(1), vec1(2)) / max(vec1(1), vec1(2));
        M = [1 -m1 0; 0 1 0; 0 0 1];
        T = maketform('affine', M);
        shear_horizontal = imtransform(rotated_image, T, R,'FillValues',0); 

        %% Shear vertical vec2

        % Mettere max e min
        m2 = vec2(2) / vec2(1);
        m2 = min(vec2(1), vec2(2)) / max(vec2(1), vec2(2));
        M = [1 0 0; -m2 1 0; 0 0 1];
        T = maketform('affine', M);
        shear_rotated = imtransform(shear_horizontal, T, R,'FillValues',0); 
    else
        
        %% Shear horizontal vec2
        % Mettere max e min
        m1 = min(vec2(1), vec2(2)) / max(vec2(1), vec2(2));
        M = [1 0 0; -m1 1 0; 0 0 1];
        T = maketform('affine', M);
        shear_horizontal = imtransform(rotated_image, T, R,'FillValues',0); 

        %% Shear vertical vec1

        % Mettere max e min
        m2 = vec1(2) / vec1(1);
        m2 = min(vec1(1), vec1(2)) / max(vec1(1), vec1(2));
        M = [1 -m2 0; 0 1 0; 0 0 1];
        T = maketform('affine', M);
        shear_rotated = imtransform(shear_horizontal, T, R,'FillValues',0);
        
    end






    box_cropped = shear_rotated;
end