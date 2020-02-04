%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.5;
% 5, 6, 57
img_path = '../images/original/'+string(images{14}); %14; 21
[original, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 2);

%% Image enhancement
target_image_filtered = medfilt2(target_image, [15 15]);
F5 = fspecial('gaussian', 5, 3);
target_image_smooth  = imfilter(target_image_filtered , F5, 'replicate');
%% Find edges 
out_edge = edge(target_image_smooth, 'Canny');

figure(5);
subplot(2,2,1);
imshow(target_image);title("Input image");
subplot(2,2,2);
imshow(target_image_filtered);title("Median filter");
subplot(2,2,3);
imshow(target_image_smooth);title("Gaussian filter smoothing");
subplot(2,2,4);
imshow(out_edge);title("Canny edge detection");
