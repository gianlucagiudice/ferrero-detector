%% Load functions
addpath(genpath('functions/'));

%% Parameters
targetIndex = 6;
scaleFactor = 0.5;
paddingSize = 150;
debug = false;

%% Read image
imgPath = '../images/cropEnhanced/IMG_26.png';

img = imread(imgPath);


tagSize = round(0.0632 *0.5 * scaleFactor * length(img));


img = imresize(img, 0.5);


img_hsv = rgb2hsv(img);

img_hsv_s = img_hsv(:,:,2);

img_hsv_s_filt = medfilt2(img_hsv_s, [tagSize tagSize], 'symmetric');

tags = img_hsv_s_filt < 1/10;



%% Superpixel
table_pixels = [];

A = double(cat(3, tags, cat(3, tags, tags)));
[L,N] = superpixels(A,24);
figure(1);
BW = boundarymask(L);
imshow(imoverlay(A,BW,'cyan'))
outputImage = zeros(size(A),'like',A);
idx = label2idx(L);
numRows = size(A,1);
numCols = size(A,2);
for labelVal = 1:N
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    outputImage(redIdx) = mean(A(redIdx));
    outputImage(greenIdx) = mean(A(greenIdx));
    outputImage(blueIdx) = mean(A(blueIdx));
end    

figure(4);
imagesc(outputImage(:,:,1)); 


%% Morfologia matetmatica
se = strel('disk', tagSize * 2);
tagsClosed = imclose(tags, se);
se = strel('disk', tagSize/2);
tagsDilated = imdilate(tags, se);
se = strel('disk', tagSize);
tagsOpened = imopen(tagsDilated, se);


t1 = graythresh(img_hsv_s);
t2 = graythresh(img_hsv_s_filt);

disp(t1);
disp(t2);


figure(1);
subplot(2,2,1);
imshow(img_hsv_s);
subplot(2,2,2);
imshow(img_hsv_s_filt);
subplot(2,2,3);
imshow(tags);
subplot(2,2,4);
imshow(tagsOpened);

figure(2);
subplot(1,2,1);
imhist(img_hsv_s)
subplot(1,2,2);
imhist(img_hsv_s_filt);
