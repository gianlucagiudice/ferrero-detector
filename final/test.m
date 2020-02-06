addpath(genpath('../functions/'));

%% Get list of images
images = readlist('../data/images.list');
scaleFactor = 0.5;
paddingSize = 300;


%% Ho solo aggiunto che l'immagine viene presa da un indice anzichè da out.png


%% Indici delle immagini da testare: 7
targetIndex = 15;

%% Read image
imgPath = '../images/original/'+string(images{targetIndex});
[~, scaledImage, targetImage] = read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);


%% Find edges
cannyEdge = image_to_edge(targetImage);

%% I vertici vanno cercati su questa immagine
boxLabel = box_detection(cannyEdge, paddingSize);

%% Da qui inziano i plot che avevi fatto tu
image = boxLabel;

vertices = box_vertices(boxLabel, paddingSize);

%% Crop box
type = 2; % Recatangular
cropped = crop_box_perspective(scaledImage, paddingSize, vertices, type);

figure;
imshow(cropped);


%{
 
figure;

imgPadding = padarray(rgb2gray(scaledImage), [paddingSize paddingSize], 0, 'both');
imshow(imgPadding);
bar = regionprops(boxLabel, 'Centroid');

viscircles(vertices(1, :), 10, 'Color', 'r');
viscircles(vertices(2, :), 10, 'Color', 'g');
viscircles(vertices(3, :), 10, 'Color', 'b');
viscircles(vertices(4, :), 10, 'Color', 'y');
 
%}
