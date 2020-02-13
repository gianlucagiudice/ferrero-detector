%% Load functions
addpath(genpath('functions/'));

%% Load classifier
boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;
cutClassifier = load("classifier/cutClassifier.mat").cutClassifier;

%% Get list of images
images = readlist('../data/images.list');


scaleFactor = 0.5;
paddingSize = 300;
debug = false;

parfor targetIndex = 1 : 64
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
    boxType = classify_box_type(vertices, boxTypeClassifier, debug);

    %% Crop box from original image
    [cropped, tForm] = crop_box_perspective(scaledImage, paddingSize, vertices, boxType, debug);

    %% Crop enhancement
    [cropEnhanced, cropPadding] = crop_enhancement(cropped, debug);

    %% Find errors
    if boxType == 1
        choccolates = cut_type1(cropEnhanced, true);
        
        for j = 1 : 24
            cuts1 = choccolates{j}.value;
            %% Save results
            name = split(string(images{targetIndex}), '.');
            path = "../images/cuts1/" + name(1) + "$" + j;
            imwrite(cuts1, path + ".png");
            
        end
    else
        continue;
    end
    
    disp(targetIndex);
    

end
