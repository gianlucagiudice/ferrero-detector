function out_edge = image_to_edge(target_image)
    debug = true;

    %% Image enhancement
    % 15
    
    target_image_filtered = medfilt2(target_image, [10 10]);
    F5 = fspecial('gaussian', 5, 3);
    target_image_smooth  = imfilter(target_image_filtered , F5, 'replicate');
    %% Find edges 
    [out_edge, t] = edge(target_image_smooth, 'Canny'); 

    if debug
        figure(1);
        subplot(2,2,1);
        imshow(target_image), title("Input image");
        subplot(2,2,2);
        imshow(target_image_filtered), title("medfilt2()");
        subplot(2,2,3);
        imshow(target_image_smooth), title("Gaussian filter()");
        subplot(2,2,4);
        imshow(out_edge), title("Canny edge");
    end
end
