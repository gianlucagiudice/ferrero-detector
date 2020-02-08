%% Load functions
addpath(genpath('functions/'));

%% Load classifier
boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;

%% Get list of images
images = readlist('../data/images.list');

%% Parameters
targetIndex = 15;
scaleFactor = 0.5;
paddingSize = 300;

%% Read image
imgPath = '../images/original/'+string(images{targetIndex});
[originalImage, scaledImage, targetImage] = ...
    read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);

%% Process image
% Find edges
cannyEdge = image_to_edge(targetImage);

% Detect Box
boxMask = box_detection(cannyEdge, paddingSize);

% Find box vertices
vertices = box_vertices(boxMask, paddingSize);

% Classify box type
typeFeature = compute_type_feature(vertices);
boxType = boxTypeClassifier.predict(typeFeature);

% Crop box from original image
cropTarget = originalImage;
sf = length(cropTarget) ./ length(scaledImage);
cropped = crop_box_perspective(cropTarget, sf, paddingSize, vertices, boxType);

%% Show results
figure;
imshow(cropped);