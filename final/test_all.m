%% Load files
addpath(genpath('functions/'));
boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;

%% Parameters
relPath = "../";
images = readlist('../data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

%% Read images
disp('Start reading images . . .');
N = length(images);

parfor targetIndex = 1:N
    % Read image
    imgPath = relPath + 'images/original/'+string(images{targetIndex});
    [originalImage, ~, targetImage] = ...
        read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);
    % Save
    imgs{targetIndex}.targetImage = targetImage;
    imgs{targetIndex}.originalImage = originalImage;

    disp("Read "+targetIndex + " - "+N);

end

disp("Read completed.");
disp(" - - - - - - -");

%% Start processing
disp('Start processing . . .');

parfor targetIndex = 1:N
    % Get a target image
    targetImage = imgs{targetIndex}.targetImage;

    % Find edges
    cannyEdge = image_to_edge(targetImage);

    % I vertici vanno cercati su questa immagine
    boxMask = box_detection(cannyEdge, imgPadding);

    % Find vertices
    vertices = box_vertices(boxMask, imgPadding);

    % Classify box type
    typeFeature = compute_type_feature(vertices);
    boxType = boxTypeClassifier.predict(typeFeature);

    % Crop box from original image
    cropTarget = imgs{targetIndex}.originalImage;
    sf = length(cropTarget) ./ length(scaledImage);
    cropped = crop_box_perspective(cropTarget, sf, paddingSize, vertices, boxType);

    %% Save results
    name = split(string(images{targetIndex}), '.');
    path = "../images/cropped/cropped_" + name(1);
    imwrite(cropped, path + ".png");

    disp("Processed "+targetIndex + " - "+N);

end
