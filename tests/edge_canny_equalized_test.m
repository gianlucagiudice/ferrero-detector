%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.5;
% 5, 6, 57
img_path = '../images/original/'+string(images{39}); %14; 21
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

%% Pespective
ImagePoints = [1 1; 1 400; 400 400; 800 800];


% These are the points in the image
% Refence Points from Court Model
A = [100 100]'; 
B = [0 600]';
C = [300 0]';
D = [300 600]';
pin = ImagePoints;
pout = [A B C D]; % 2xN matrix of output

%pout(2,:)=500-pout(2,:); %flip to agree with pin

H = fitgeotrans(pin,pout','projective');

%[Iwarp, ref] = imwarp(scaled_image, H, 'OutputView', imref2d(size(scaled_image)));
[Iwarp, ref] = imwarp(scaled_image, H, 'OutputView', imref2d(size(scaled_image)));



%{
ul = 766 216
ur = 1372 346
ll = 454 984
lr = 1158 1184 
%}



figure(1);
imshow(scaled_image);

figure(2);
imshow(Iwarp);
