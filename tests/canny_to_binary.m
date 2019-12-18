%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.3;
% 9; 15; 21; 23; 24; 
path = '../images/original/'+string(images{21}); %14; 21
canny_edge = image_to_edge(path, scale_factor);

%% Find box
[r, c] = size(canny_edge);
% 13px is the border size
out = compute_local_descriptors(canny_edge, 20, 5, @compute_average_color);
% Label the image using k-means clustering
labels = kmeans(out.descriptors, 3);
img_labels = reshape(labels, out.nt_rows, out.nt_cols);
img_labels_out = imresize(img_labels, [r, c], 'nearest'); 

%% Find label relative to background
label_on_box = zeros(1, length(unique(labels)));
for label = 1:length(unique(labels))
    label_on_box(label) = sum(img_labels_out == label .* canny_edge, 'all');
end
[~, bkg_label] = min(label_on_box);
bkg_image = img_labels_out == bkg_label;

%% Analisi componetni connesse ---> prendere area maggiore
figure(2);
imshow(img_labels_out == bkg_label);
%% Morfologia matematica

figure(1);
subplot(2,2,1);imshow(canny_edge);title('Edges');
subplot(2,2,2);imagesc(img_labels_out), axis image;title('Labels');
subplot(2,2,3);imshow(img_labels_out == bkg_label);title('Background'); 


%{
 
%% TEST TUTTI
limit_num = 40;
labels = {};
tic
parfor i = 1:limit_num
    path = '../images/original/'+string(images{i});
    c_e = image_to_edge(path, scale_factor);

    %% Find box
    [r, c] = size(c_e);
    % 13px is the border size
    out = compute_local_descriptors(c_e, 20, 5, @compute_average_color);
    % Label the image using k-means clustering
    lab = kmeans(out.descriptors, 3);
    img_labels = reshape(lab, out.nt_rows, out.nt_cols);
    im = imresize(img_labels, [r, c], 'nearest'); 
    labels{i} = im;
    
%{
 %% Find label relative to background
    label_on_box = zeros(1, length(unique(labels)));
    for label = 1:length(unique(labels))
        label_on_box(label) = sum(img_labels_out == label .* c_e, 'all');
    end
    [~, bkg_label] = min(label_on_box);
     
%}


end
toc

%% Show results
for i = 1:limit_num
    figure(i);
    imagesc(labels{i}), axis image;title('Labels');
end
 
%}
