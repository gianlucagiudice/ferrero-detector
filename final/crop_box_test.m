addpath(genpath('../functions/'));

%% Get list of images
images = readlist('../data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

%% Processing
targetIndex = 46;

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

cropped = crop_box(targetImage, vertices, 2);


%% Show results
figure(1);
%% Show orignal image
subplot(2,2,1)
imshow(scaledImage);title("Original Image");
hold on;
% Plot vertice
for i = 1 : 4
    x = vertices(i, 1);
    y = vertices(i, 2);
    plot(x, y, 'g+', 'MarkerSize', 15, 'LineWidth', 2);
end
subplot(2,2,2)
imshow(Iwarp);title("Perspective adjust");
subplot(2,2,3)
imshow(boxCropped);title("Perspective adjust");
subplot(2,2,4)
imshow(boxCroppedRotated);title("Perspective adjust");
