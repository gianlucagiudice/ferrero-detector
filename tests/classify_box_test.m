addpath(genpath('../functions/'));
load(fullfile('..', 'classifier_bayes.mat'));
change_color_space = @rgb2hsv;

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
crop_padding = 0.10;

%% Read image
% Casi particolari: 55, 
img_path = '../images/original/'+string(images_list{53});
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

%% Classification
classify_target = change_color_space(box_cropped); 
[r, c, ch] = size(classify_target);

%% Classify choccolates
pixs = reshape(classify_target, r*c, 3);
predicted = predict(classifier_bayes, pixs);
predicted = reshape(predicted, r, c, 1);

%% Classification enhancement
predicted_filtered = medfilt2(predicted, [15 15]);
table_mask = find_table_mask_cropped(box_cropped);
prediction = predicted_filtered .* abs(1 - table_mask);

%% Morphologic operator 
% Consider the size of a choccolate, btained from dataset
choccolate_size_percentage = 0.166;
% Evaluate frame size

%% Lables = [0 = table; 1 = raffaello; 2 = rocher; 3 = rondnoir]
%% NOTA BENE: Uso elemento strutturante quadrato perchè la sliding windows sarà quadrata

%% Adjust raffaello
raffaello = prediction == 1;
% Close small holes
choccolate_fraction = 1/5;
tsize = round(r * choccolate_size_percentage * choccolate_fraction);
se = strel('square', tsize);
raffaello_mask_closed = imclose(raffaello, se);
% Erase non-raffaello
choccolate_fraction = 1/2;
tsize = round(r * choccolate_size_percentage * choccolate_fraction);
se = strel('square', tsize);
raffaello_mask_opened = imopen(raffaello_mask_closed, se);
% Dilate raffaello
%{
choccolate_fraction = 1/4;
tsize = round(r * choccolate_size_percentage * choccolate_fraction);
se = strel('square', tsize);
raffaello_mask_dilated = imdilate(raffaello_mask_opened, se); 
%}


%% Adjust rondnoir
rondnoir = prediction == 3;
% Close small holes
choccolate_fraction = 1/5;
tsize = round(r * choccolate_size_percentage * choccolate_fraction);
se = strel('square', tsize);
rondnoir_mask_closed = imclose(rondnoir, se);
% Erase non-rondnoir
choccolate_fraction = 1/2;
tsize = round(r * choccolate_size_percentage * choccolate_fraction);
se = strel('square', tsize);
rondnoir_mask_opened = imopen(rondnoir_mask_closed, se);
% Dilate rondnoir
%{
choccolate_fraction = 1/4;
tsize = round(r * choccolate_size_percentage * choccolate_fraction);
se = strel('square', tsize);
rondnoir_mask_dilated = imdilate(rondnoir_mask_opened, se);
%}

%% Evaluate box enhanced
box_enhanced = zeros(r, c) + 2;
box_enhanced(raffaello_mask_opened) = 1;
box_enhanced(rondnoir_mask_opened) = 3;
box_enhanced(table_mask) = 0;

%% -------- Show results -------- 
figure(1);
%% Classification
subplot(3,4,1);
imshow(box_cropped);title("Box cropped"); 
subplot(3,4,2);
imagesc(predicted), axis image; title("Raffaello labels HSV_S");
subplot(3,4,3);
imagesc(predicted_filtered), axis image; title("Raffaello labels HSV_S");
subplot(3,4,4);
imagesc(prediction), axis image; title("Raffaello labels with table");
%% Raffaello
subplot(3,4,5);
imshow(raffaello), axis image; title("Raffaello mask");
subplot(3,4,6);
imshow(raffaello_mask_closed); title("Raffaello mask close");
subplot(3,4,7);
imshow(raffaello_mask_opened); title("Raffaello mask open");
subplot(3,4,8);
imshow(raffaello_mask_dilated); title("Raffaello mask open");
%% Rondnoir
subplot(3,4,9);
imshow(rondnoir), axis image; title("Raffaello mask");
subplot(3,4,10);
imshow(rondnoir_mask_closed); title("Raffaello mask close");
subplot(3,4,11);
imshow(rondnoir_mask_opened); title("Raffaello mask open");
subplot(3,4,12);
imshow(rondnoir_mask_dilated); title("Raffaello mask open");
%% Rocher
figure(2);
imagesc(box_enhanced), axis image; title("Box enhanced");