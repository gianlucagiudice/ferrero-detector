addpath(genpath('../functions/'));
load(fullfile('..', 'classifier_bayes.mat'));
change_color_space = @rgb2hsv;

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
crop_padding = 0.10;

%% Test particolari: 6, 8, 11, 37, 44
target_index = 46;

%% Read image
img_path = '../images/original/'+string(images_list{target_index});
[~, scaled_image, target_image] = ...
read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);

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

%% Find table mask
table_mask = find_table_mask_cropped(box_cropped);

%% Box enhanced
box_cropped_notable = box_cropped .* abs(1 - table_mask);
box_cropped_notable_eq = histeq(box_cropped_notable);

%% Box boundary mask
boundary_mask = find_boundary_mask(box_cropped_notable, 1500);


%% Show results
figure(1);
subplot(2,2,1); imshow(box_cropped);
subplot(2,2,2); imshow(box_cropped_notable);
subplot(2,2,3); imshow(box_cropped_notable_eq);
subplot(2,2,4); imshow(boundary_mask);


show_color_spaces(boundary_mask, 2);