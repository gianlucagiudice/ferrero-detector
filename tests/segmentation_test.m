%% Import functions
addpath(genpath('functions/'));

images = readlist('../data/images.list');
%path = 'images/extended/background_test/dots_background_04.jpg';
%path = 'images/extended/background_test/table_background_07.jpg';
%path = 'images/extended/background_test/white_background_01.jpg';
%path = 'images/original/'+string(images{18});
path = '../images/original/'+string(images{5});


scale_factor = 0.01;
% Read image
target_image = imread(path);
% Scale the image
target_image = imresize(target_image, scale_factor);

% Segmentation
[r, c, ch] = size(target_image);


% Change color space
hsv = rgb2hsv(target_image);
hsv_s = hsv(:, :, 2);
hsv_s_eq = hsv_s;

hsv_s_eq_filtered = hsv_s;

hsv_s_eq_filtered = medfilt2(hsv_s_eq_filtered, [15 15]); 

N = 3;
opt_sigma = ((N-1) / 2) / 2.5;
F11 = fspecial('gaussian', N , opt_sigma);
hsv_s_eq_filtered  = imfilter(hsv_s_eq_filtered , F11);


%out = compute_local_descriptors(im, 5, 3, @compute_lbp);
out = compute_local_descriptors(hsv_s_eq_filtered, 5, 3, @compute_lbp);

%{
IMPORTANTE
Aggiungere sempre qualche cluster in più> 
%}
labels = kmeans(out.descriptors, 3);

img_labels = reshape(labels, out.nt_rows, out.nt_cols);
img_labels_filtered = medfilt2(img_labels, [5 5]);
img_labels_out = imresize(img_labels_filtered, [r, c], 'nearest');

figure(1);
subplot(2,3,1);imshow(target_image);
subplot(2,3,2);imshow(img_labels);
subplot(2,3,3);imagesc(img_labels_filtered), axis image;
subplot(2,3,3);imagesc(img_labels_out), axis image;




%{
 
% Change color space
hsv = rgb2hsv(target_image);
hsv_s = hsv(:, :, 2);
hsv_s_eq = hsv_s;

hsv_s_eq_filtered = hsv_s;

hsv_s_eq_filtered = medfilt2(hsv_s_eq_filtered, [15 15]); 

N = 10;
opt_sigma = ((N-1) / 2) / 2.5;
F11 = fspecial('gaussian', N , opt_sigma);
hsv_s_eq_filtered  = imfilter(hsv_s_eq_filtered , F11);
 
%}



figure(2);
subplot(2,3,1);imshow(hsv_s);title('HSV Saturaion');
subplot(2,3,2);imshow(hsv_s_eq);title('HSV Saturaion equalized');
subplot(2,3,3);imshow(hsv_s_eq_filtered);title('HSV Saturaion equalized filtered');
subplot(2,3,4);plot(imhist(hsv_s));
subplot(2,3,5);plot(imhist(hsv_s_eq));
subplot(2,3,6);plot(imhist(hsv_s_eq_filtered));


hsv_s_eq = hsv_s_eq_filtered;

