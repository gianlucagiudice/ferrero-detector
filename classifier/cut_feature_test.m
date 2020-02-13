addpath(genpath('../functions/'));
load('../data/cuts.mat');

%% Read the data
T = readtable('../data/cuts.csv', 'HeaderLines', 0);
images = T{:, 1};
labels = T{:, 2};

%% Read image
rocher = images(labels==1);
raffaello = images(labels==2);
rondnoir = images(labels==3);

imgPath = "../images/cuts/"+rocher{5};
roc = imread(imgPath);

imgPath = "../images/cuts/"+rondnoir{5};
ron = imread(imgPath);

imgPath = "../images/cuts/"+raffaello{11};
raf = imread(imgPath);

color_space = @rgb2ycbcr;

roc_cs = color_space(roc);
raf_cs = color_space(raf);
ron_cs = color_space(ron);

%% Plot features
labels = cuts.labels;
features = cuts.descriptors;

%% Average
avg = features.avg;

xData = avg(:,1); yData = avg(:,2); zData = avg(:,3);

figure(2);

cmap = [66,3,201;  
        215,27,59;
        58,107,53] / 255;

for targetLabel = 1 : 3
    mask = labels == targetLabel;
    scatter3(xData(mask), yData(mask), zData(mask), 30, cmap(targetLabel, :), 'filled');
    hold on
end
legend({'Rocher', 'Raffaello', 'Rondnoir'});

axis equal;
xlabel('Y val')
ylabel('Cb val')
zlabel('Cr val')
title("Avg color channel"); 


%% Show results
plotR = 4; plotC = 6;
figure(1);
subplot(plotR,plotC,1);imshow(roc);title("Rocher RGB");
subplot(plotR,plotC,2);imshow(roc_cs);title("Rocher YCbCr");
subplot(plotR,plotC,3);imshow(raf);title("Raffaello RGB");
subplot(plotR,plotC,4);imshow(raf_cs);title("Raffaello YCbCr");
subplot(plotR,plotC,5);imshow(ron);title("Rondnoir RGB");
subplot(plotR,plotC,6);imshow(ron_cs);title("Rondnoir YCbCr");
% Channel 1
subplot(plotR,plotC,7);imshow(roc_cs(:,:,1));title("Rocher Y");
subplot(plotR,plotC,8);imhist(roc_cs(:,:,1));title("Rocher Y");
subplot(plotR,plotC,9);imshow(raf_cs(:,:,1));title("Raffaello Y");
subplot(plotR,plotC,10);imhist(raf_cs(:,:,1));title("Raffaello Y");
subplot(plotR,plotC,11);imshow(ron_cs(:,:,1));title("Rondnoir Y");
subplot(plotR,plotC,12);imhist(ron_cs(:,:,1));title("Rondnoir Y");
% Channel 2
subplot(plotR,plotC,13);imshow(roc_cs(:,:,2));title("Rocher Cb");
subplot(plotR,plotC,14);imhist(roc_cs(:,:,2));title("Rocher Cb");
subplot(plotR,plotC,15);imshow(raf_cs(:,:,2));title("Raffaello Cb")
subplot(plotR,plotC,16);imhist(raf_cs(:,:,2));title("Raffaello Cb");
subplot(plotR,plotC,17);imshow(ron_cs(:,:,2));title("Rondnoir Cb");
subplot(plotR,plotC,18);imhist(ron_cs(:,:,2));title("Rondnoir Cb");
% Channel 3
subplot(plotR,plotC,19);imshow(roc_cs(:,:,3));title("Rocher Cr");
subplot(plotR,plotC,20);imhist(roc_cs(:,:,3));title("Rocher Cr");
subplot(plotR,plotC,21);imshow(raf_cs(:,:,3));title("Raffaello Cr");
subplot(plotR,plotC,22);imhist(raf_cs(:,:,3));title("Raffaello Cr");
subplot(plotR,plotC,23);imshow(ron_cs(:,:,3));title("Rondnoir Cr");
subplot(plotR,plotC,24);imhist(ron_cs(:,:,3));title("Rondnoir Cr");
