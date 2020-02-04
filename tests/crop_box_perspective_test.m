addpath(genpath('../functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

%% Processing
targetIndex = 5;

%% Read image
imgPath = '../images/original/'+string(images{targetIndex});
[~, scaledImage, targetImage] = read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);
 
%% Find edges
cannyEdge = image_to_edge(targetImage);
 
%% Box detection
boxMask = box_detection(cannyEdge, imgPadding);

%% Vertices
vertices90 = find_vertices_90(boxMask);
vertices45 = find_vertices_45(boxMask);
best_vertices = decide_best_vertices(vertices45, vertices90);

vertices = best_vertices - imgPadding;

%% Show results
figure(1);
%% Show orignal image
subplot(3,2,1)
imshow(scaledImage);title("Original Image");
%% Show binary image
subplot(3,2,2)
imshow(boxMask);title("Binary image Image");
%% Show vertices 90
subplot(3,2,3)
imshow(scaledImage);title("Vertices 90 method");
plot_vertices(vertices90);
%% Show vertices 45
subplot(3,2,4)
imshow(scaledImage);title("Vertices 45 method");
plot_vertices(vertices45);
%% Show best vertices
subplot(3,2,5)
imshow(scaledImage);title("Best vertices method");
plot_vertices(best_vertices);