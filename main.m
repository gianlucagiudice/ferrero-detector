addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('data/images.list');
scale_factor = 0.5;

%% Processing
start_limit = 62;
end_limit = 64;
bw_box = {};
images = {};

tic
for i = start_limit:end_limit
    % 9; 15; 21; 23; 24;    5, 6 57
    img_path = 'images/original/'+string(images_list{i});
    [original, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
    canny_edge = image_to_edge(target_image);
    bw = canny2binary(canny_edge);
    vertices = decide_best_vertices(find_vertices_45(bw), find_vertices_90(bw));
    
    %% Plot vertices
    figure(1);
    imshow(original);
    disp(i);
    hold on;
    plot_vertices(vertices, scale_factor);
    
end
toc
