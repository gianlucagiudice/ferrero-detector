%% Color spaces
% Displays the input image in rgb, hsv, ycbcr and lab color spaces
    
function show_color_spaces(target_image, figure_index)

    rgb = target_image;
    hsv = rgb2hsv(target_image);
    ycbcr = rgb2ycbcr(target_image);

    r = 3;
    c = 3;
    figure(figure_index);
    subplot(r,c,1); imshow(rgb(:,:,1)), title('RGB R');
    subplot(r,c,2); imshow(rgb(:,:,2)), title('RGB G');
    subplot(r,c,3); imshow(rgb(:,:,3)), title('RGB B');

    subplot(r,c,4); imshow(hsv(:,:,1)), title('HSV H');
    subplot(r,c,5); imshow(hsv(:,:,2)), title('HSV S');
    subplot(r,c,6); imshow(hsv(:,:,3)), title('HSV V');

    subplot(r,c,7); imshow(ycbcr(:,:,1)), title('YCbCr Y');
    subplot(r,c,8); imshow(ycbcr(:,:,2)), title('YCbCr Cb');
    subplot(r,c,9); imshow(ycbcr(:,:,3)), title('YCbCr Cr');

end
