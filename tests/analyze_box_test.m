addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
crop_padding = 0.10;

%% Process target image
img_path = '../images/original/'+string(images_list{50});
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


hsv = rgb2hsv(box_cropped);
ycbcr = rgb2ycbcr(box_cropped);


out = compute_local_descriptors(hsv(:,:,2), 30, 3, @compute_average_color);

labels = kmeans(out.descriptors, 3);

img_labels = reshape(labels, out.nt_rows, out.nt_cols);
img_labels_out = imresize(img_labels, [r, c], 'nearest');

%% Uso S =hsv(:,:,2) e Cb = YCbCr(:,:,2)

%% -------- Show results -------- 

figure(1);
subplot(1,2,1);
imshow(box_cropped);title("Box cropped"); 
subplot(1,2,2);
imshow(box);title("Box cropped"); 

figure(2);
imagesc(img_labels_out), axis image;

show_color_spaces(box_cropped, 98);
show_color_spaces(box_cropped_eq, 99);
