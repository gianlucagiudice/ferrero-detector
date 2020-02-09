relPath = "../";
addpath(genpath(relPath + 'functions/'));
boxTypeClassifier = load("classifier/boxTypeClassifier.mat").boxTypeClassifier;
cutClassifier = load("classifier/cutClassifier.mat").cutClassifier;

debug = true;

%% Get list of images
images = readlist(relPath + 'data/images.list');
imgPadding = 300;
scaleFactor = 0.5;
targetIndex = 49;

tic

%% Read image
N = numel(images);

name = split(string(images{targetIndex}), '.');
path = "../images/cropEnhanced/" + name(1);
imgPath = path + ".png";

img = imread(imgPath);
choccolates = cut_type1(img, true);

%% Predict box
prediction = predict_type1(choccolates, cutClassifier, debug);



toc
