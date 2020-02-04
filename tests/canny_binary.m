%% Import functions
addpath(genpath('../functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.3;
% 9; 15; 21; 23; 24;
% 5
img_path = '../images/original/'+string(images{5}); %14; 21
[original, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 2);
canny_edge = image_to_edge(target_image);

%% Find box
[r, c] = size(canny_edge);
% 13px is the border size
out = compute_local_descriptors(canny_edge, 20, 5, @compute_average_color);
% Label the image using k-means clustering
labels = kmeans(out.descriptors, 3);
img_labels = reshape(labels, out.nt_rows, out.nt_cols);
img_labels_out = imresize(img_labels, [r, c], 'nearest'); 

%% Find label relative to background
label_list = zeros(1, length(unique(labels)));
for label = 1:length(unique(labels))
    label_list(label) = sum(img_labels_out == label .* canny_edge, 'all');
end
[~, bkg_label] = min(label_list);
bkg_image = img_labels_out == bkg_label;

%% Analyze connected components of background to fill up box
bkg_labels = bwlabel(bkg_image);
% Area of background components
areas = histogram(bkg_labels(bkg_labels > 0));
% Real background label 
[~, real_bkg] = max(areas.Values);
% Find backgournd in box
bkg_mask = (bkg_labels ~= real_bkg) .* (bkg_labels > 0);
real_non_bkg = abs(bkg_image-1) | bkg_mask;

%% Find the box
objects = bwlabel(real_non_bkg);
areas = histogram(objects(objects > 0));
% Real boxlabel 
[~, box_label] = max(areas.Values);
% Find backgournd in box
box_mask = (objects == box_label) .* (objects > 0);
real_box = real_non_bkg & box_mask;

%% Enhancement
real_box = medfilt2(real_box, [50 50]);


figure(1);
subplot(3,2,1);imshow(canny_edge);title('Edges');
subplot(3,2,2);imagesc(img_labels_out), axis image; title('Labels');
subplot(3,2,3);imshow(bkg_image);title('Background'); 
subplot(3,2,4);imagesc(bkg_labels), axis image;title('Background Labels');
subplot(3,2,5);imshow(real_non_bkg);title('Box filled');
subplot(3,2,6);imshow(real_box);title('Box');
