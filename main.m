%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('data/images.list');

%% Read and manipulate the image
path = 'images/original/'+string(images{5});
scale_factor = 0.2;

%% Image Binarization
limit_num = 30;
bws = {};
tic
parfor i = 1:limit_num
    path = 'images/original/'+string(images{i});
    bws{i} =  image_to_edge(path, scale_factor);
end
toc

figure(1);
%% Show results
for i = 1:limit_num
    %figure(i);
    subplot(6,5,i);
    imshow(bws{i}); 
end
