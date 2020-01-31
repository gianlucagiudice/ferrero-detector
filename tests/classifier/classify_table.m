addpath(genpath('../../functions/'));

image = imread("../../images/original/IMG_8634.JPG");
[r, c, ch] = size(image);

load('lbp');
load('cedd');
load('qhist');
load('labels');


feature = cedd;

%% Train classificatore
c = fitcknn(feature, labels,'NumNeighbors', 7);


out = compute_local_descriptors(image, 100, 100, @compute_CEDD);

predicted = predict(c, out.descriptors);

pixs = reshape(predicted, out.nt_rows,  out.nt_cols,1);


%img_labels = reshape(labels, out.nt_rows, out.nt_cols);

figure(2);
subplot(2,2,1);
imshow(image);

% Evaluate the target image
[r, c, ch] = size(image);

subplot(2,2,2);
imagesc(pixs), axis image;



%{
IMPORTANTE
Aggiungere sempre qualche cluster in più> 
%}
labels = kmeans(out.descriptors, 5);

img_labels = reshape(labels, out.nt_rows, out.nt_cols);
img_labels_filtered = medfilt2(img_labels, [5 5]);
img_labels_out = imresize(img_labels_filtered, [r, c], 'nearest');

figure(1);
subplot(1,2,1);imshow(im);
subplot(1,2,2);imagesc(img_labels_out), axis image;
