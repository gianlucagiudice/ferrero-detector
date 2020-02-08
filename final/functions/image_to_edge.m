function out_edge = image_to_edge(target_image, debug)
    %% Image enhancement
    target_image_filtered = medfilt2(target_image, [15 15]);
    F5 = fspecial('gaussian', 5, 3);
    target_image_smooth  = imfilter(target_image_filtered , F5, 'replicate');
    %% Find edges 
    [out_edge, t] = edge(target_image_smooth, 'Canny'); 

    if debug
        figure(1);
        subplot(2,3,1);
        imshow(target_image), title("Input image");
        subplot(2,3,2);
        imshow(target_image_filtered), title("Median filter 15x15");
        subplot(2,3,4);
        imshow(target_image_smooth), title("Smoothing");
        subplot(2,3,5);
        mesh(fspecial('gaussian', 5, 3));title("Gaussian filter (5x5, \sigma = 3)");
        subplot(2,3,6);
        imshow(out_edge); title("Canny edge (threshold = " + t + ")");
    end
end
