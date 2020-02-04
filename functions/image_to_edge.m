function out_edge = image_to_edge(target_image)
    %% Image enhancement
    target_image_filtered = medfilt2(target_image, [15 15]);
    F5 = fspecial('gaussian', 5, 3);
    target_image_smooth  = imfilter(target_image_filtered , F5, 'replicate');
    %% Find edges 
    out_edge = edge(target_image_smooth, 'Canny'); 
end