%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('data/images.list');

%% Read and manipulate the image
path = 'images/original/'+string(images{9});
scale_factor = 0.2;

%% Image Binarization
%bw = image_to_edge(path, scale_factor);
limit_num = 30;
bws = {};
tic
parfor i = 1:limit_num
    bws{i} =  image_to_edge(path, scale_factor);
end
toc

%% Show results

for i = 1:limit_num
    figure(i);
    imshow(bws{i}); 
end

