addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

%% Processing
targetIndex = 5;

tic
    
imgPath = 'images/original/'+string(images{targetIndex});
[~, scaledImage, targetImage] = read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);
 
%% Find edges
cannyEdge = image_to_edge(targetImage);
 
%% Box detection
boxMask = box_detection(cannyEdge, imgPadding);

%% Show results
figure(1);
subplot(1,1,1);
imshow(boxMask);

toc
