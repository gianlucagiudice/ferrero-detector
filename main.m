clear all

%% Get list of images
files = dir('in/');
images = {files.name};
% Skip "./" and "../" folders
images = images(3 : numel(images));
%% Parameters
debug = false;

%% Start processing
tic
disp('Start processing . . .');
parfor targetIndex = 1 : numel(images)
    %% Read image
    imgPath = 'in/'+string(images{targetIndex});
    image = imread(imgPath);

    %% Process image
    outImage = process_image(image, debug);
    
    %% Save results
    name = split(string(images{targetIndex}), '.');
    path = "out/"+name(1);
    imwrite(outImage, path + ".jpg");

    %% Processing status
    disp("Processed " + targetIndex + "-" + numel(images));
end
toc