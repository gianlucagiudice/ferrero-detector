relPath = "../";
addpath(genpath(relPath + 'functions/'));

%% Get list of images
images_list = readlist(relPath + 'data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

%% Processing
targetIndex = 46;

tic
    
imgPath = relPath + 'images/original/'+string(images{targetIndex});
[~, scaledImage, targetImage] = read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);
 
%% Find edges
cannyEdge = image_to_edge(targetImage);
 
%% Box detection
boxMask = box_detection(cannyEdge, imgPadding);

%% Crop Box
vertices = [945 40; 1430 325; 940 980; 435 620];
type = 2; %% Recatangular

boxCropped = crop_box_perspective(scaledImage, vertices, type);

%% Cut box
[r, c, ch] = size(boxCropped);
tWidth  = floor(c / 6);
tHeight = floor(r / 4);

choccolates = cell(4, 6);

k = 1;
for i = 1 : 4
    startIndexI = (i - 1) * tHeight + 1;
    endIndexI = i * tHeight;
    for j = 1 : 6
        startIndexJ = (j - 1) * tWidth + 1;
        endIndexJ   = j * tWidth;
        target = boxCropped(startIndexI:endIndexI, startIndexJ:endIndexJ, :);
        choccolates{k} = target;
        k = k +1;
    end
end

%% Save cuts
for i = 1 : 24
    name = split(string(images_list{targetIndex}), '.');
    fileName = name(1) + "_cut" + i; 
    path = "../images/cuts/" + fileName + ".png";
    imwrite(choccolates{i}, path);
end

%% Show results
figure(1);
subplot(1,1,1);
imshow(boxCropped);

figure(2);
for i = 1 : 24
    subplot(4, 6, i);
    imshow(choccolates{i});
end

toc
