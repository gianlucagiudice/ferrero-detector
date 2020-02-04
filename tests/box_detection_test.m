%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.5;
mask_padding = 150;

% 5, 6, 57
img_path = '../images/original/'+string(images{10}); %14; 21
[original, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 2);

canny_edge = image_to_edge(target_image);
 
%% Label edges
[r, c] = size(canny_edge);

% 13px is the border size
out = compute_local_descriptors(canny_edge, 30, 3, @compute_average_color);

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
elements = img_labels_out ~= bkg_label;

%% Delete all non-box elements
% Assume the box is the biggest element
objects = bwlabel(elements);
box_label = mode(objects(objects > 0), 'all');
box_mask = (objects == box_label);

box_filled = imfill(box_mask, 'holes');


%{
padding = 150;
A = padarray(box_mask_enhancement, [padding padding], 0, 'both');
se = strel('square', 100);
%box_mask_enhancement = imfill(A, 'holes');
box_mask_enhancement = imclose(A, se);
se = strel('square', 20);

box_mask_enhancement = imopen(box_mask_enhancement, se);

box_mask_enhancement = imfill(box_mask_enhancement, 'holes');

measurements = regionprops(box_mask_enhancement, 'BoundingBox');


ImagePoints = [766 216; 1372 346; 454 984; 1158 1184];

 
%}

%}



%{
 
% These are the points in the image
% Refence Points from Court Model
A = [0 0]'; 
B = [0 600]';
C = [300 0]';
D = [300 600]';
pin = ImagePoints;
pout = [A B C D]; % 2xN matrix of output

pout(2,:)=500-pout(2,:); %flip to agree with pin

H = fitgeotrans(pin,pout','projective');

[Iwarp, ref] = imwarp(scaled_image, H, 'OutputView', imref2d(size(scaled_image)));
 
%}



%{
ul = 766 216
ur = 1372 346
ll = 454 984
lr = 1158 1184 
%}



figure(1);
subplot(3,3,1);imshow(canny_edge);title('Edges');
subplot(3,3,2);imagesc(img_labels_out), axis image; title('2-Kmeans Labels');
subplot(3,3,3);imshow(elements);title('All elements');
subplot(3,3,4);imagesc(objects), axis image;title('Elements labels');
subplot(3,3,5);imshow(box_mask);title('Box');
subplot(3,3,6);imshow(box_filled);title('Box holes filled');
subplot(3,3,7);imshow(box_filled);title('Box enhancement');
subplot(3,3,8);imshow(box_filled);title('Box enhancement');

%{ 
figure(2);
imshow(box_mask_enhancement);

%}

 

%{
 
figure(3);
imshow(Iwarp);
 
%}
