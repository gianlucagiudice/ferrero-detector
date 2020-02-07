%% Load functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Parameters
targetIndex = 7;
scaleFactor = 0.5;
paddingSize = 300;

%% Read image
N = numel(images);

parfor targetIndex = 1:N
    name = split(string(images{targetIndex}), '.');
    path = "../images/cropped/cropped_" + name(1);
    imgPath = path + ".png";

    img = imread(imgPath);

    [r, c, ~] = size(img);

    if r == c
        p = 0.05;
    else
        p = 0.04;
    end

    crop = imcrop(img, [c*p r*p c-2*c*p r-2*r*p]);
    
    %% Save results
    name = split(string(images{targetIndex}), '.');
    path = "../images/crop_enhanced/cropped_" + name(1);
    imwrite(crop, path + ".png");
    
    disp(targetIndex);

end
