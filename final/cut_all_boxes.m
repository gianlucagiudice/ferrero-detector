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
    path = "../images/cropEnhanced/" + name(1);
    imgPath = path + ".png";

    img = imread(imgPath);
    [r, c, ~] = size(img);

    %% Skip square boxes
    if r == c
        continue
    end

    %% Cut box
    choccolates = cut_type1(img, debug);

    %% Save cuts
    for i = 1 : 24
        name = split(string(images{targetIndex}), '.');
        fileName = name(1) + "-cut$" + i; 
        path = "../images/cuts/" + fileName + ".png";
        imwrite(choccolates{i}, path);
    end
    

end
toc
