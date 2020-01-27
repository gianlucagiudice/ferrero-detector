addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('../../data/images.list');
scale_factor = 0.5;

images = {};

img_path = '../../images/original/'+string(images_list{5});
[original, scaled_image, ~] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
images{1} = scaled_image;

img_path = '../../images/original/'+string(images_list{32});
[original, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
images{2} = scaled_image;

%% Show results
figure(1);
subplot(2,2,1)
imshow(images{1});title("Ligth Image");
subplot(2,2,2)
imshow(histeq(images{1}));title("Ligth Image Equalized");
subplot(2,2,3)
imshow(images{2});title("Dark Image");
subplot(2,2,4)
imshow(histeq(images{2}));title("Dark image Equalized");
