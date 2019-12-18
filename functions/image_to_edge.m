function out_edge = image_to_edge(path, scale_factor)
    %% Read and manipulate
    [~, target_image] = read_and_manipulate(path, scale_factor, @rgb2ycbcr, 3);
    %% Image enhancement
    target_image_filtered = medfilt2(target_image, [7 7]);
    N = 13;
    opt_sigma = ((N-1) / 2) / 2.5;
    F3 = fspecial('gaussian', N , opt_sigma);
    target_image_filtered  = imfilter(target_image_filtered , F3, 'replicate');
    %% Find edges 
    %out_edge = edge(target_image_filtered, 'Sobel');
    out_edge = edge(target_image_filtered, 'Canny');
end