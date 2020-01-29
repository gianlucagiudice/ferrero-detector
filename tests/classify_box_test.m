addpath(genpath('../functions/'));
load(fullfile('..', 'classifier_bayes.mat'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
crop_padding = 0.10;

%% Read image
% 55
img_path = '../images/original/'+string(images_list{42});
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

%% Classification
[r, c, ch] = size(box_cropped);
pixs = reshape(box_cropped, r*c, 3);

predicted = predict(classifier_bayes, pixs);
predicted = reshape(predicted, r, c, 1);

%{
%% Morphologic operator 
% Ideally consider choccolates as square
se = strel('square', tsize);
raffaellos_mask_closed = imclose(raffaellos_mask, se);
se = strel('square', tsize * 3);
raffaellos_mask_opened = imopen(raffaellos_mask_closed, se);
% Eorde mask
se = strel('disk', tsize);
raffaellos_mask_erode = imerode(raffaellos_mask_opened, se);
%}


%% -------- Show results -------- 
figure(3);
subplot(2,4,1);
imshow(box_cropped);title("Box cropped"); 
subplot(2,4,2);
imagesc(predicted), axis image; title("Raffaello labels HSV_S");