function out_edge = image_to_edge(target_image)
    %% Image enhancement
    target_image_filtered = medfilt2(target_image, [11 11]);
    N = 13;
    opt_sigma = ((N-1) / 2) / 2.5;
    F3 = fspecial('gaussian', N , opt_sigma);
    target_image_filtered  = imfilter(target_image_filtered , F3, 'replicate');
    %% Find edges 
    %out_edge = edge(target_image_filtered, 'Sobel');
    out_edge = edge(target_image_filtered, 'Canny');
end