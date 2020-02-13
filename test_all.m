clear all

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
    outImage = process_image(image, debug);
    
    %% Save results
    name = split(string(images{targetIndex}), '.');
    path = "images/processed/"+name(1);
    imwrite(outImage, path + ".png");

    %% Processing status
    disp("Processed "+targetIndex + "-" + N);

end

toc