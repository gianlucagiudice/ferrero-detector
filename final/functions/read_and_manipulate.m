function [original, scaled_image, out_image] = read_and_manipulate(path, scale_factor, change_col_spc, ch, debug)
    %imresize(original)
    % Read image
    original = im2double(imread(path));
    out_image = original;
    % Change color space
    out_image = change_col_spc(out_image);
    % Get target channel
    out_image = out_image(:,:,ch);
    % Scale the image
    out_image = imresize(out_image, scale_factor);
    % Scaled image
    scaled_image = imresize(original, scale_factor);
    
    %% Insert debug here
    if debug
        figure(1);
        subplot(2,2,1);
        imshow(original);title("Original image");
        subplot(2,2,2);
        imshow(scaled_image);title("Scaled image");
        subplot(2,2,3);
        imshow(out_image);title("YCbCr_{Cb}");
    end
end