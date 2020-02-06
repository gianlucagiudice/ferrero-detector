addpath(genpath('../functions/'));

%% Get list of images
images = readlist('../data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

parfor targetIndex = 1 : length(images)
    %% Read image
    imgPath = '../images/original/'+string(images{targetIndex});
    [~, scaledImage, targetImage] = read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);
    
    %% Find edges
    cannyEdge = image_to_edge(targetImage);
    
    %% I vertici vanno cercati su questa immagine
    boxLabel = box_detection(cannyEdge, imgPadding);
    
    %% Find vertices
    vertices = box_vertices(boxLabel, imgPadding);
    
    %% Crop box
    cropped = crop_box_perspective(scaledImage, paddingSize, vertices, type);

    %% Show results
    f = figure('visible', 'off');
    imshow(cropped);

    %% Save
    name = split(string(images{targetIndex}), '.');
    path = "../images/cropped/cropped" + name(1);
    saveas(f, path, 'png');
    disp(targetIndex);

end

