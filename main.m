addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

%% Processing
targetIndex = 46;

tic
    
imgPath = 'images/original/'+string(images{targetIndex});
[~, scaledImage, targetImage] = read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);
 
%% Find edges
cannyEdge = image_to_edge(targetImage);
 
%% Box detection
boxMask = box_detection(cannyEdge, imgPadding);

%% Crop Box
vertices = [937 29; 1450 328; 946 1031; 394 634];
type = 2; %% Recatangular

boxCropped = crop_box_perspective(scaledImage, vertices, type);

%% Show results
figure(1);
subplot(1,1,1);
imshow(boxCropped);

toc
