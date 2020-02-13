function targetImage = manipulate(image, change_col_spc, ch, debug)
    % Change color space
    out_image = change_col_spc(image);
    % Get target channel
    targetImage = out_image(:,:,ch);
    
    if debug
        figure(1);
        subplot(1,2,1);
        imshow(image);title("Input image");
        subplot(1,2,2);
        imshow(targetImage);title("YCbCr_{Cb}");
    end
end