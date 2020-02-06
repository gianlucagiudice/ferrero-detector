addpath(genpath('../functions/'));

%% Get list of images
images = readlist('../data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

%% Processing
targetIndex = 21;

%% Read image
imgPath = '../images/original/'+string(images{targetIndex});
[~, scaledImage, targetImage] = read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);

%% Find edges
cannyEdge = image_to_edge(targetImage);

%% Box detection
boxLabel = box_detection(cannyEdge, imgPadding);

%% Find vertices
vertices = box_vertices(boxLabel, imgPadding);

type = 2; % Recatangular

%% Crop box
cropped = crop_box_perspective(scaledImage, imgPadding, vertices, 2);


%% Show results
figure(2);
%% Show orignal image
subplot(2,2,1)
imshow(scaledImage);title("Original Image");
subplot(2,2,2)
imshow(Iwarp);title("Perspective adjust");
subplot(2,2,3)
imshow(boxCropped);title("Perspective adjust");
subplot(2,2,4)
imshow(cropped);title("Perspective adjust");
