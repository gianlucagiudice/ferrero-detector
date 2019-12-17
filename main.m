%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('data/images.list');

%% Read and manipulate the image
path = 'images/original/'+string(images{9});
scale_factor = 0.2;

%% Image Binarization
bw = image_to_edge(path, scale_factor);

%% Show results
for i = 1:30
    path = 'images/original/'+string(images{i});
    bw = image_to_edge(path, scale_factor);
    figure(i);
    imshow(bw)
end
