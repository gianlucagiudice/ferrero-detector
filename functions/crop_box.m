function box_cropped = crop_box(box_image, vertices, crop_padding)
    box_cropped = box_image;
    
    v1 = vertices(1).value - vertices(2).value;
    v2 = vertices(3).value - vertices(2).value;
    len1 = norm(v1);
    len2 = norm(v2);
    n1 = v1 / len1;
    n2 = v2 / len2;

    R = makeresampler({'cubic','nearest'},'fill');
    
    s_f = -0.06;
    T = maketform('affine', [1 0 0; s_f 1 0; 0 0 1]);
    shear_vertical = imtransform(box_image, T, R,'FillValues',0); 

    s_f = +0.12;
    T = maketform('affine', [1 s_f 0; 0 1 0; 0 0 1]);
    shear = imtransform(shear_vertical, T, R,'FillValues',0); 



    box_cropped = shear;
end