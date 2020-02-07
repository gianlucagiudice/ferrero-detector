%% Load files
addpath(genpath('functions/'));
boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;

%% Parameters
relPath = "../";
images = readlist('../data/images.list');
scaleFactor = 0.5;
paddingSize = 300;

%% Start processing
tic
disp('Start processing . . .');

N = numel(images);
parfor targetIndex = 1:N
    imgPath = relPath + 'images/original/'+string(images{targetIndex});
    [originalImage, scaledImage, targetImage] = ...
        read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);

    % Find edges
    cannyEdge = image_to_edge(targetImage);

    % I vertici vanno cercati su questa immagine
    boxMask = box_detection(cannyEdge, paddingSize);

    % Find vertices
    vertices = box_vertices(boxMask, paddingSize);

    % Classify box type
    typeFeature = compute_type_feature(vertices);
    boxType = boxTypeClassifier.predict(typeFeature);

    % Crop box from original image
    cropTarget = originalImage;
    sf = length(cropTarget) ./ length(scaledImage);
    cropped = crop_box_perspective(cropTarget, sf, paddingSize, vertices, boxType);

    %% Save results
    name = split(string(images{targetIndex}), '.');
    path = "../images/cropped/cropped_"+name(1);
    imwrite(cropped, path + ".png");

    disp("Processed "+targetIndex + "-" + N);

end
toc
