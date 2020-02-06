addpath(genpath('../functions/'));

%% Get list of images
images = readlist('../data/images.list');
scaleFactor = 0.5;
imgPadding = 300;
a = length(images);


parfor targetIndex = 1 : a
    %% Read image
    imgPath = '../images/original/'+string(images{targetIndex});
    [~, scaledImage, targetImage] = read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);
    
    %% Find edges
    cannyEdge = image_to_edge(targetImage);
    
    %% I vertici vanno cercati su questa immagine
    boxLabel = box_detection(cannyEdge, imgPadding);
    
    %% Da qui inziano i plot che avevi fatto tu
    image = boxLabel;
    
    out = box_vertices(boxLabel, imgPadding);
    

    f = figure('visible', 'off');

    imshow(rgb2gray(scaledImage));
    bar = regionprops(boxLabel, 'Centroid');
    
    viscircles(out.vertices_s(1, :) - imgPadding, 10, 'Color', 'r');
    viscircles(out.vertices_s(2, :) - imgPadding, 10, 'Color', 'g');
    viscircles(out.vertices_s(3, :) - imgPadding, 10, 'Color', 'b');
    viscircles(out.vertices_s(4, :) - imgPadding, 10, 'Color', 'y');

    %% Save
    name = split(string(images{targetIndex}), '.');
    path = "../images/vertices/vertices_" + name(1);
    saveas(f, path, 'png');
    disp(target_index);

end

