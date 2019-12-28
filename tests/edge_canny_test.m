%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');
scale_factor = 0.5;

%% Find edges
limit_num = 3;
canny_edge = {};
tic
for i = 1:limit_num
    path = '../images/original/'+string(images{i});
    canny_edge{i} =  image_to_edge(path, scale_factor);
end
toc

%% Show results
figure(1);
for i = 1:limit_num
    %figure(i);
    subplot(6,5,i);
    imshow(canny_edge{i}); 
end
