clear all

addpath(genpath('functions'));

%% Get list of images
images = readlist('data/images.list');

%% Parameters
targetIndex = 14;
debug = true;

%% Read image
imgPath = 'images/original/'+string(images{targetIndex});
image = imread(imgPath);

%% Out image
outImage = process_image(image, debug);

%% Show output image
figure(99);
imshow(outImage);