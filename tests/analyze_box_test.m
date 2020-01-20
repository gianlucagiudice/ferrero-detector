addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
crop_padding = 0.10;

%% Process target image
img_path = '../images/original/'+string(images_list{55});
[~, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);

canny_edge = image_to_edge(target_image);

bw = canny2binary(canny_edge);

vertices45 = find_vertices_45(bw);
vertices90 = find_vertices_90(bw);
best_vertices = decide_best_vertices(vertices45, vertices90);

[box_cropped, rotated, sheared, rot_matrix] = ...
crop_box(scaled_image, best_vertices, crop_padding);

[r, c, ch] = size(box_cropped);

box_cropped_eq = histeq(box_cropped);


hsv = rgb2hsv(box_cropped_eq);
hsv_s = hsv(:,:,2);
%% Calcolare dinamicamente la finestra 
%out = compute_local_descriptors(hsv(:,:,2), 30, 3, @compute_average_color);
out = compute_local_descriptors(hsv_s, 30, 10, @compute_average_color);

n_labels = 3;
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

se = strel('disk',20);
raffaellos_mask_closed = imopen(raffaellos_mask, se);


%% Uso S =hsv(:,:,2) e Cb = YCbCr(:,:,2)

%% -------- Show results -------- 

figure(1);
subplot(1,2,1);
imshow(box_cropped);title("Box cropped"); 
subplot(1,2,2);
imshow(box_cropped);title("Box cropped"); 

figure(2);
subplot(1,3,1);
imagesc(img_labels_out), axis image; title("All labels");
subplot(1,3,2);
imshow(raffaellos_mask);
subplot(1,3,3);
imshow(raffaellos_mask_closed);

figure(3);
imshow(raffaellos_mask_closed .* box_cropped);

%{
show_color_spaces(box_cropped, 98);
show_color_spaces(box_cropped_eq, 99); 
%}
