%% Load functions
addpath(genpath('functions/'));

%% Load classifier
boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;
cutClassifier = load("classifier/cutClassifier.mat").cutClassifier;

%% Get list of images
images = readlist('../data/images.list');

%% Parameters
targetIndex = 41;
scaleFactor = 0.5;
paddingSize = 300;
debug = false;

%% Read image
imgPath = '../images/original/'+string(images{targetIndex});
[originalImage, scaledImage, targetImage] = ...
    read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2, false);

%% Find edges
cannyEdge = image_to_edge(targetImage, false);

%% Detect Box
boxMask = box_detection(cannyEdge, paddingSize, false);

%% Find box vertices
vertices = box_vertices(boxMask, paddingSize, false);

%% Classify box type
typeFeature = compute_type_feature(vertices);
boxType = boxTypeClassifier.predict(typeFeature);

%% Crop box from original image
cropTarget = originalImage;
sf = length(cropTarget) ./ length(scaledImage);
% Compute cropped image and spatial transformation structure
[cropped, tForm] = crop_box_perspective(cropTarget, sf, paddingSize, vertices, boxType, false);

%% Crop enhancement
[cropEnhanced, padding] = crop_enhancement(cropped, false);

%% Classification
if boxType == 1
    % Type 1
else
    %% Cut box
    choccolates = cut_type_2(cropEnhanced, false);
    %% Find errors in box
    errors = find_errors_2(choccolates, cutClassifier, debug);
    disp(errors);
end

%% Get errors position in original image
%errorsPosition = inverse_transformation()