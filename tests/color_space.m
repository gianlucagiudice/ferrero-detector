% Change directory
cd('../functions');
% Read images list
images = readlist('../data/images.list');
path = '../images/original/' + string(images{12});

scale_factor = 0.3;
% Read image
target_image = imread(path);
% Scale image
target_image = imresize(target_image, scale_factor);

rgb = target_image;
hsv = rgb2hsv(target_image);
lab = rgb2lab(target_image);
ntsc = rgb2ntsc(target_image);
xyz = rgb2xyz(target_image);
ycbcr = rgb2ycbcr(target_image);

r = 6;
c = 3;
figure(1);
subplot(r,c,1); imshow(rgb(:,:,1)), title('RGB R');
subplot(r,c,2); imshow(rgb(:,:,2)), title('RGB G');
subplot(r,c,3); imshow(rgb(:,:,3)), title('RGB B');

subplot(r,c,4); imshow(hsv(:,:,1)), title('HSV H');
subplot(r,c,5); imshow(hsv(:,:,2)), title('HSV S');
subplot(r,c,6); imshow(hsv(:,:,3)), title('HSV V');

subplot(r,c,10); imshow(ycbcr(:,:,1)), title('YCbCr Y');
subplot(r,c,11); imshow(ycbcr(:,:,2)), title('YCbCr Cb');
subplot(r,c,12); imshow(ycbcr(:,:,3)), title('YCbCr Cr');

show_color_spaces(target_image, 2);