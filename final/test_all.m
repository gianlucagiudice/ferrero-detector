addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

%% Read images
disp('Start reading images . . .');
parfor targetIndex = 1:length(images)
    % Read image
    imgPath = relPath + 'images/original/'+string(images{targetIndex});
    [~, ~, targetImage] = ...
        read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);
    imgs{targetIndex} = targetImage;

    disp("Read " + targetIndex + " - " + length(images));

end
disp("Read completed.");
disp(" - - - - - - -");

%% Start processing
disp('Start processing . . .');

parfor targetIndex = 1 : length(images)
    % Get a target image
    targetImage = imgs{targetIndex};
    % Find edges
    cannyEdge = image_to_edge(targetImage);
    % I vertici vanno cercati su questa immagine
    boxMask = box_detection(cannyEdge, imgPadding);
    % Find vertices
    vertices = box_vertices(boxMask, imgPadding);
    % Crop box
    cropped = crop_box_perspective(scaledImage, paddingSize, vertices, type);
    % Show results
    f = figure('visible', 'off');
    imshow(cropped);
    
    %% Save
    name = split(string(images{targetIndex}), '.');
    path = "../images/cropped/cropped_" + name(1);
    saveas(f, path, 'png');
    disp(targetIndex);

end

