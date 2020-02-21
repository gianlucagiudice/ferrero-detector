%% Test all
% Test all images inside the images/original folder, save the processed output into the images/processed folder

clear all

addpath(genpath('functions'));
%% Get list of images
images = readlist('data/images.list');

%% Parameters
debug = false;

%% Start processing
tic
disp('Start processing . . .');

parfor targetIndex = 1 : numel(images)
    %% Read image
    imgPath = 'images/original/'+string(images{targetIndex});
    image = imread(imgPath);

    %% Process image
    try
        outImage = process_image(image, debug);
    catch exception
        disp("Error: " + targetIndex);
        continue
    end
    
    %% Save results
    name = split(string(images{targetIndex}), '.');
    path = "images/processed/"+name(1);
    imwrite(outImage, path + ".jpg");

    %% Processing status
    disp("Processed "+targetIndex + "-" + numel(images));
end

toc
