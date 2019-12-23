function out_edge = image_to_edge(target_image)
    %% Image enhancement
    target_image_filtered = medfilt2(target_image, [15 15]);
    F13 = fspecial('gaussian', 5, 3);
    target_image_filtered  = imfilter(target_image_filtered , F13, 'replicate');
    %% Find edges 
    %out_edge = edge(target_image_filtered, 'Sobel');
    out_edge = edge(target_image_filtered, 'Canny');
end