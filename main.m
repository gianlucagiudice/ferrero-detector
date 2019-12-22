addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('data/images.list');
scale_factor = 0.5;

%% Processing
limit_num = 60;
bw_box = {};
images = {};

tic
parfor i = 1:limit_num
    % 9; 15; 21; 23; 24;    5, 6 57
    img_path = 'images/original/'+string(images_list{i});
    [original, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
    canny_edge = image_to_edge(target_image);
    bw_box{i} = canny2binary(canny_edge);
    
    %{
    % Store image{i}
    images{i}.original = original;
    images{i}.canny_edge = canny_edge;
    images{i}.bw_box = bw_box{i};
    images{i}.scale_factor = scale_factor; 
    %}
end
toc

%% Show results
for i = 1:limit_num
    figure(i);
    imshow(bw_box{i}); 
end

