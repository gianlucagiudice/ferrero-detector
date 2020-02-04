%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.5;
% 5, 6, 57
img_path = '../images/original/'+string(images{20}); %14; 21
[original, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 2);
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

padding = 500;
A = padarray(box_mask_enhancement, [padding padding], 0, 'both');
se = strel('square', 100);
%box_mask_enhancement = imfill(A, 'holes');
box_mask_enhancement = imclose(A, se);
se = strel('square', 20);

box_mask_enhancement = imopen(box_mask_enhancement, se);

box_mask_enhancement = imfill(box_mask_enhancement, 'holes');

b = box_mask_enhancement;

border = edge(b, 'prewitt');

BW = border;

[r, c] = size(border);


%% Hough transform

figure(2);
[H,T,R] = hough(BW);
P = houghpeaks(H,3);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
plot(T(P(:,2)),R(P(:,1)),'s','color','white');

lines = houghlines(BW, T, R, P, 'FillGap', 200, 'MinLength', 200);
figure(1);
b = im2double(b);
[r, c] = size(BW);
for k = 1:length(lines);
    xy = [lines(k).point1; lines(k).point2];
    x1 = xy(1,1);
    y1 = xy(1,2);
    x2 = xy(2,1);
    y2 = xy(2,2);

    m = (y2-y1)/(x2-x1);
    b = insertShape(b, 'line', [1, m*(1-x1)+y1, c, m*(c-x1)+y1], 'LineWidth', 10);
    disp(m);
    %%line([1, c], [m*(1-x1)+y1, m*(c-x1)+y1], 'LineWidth', 2, 'Color', 'green');
end
imshow(b);


 
figure(3);
subplot(2,2,1);
imshow(box_mask_enhancement);
subplot(2,2,2);
imshow(border); 


