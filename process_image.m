%% Function
% Process the image passed as parameter and return the processed image. Set debug = true to display the intermediate steps
function outImage = process_image(image, debug)
    %% Load classifier
    boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;
    cutClassifier = load("classifier/cutClassifier.mat").cutClassifier;

    %% Parameters
    paddingSize = 300;
    scaleFactor = 0.5;

    %% Convert image to double
    originalImage = im2double(image);

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
        
end
