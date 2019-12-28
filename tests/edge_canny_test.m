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
    img_path = '../images/original/'+string(images{i});
    [original, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
    canny_edge{i} =  image_to_edge(target_image);
end
toc

%% Show results
figure(1);
for i = 1:limit_num
    figure(i);
    subplot(1,1,1);
    imshow(canny_edge{i}); 
end
