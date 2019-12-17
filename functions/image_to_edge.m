function out_edge = image_to_edge(path, scale_factor)
    %% Read and manipulate
    [~, target_image] = read_and_manipulate(path, scale_factor, @rgb2ycbcr, 3);
    %% Image enhancement
    target_image_filtered = medfilt2(target_image, [3 3]);
    N = 3;
    opt_sigma = ((N-1) / 2) / 2.5;
    F3 = fspecial('gaussian', N , opt_sigma);
    target_image_filtered  = imfilter(target_image_filtered , F3);
    %% Image binarization 
    out_edge = edge(target_image_filtered, 'Canny');
end