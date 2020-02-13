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
parfor targetIndex = 1:N
    %% Read image
    imgPath = 'images/original/'+string(images{targetIndex});
    [originalImage, scaledImage, targetImage] = ...
        read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2, debug);

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

    %% Find errors
    if boxType == 1
        % Cut square box
        choccolates = cut_type1(cropEnhanced, debug);
        % Find errors
        errors = find_errors1(choccolates, cutClassifier, debug);
    else
        % Cut box
        choccolates = cut_type2(cropEnhanced, debug);
        % Find errors in box
        errors = find_errors2(choccolates, cutClassifier, debug);
    end

    %% Get errors position in scaled image
    errorsPosition = inverse_transformation(tForm, errors, cropPadding);

    %% Plot errors on original image
    outImage = plot_errors(originalImage, vertices, errorsPosition, scaleFactor, paddingSize);

    %% Save results
    name = split(string(images{targetIndex}), '.');
    path = "../images/processed/"+name(1);
    imwrite(outImage, path + ".png");

    %% Processing status
    disp("Processed "+targetIndex + "-" + N);

end
toc
