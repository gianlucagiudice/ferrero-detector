addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Parameters
scaleFactor = 0.5;
paddingSize = 300;
targetIndex = 17;

%% Read image
imgPath = '../images/original/'+string(images{targetIndex});
[originalImage, scaledImage, targetImage] = ...
    read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);

%% Find edges
cannyEdge = image_to_edge(targetImage);

%% Detect Box
boxMask = box_detection(cannyEdge, paddingSize);

%% Find box vertices
vertices = box_vertices(boxMask, paddingSize);

%% Classify box type
type = 2; % Recatangular

%% Crop box from original image
cropped = crop_box_perspective(scaledImage, paddingSize, vertices, type);

%% Show results
figure;
imshow(cropped);