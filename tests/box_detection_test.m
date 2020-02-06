%% Import functions
addpath(genpath('../functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.5;
img_padding = 300;

% Casi speciali: 6
img_path = '../images/original/'+string(images{1});
[original, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 2);

%% Find edges
canny_edge = image_to_edge(target_image);
 
%% Label edges
[r, c] = size(canny_edge);

% 30px is the border size
out = compute_local_descriptors(canny_edge, 10, 3, @compute_average_color);

% Label the image using k-means clustering
labels = kmeans(out.descriptors, 2);
img_labels = reshape(labels, out.nt_rows, out.nt_cols);
img_labels_out = imresize(img_labels, [r, c], 'nearest'); 

%% Find label relative to background
bkg_label = -1;
min_value = Inf;
for label = 1:unique(labels)
    cmp = mean(canny_edge(img_labels_out == label));
    if (cmp < min_value)
        min_value = cmp;
        bkg_label = label;
    end
end

elements = img_labels_out ~= bkg_label;

%% Delete all non-box elements
% Assume the box is the biggest element
objects = bwlabel(elements);
box_label = mode(objects(objects > 0), 'all');
box_mask = (objects == box_label);

%% Fill holes
box_filled = imfill(box_mask, 'holes');

%% Add padding to box
box_padding = padarray(box_filled, [img_padding img_padding], 0, 'both');

%% Delete elemnts connected to box
se = strel('disk', 60);
box_opened = imopen(box_padding, se);

%% Show results
figure(1);
subplot(2,4,1);imshow(canny_edge);title('Edges');
subplot(2,4,2);imagesc(img_labels_out), axis image; title('2-Kmeans Labels');
subplot(2,4,3);imshow(elements);title('All elements');
subplot(2,4,4);imagesc(objects), axis image;title('Elements labels');
subplot(2,4,5);imshow(box_mask);title('Box');
subplot(2,4,6);imshow(box_filled);title('Box holes filled');
subplot(2,4,7);imshow(box_padding);title('Box padding');
subplot(2,4,8);imshow(box_opened);title('Box imopen()');