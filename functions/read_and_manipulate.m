function [original, out_image] = read_and_manipulate(path, scale_factor, change_col_spc, ch)
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
end