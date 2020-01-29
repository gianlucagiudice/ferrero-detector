addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
crop_padding = 0.10;

%% Process target image
%% 55
img_path = '../images/original/'+string(images_list{42});
[~, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);

canny_edge = image_to_edge(target_image);

bw = canny2binary(canny_edge);

vertices45 = find_vertices_45(bw);
vertices90 = find_vertices_90(bw);
best_vertices = decide_best_vertices(vertices45, vertices90);

[box_cropped, rotated, sheared, rot_matrix] = ...
crop_box(scaled_image, best_vertices, crop_padding);

[r, c, ch] = size(box_cropped);

hsv = rgb2hsv(box_cropped);
hsv_s = hsv(:,:,2);
hsv_s_eq = histeq(hsv_s);

%% Calcolare dinamicamente la finestra -> Considero scatola rettangolare
% Consider the size of a choccolate
% Obtained from dataset
choccolate_size_percentage = 0.166;
% Evaluate frame size
choccolate_fraction = 1/2;
tsize = round(r * choccolate_size_percentage * choccolate_fraction);

%% Evaluate labels
out = compute_local_descriptors(hsv_s, tsize, 10, @compute_average_color);

n_labels = 4;
labels = kmeans(out.descriptors, n_labels);
img_labels = reshape(labels, out.nt_rows, out.nt_cols);
img_labels_out = imresize(img_labels, [r, c], 'nearest');


labels_pos = [];
means_labels = [];
%% Evaluate mean of saturation relative to labels
for i = 1:n_labels
    means_labels(i) = mean(hsv_s(img_labels_out == i));
end
[~, raffaellos_index] = min(means_labels);
raffaellos_mask = img_labels_out == raffaellos_index;

%% Morphologic operator 
% Ideally consider choccolates as square
se = strel('square', tsize);
raffaellos_mask_closed = imclose(raffaellos_mask, se);
se = strel('square', tsize * 3);
raffaellos_mask_opened = imopen(raffaellos_mask_closed, se);
% Eorde mask
se = strel('disk', tsize);
raffaellos_mask_erode = imerode(raffaellos_mask_opened, se);


%% -------- Show results -------- 
figure(1);
subplot(1,2,1);
imshow(box_cropped);title("Box cropped"); 
subplot(1,2,2);
imshow(hsv_s); title("HSV_S");

%% Show difference between equalized and not equalized
%{
show_color_spaces(box_cropped, 98);
show_color_spaces(box_cropped_eq, 99);  
%}
