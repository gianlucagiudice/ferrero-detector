%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.5;
% 5, 6, 57
img_path = '../images/original/'+string(images{28}); %14; 21
[original, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
canny_edge = image_to_edge(target_image);

%% Label edges
[r, c] = size(canny_edge);
% 13px is the border size
out = compute_local_descriptors(canny_edge, 11, 5, @compute_average_color);
% Label the image using k-means clustering
labels = kmeans(out.descriptors, 2);
img_labels = reshape(labels, out.nt_rows, out.nt_cols);
img_labels_out = imresize(img_labels, [r, c], 'nearest'); 

%% Find label relative to background
label_list = zeros(1, length(unique(labels)));
for label = 1:length(unique(labels))
    label_list(label) = sum(img_labels_out == label .* canny_edge, 'all');
end
[~, bkg_label] = min(label_list);
elements = img_labels_out ~= bkg_label;

%% Delete all non-box elements
% Assume the box is the biggest element
objects = bwlabel(elements);
box_label = mode(objects(objects > 0), 'all');
box_mask = (objects == box_label);

%% Box enhancement
box_mask_enhancement = medfilt2(box_mask, [15 15]);

figure(1);
subplot(3,2,1);imshow(canny_edge);title('Edges');
subplot(3,2,2);imagesc(img_labels_out), axis image; title('2-Kmeans Labels');
subplot(3,2,3);imshow(elements);title('All elements');
subplot(3,2,4);imagesc(objects), axis image;title('Elements labels');
subplot(3,2,5);imshow(box_mask);title('Box');
subplot(3,2,6);imshow(box_mask_enhancement);title('Box enhancement');
