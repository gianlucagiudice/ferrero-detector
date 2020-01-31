addpath(genpath('../../functions/'));

image = imread("../../images/original/IMG_8634.JPG");
[r, c, ch] = size(image);

%% Train classificatore
image = imresize(image, 0.1);

image = imgaussfilt3(image);

out = compute_local_descriptors(image, 15, 10, @compute_CEDD);

labels = kmeans(out.descriptors, 3);

img_labels = reshape(labels, out.nt_rows, out.nt_cols);
img_labels_filtered = medfilt2(img_labels, [5 5]);
img_labels_out = imresize(img_labels_filtered, [r, c], 'nearest');

figure(9);
subplot(2,2,1);imshow(image);
subplot(2,2,2);imagesc(img_labels), axis image;
subplot(2,2,3);imagesc(img_labels_filtered), axis image;
subplot(2,2,4);imagesc(img_labels_out), axis image;
