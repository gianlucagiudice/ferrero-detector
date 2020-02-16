%% Load files
addpath(genpath('functions/'));
boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;

%% Parameters
images = readlist('data/images.list');
scaleFactor = 0.5;
paddingSize = 300;
debug = false;

%% Start processing
tic
disp('Start processing . . .');

N = numel(images);
for targetIndex = 1:N
    %% Read image
    imgPath = 'images/original/'+string(images{targetIndex});

    %% Convert image to double
    image = im2double(imread(imgPath));

    %% Scale image
    scaledImage = imresize(image, scaleFactor);

    %% Get target color space
    targetImage = manipulate(scaledImage, @rgb2ycbcr, 3, debug);

    %% Find edges
    cannyEdge = image_to_edge(targetImage, debug);

    %% Detect Box
    boxMask = box_detection(cannyEdge, paddingSize, debug);

    %% Find box vertices
    vertices = box_vertices(boxMask, paddingSize, debug);

    %% Classify box type
    boxType = classify_box_type(vertices, boxTypeClassifier, debug);

    %% Crop box from original image
    [cropped, tForm] = crop_box_perspective(scaledImage, paddingSize, vertices, boxType, debug);

    %% Crop enhancement
    [cropEnhanced, cropPadding] = crop_enhancement(cropped, debug);

    %% Save results
    name = split(string(images{targetIndex}), '.');
    path = "images/cropEnhanced/"+name(1);
    imwrite(cropEnhanced, path + ".jpg");

    disp("Processed "+targetIndex + "-" + N);

end
toc
