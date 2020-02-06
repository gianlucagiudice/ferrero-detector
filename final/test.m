addpath(genpath('../functions/'));

%% Get list of images
images = readlist('../data/images.list');
scaleFactor = 0.5;
imgPadding = 300;


%% Ho solo aggiunto che l'immagine viene presa da un indice anzichè da out.png


%% Indici delle immagini da testare: 7
targetIndex = 18;

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

figure(1);
imshow(rgb2gray(scaledImage));
bar = regionprops(boxLabel, 'Centroid');

viscircles(out.vertices_s(1, :) - imgPadding, 10, 'Color', 'r');
viscircles(out.vertices_s(2, :) - imgPadding, 10, 'Color', 'g');
viscircles(out.vertices_s(3, :) - imgPadding, 10, 'Color', 'b');
viscircles(out.vertices_s(4, :) - imgPadding, 10, 'Color', 'y');
