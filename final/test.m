%% Load functions
addpath(genpath('functions/'));

%% Load classifier
boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;
cutClassifier = load("classifier/cutClassifier.mat").cutClassifier;

%% Get list of images
images = readlist('../data/images.list');

%% Parameters
targetIndex = 52;
scaleFactor = 0.5;
paddingSize = 300;
debug = false;

%% Read image
imgPath = '../images/original/'+string(images{targetIndex});
[originalImage, scaledImage, targetImage] = ...
    read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2, debug);

%% Find edges
cannyEdge = image_to_edge(targetImage, debug);

%% Detect Box
boxMask = box_detection(cannyEdge, paddingSize, debug);

%% Find box vertices
vertices = box_vertices(boxMask, paddingSize, debug);

%% Classify box type
typeFeature = compute_type_feature(vertices);
boxType = boxTypeClassifier.predict(typeFeature);

%% Crop box from original image
% Compute cropped image and spatial transformation structure
[cropped, tForm] = crop_box_perspective(scaledImage, paddingSize, vertices, boxType, debug);

%% Crop enhancement
[cropEnhanced, cropPadding] = crop_enhancement(cropped, debug);

%% Find errors
if boxType == 1
    % Type 1
else
    % Cut box
    choccolates = cut_type2(cropEnhanced, debug);
    save('choccolates', 'choccolates');
    % Find errors in box
    errors = find_errors2(choccolates, cutClassifier, true);
end

%% Get errors position in scaled image
errorsPosition = inverse_transformation(tForm, errors, cropPadding);

%% Plot errors on original image
outImage = plot_errors(originalImage, vertices, errorsPosition, scaleFactor, paddingSize);

%% Show image
figure(99);
imshow(outImage);