function color_spaces(target_image)

    rgb = target_image;
    hsv = rgb2hsv(target_image);
    ycbcr = rgb2ycbcr(target_image);
    lab = rgb2lab(target_image);

    r = 4;
    c = 3;
    figure;

    subplot(r,c,1); imshow(rgb(:,:,1)), title('RGB R');
    subplot(r,c,2); imshow(rgb(:,:,2)), title('RGB G');
    subplot(r,c,3); imshow(rgb(:,:,3)), title('RGB B');

    subplot(r,c,4); imshow(hsv(:,:,1)), title('HSV H');
    subplot(r,c,5); imshow(hsv(:,:,2)), title('HSV S');
    subplot(r,c,6); imshow(hsv(:,:,3)), title('HSV V');

    subplot(r,c,7); imshow(ycbcr(:,:,1)), title('YCbCr Y');
    subplot(r,c,8); imshow(ycbcr(:,:,2)), title('YCbCr Cb');
    subplot(r,c,9); imshow(ycbcr(:,:,3)), title('YCbCr Cr');

    subplot(r,c,10); imshow(lab(:,:,1), [0 100]), title('LAB L');
    subplot(r,c,11); imshow(lab(:,:,2), [0 100]), title('LAB A');
    subplot(r,c,12); imshow(lab(:,:,3), [0 100]), title('LAB B');

end