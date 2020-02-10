%% Load functions
addpath(genpath('functions/'));

%% Load classifier
boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;
%cutClassifier = load("classifier/cutClassifier.mat").cutClassifier;

%% Get list of images
images = readlist('../data/images.list');

%% Parameters
targetIndex = 4;
scaleFactor = 0.5;
paddingSize = 300;
debug = false;

%% Read image
imgPath = '../images/original/'+string(images{targetIndex});
[originalImage, scaledImage, targetImage] = ...
    read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2, true);

%% Find edges
cannyEdge = image_to_edge(targetImage, false);

%% Detect Box
boxMask = box_detection(cannyEdge, paddingSize, false);

%% Find box vertices
[vertices , rotNumber] = box_vertices(boxMask, paddingSize, true);

%% Classify box type
typeFeature = compute_type_feature(vertices);
boxType = boxTypeClassifier.predict(typeFeature);

%% Crop box from original image
cropTarget = originalImage;
sf = length(cropTarget) ./ length(scaledImage);
[cropped, tMatrix] = crop_box_perspective(cropTarget, sf, paddingSize, vertices, boxType, true);


%% Cut choccolates

%% Show results
figure;
imshow(cropped);