relPath = "../";
addpath(genpath(relPath + 'functions/'));

%% Get list of images
images = readlist(relPath + 'data/images.list');
imgPadding = 300;
scaleFactor = 0.5;
targetIndex = 17;

tic

%% Read image
N = numel(images);

name = split(string(images{targetIndex}), '.');
path = "../images/cropEnhanced/cropEnhanced_" + name(1);
imgPath = path + ".png";

img = imread(imgPath);
choccolates = cut_type1(img);

%% Show results
figure(2);
for k = 1 : 24
    subplot(4, 6, k);
    imshow(choccolates{k});
    j = floor((k - 1)/6) + 1;
    i = mod((k - 1), 6) + 1;
    text = "(" + j + ", " + i + ")";
    title(text);
end

toc
