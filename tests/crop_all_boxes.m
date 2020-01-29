addpath(genpath('../functions/'));
load(fullfile('..', 'classifier_bayes.mat'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
crop_padding = 0.10;

%% Read image
% 55
parfor i = 1 : length(images_list)
    img_path = '../images/original/'+string(images_list{i});
    [~, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);

    %% Box edge
    canny_edge = image_to_edge(target_image);
    bw = canny2binary(canny_edge);

    %% Evaluate vertices
    vertices45 = find_vertices_45(bw);
    vertices90 = find_vertices_90(bw);
    best_vertices = decide_best_vertices(vertices45, vertices90);

    %% Cop box
    [box_cropped, rotated, sheared, rot_matrix] = ...
    crop_box(scaled_image, best_vertices, crop_padding);

    path = "../images/cropped/cropped_" + string(images_list{i});
    imwrite(box_cropped, path);
    disp(i);
end
