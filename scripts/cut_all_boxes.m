%% Cut all boxes
% load cropped images and separate all ROI into the images/cuts folder

relPath = "../";

addpath(genpath(relPath + 'functions/'));

%% Get list of images
images = readlist(relPath + 'data/images.list');
imgPadding = 300;
scaleFactor = 0.5;
debug = false;

%% Read image
N = numel(images);

tic
parfor targetIndex = 1 : N

    name = split(string(images{targetIndex}), '.');
    path = relPath + "images/cropEnhanced/" + name(1);
    imgPath = path + ".jpg";

    img = imread(imgPath);
    [r, c, ~] = size(img);

    %% Skip square boxes
    if r == c
        continue
    end

    %% Cut box
    choccolates = cut_type2(img, debug);

    %% Save cuts
    k = 1;
    for i = 1 : 4
        for j = 1 : 6
            name = split(string(images{targetIndex}), '.');
            fileName = name(1) + "-" + k; 
            path = relPath + "images/cuts/" + fileName + ".jpg";
            imwrite(choccolates{i, j}.value, path);
            k = k + 1;
        end

    end
    
end
toc
