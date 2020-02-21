%% Process single image
% Process a single image in the given dataset

clear all

relPath = "./";

addpath(genpath(relPath + 'functions'));

%% Get list of images
images = readlist(relPath + 'data/images.list');

%% Parameters
targetIndex = 32;
debug = false;

%% Read image
imgPath = relPath + 'images/original/'+string(images{targetIndex});
image = imread(imgPath);

%% Out image
outImage = process_image(image, debug);

%% Show output image
figure(99);
imshow(outImage);
