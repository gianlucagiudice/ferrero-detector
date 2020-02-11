addpath(genpath('../functions/'));
load('../../data/cuts.mat');

%% Read the data
T = readtable('../../data/cuts.csv', 'HeaderLines', 0);
images = T{:, 1};
labels = T{:, 2};

%% Read image
rocher = images(labels==1);
raffaello = images(labels==2);
rondnoir = images(labels==3);

imgPath = "../../images/cuts/"+rocher{5};
roc = imread(imgPath);

imgPath = "../../images/cuts/"+rondnoir{5};
ron = imread(imgPath);

imgPath = "../../images/cuts/"+raffaello{11};
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
title("Avg values channel"); 


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

%% Prewitt edge
imgPath = "../../images/cuts/"+images{753};
ron = imread(imgPath);

imgPath = "../../images/cuts/"+images{852};
rej = imread(imgPath);

ron_gray = rgb2gray(ron);
rej_gray = rgb2gray(rej);

ron_edge = edge(ron_gray, 'prewitt');
rej_edge = edge(rej_gray, 'prewitt');

ron_edge_filt = edge(imgaussfilt(ron_gray, 1.5), 'prewitt');
rej_edge_filt = edge(imgaussfilt(rej_gray, 1.5), 'prewitt');

ron_eq = histeq(ron_gray);
rej_eq = histeq(rej_gray);

ron_eq_edge = edge(ron_eq, 'prewitt');
rej_eq_edge = edge(rej_eq, 'prewitt');

ron_eq_edge_filt = edge(imgaussfilt(ron_eq, 1.5), 'prewitt');
rej_eq_edge_filt = edge(imgaussfilt(rej_eq, 1.5), 'prewitt');


figure(3);
subplot(3,4,1);imshow(ron_gray);title("Rondnoir");
subplot(3,4,2);imshow(rej_gray);title("Rejection");
subplot(3,4,5);imshow(ron_edge);title("Prewitt rondnoir");
subplot(3,4,6);imshow(rej_edge);title("Prewitt reject");
subplot(3,4,9);imshow(ron_edge_filt);title("Prewitt rondnoir gaussian (\sigma = 1.5)");
subplot(3,4,10);imshow(rej_edge_filt);title("Prewitt reject gaussian (\sigma = 1.5)");

subplot(3,4,3);imshow(ron_eq);title("Rondnoir eq");
subplot(3,4,4);imshow(rej_eq);title("Rejection eq");
subplot(3,4,7);imshow(ron_eq_edge);title("Prewitt rondnoir eq");
subplot(3,4,8);imshow(rej_eq_edge);title("Prewitt reject eq");
subplot(3,4,11);imshow(ron_eq_edge_filt);title("Prewitt rondnoir eq gaussian (\sigma = 1.5)");
subplot(3,4,12);imshow(rej_eq_edge_filt);title("Prewitt reject eq gaussian (\sigma = 1.5)");



%% LBP
plotR = 3; plotC = 3;

roc_lbp = compute_lbp(roc);
raf_lbp = compute_lbp(raf);
ron_lbp = compute_lbp(ron);

figure(4);
subplot(plotR,plotC,1);imshow(roc);title("Rocher_1 RGB");
subplot(plotR,plotC,2);imshow(raf);title("Raffaello_1 RGB");
subplot(plotR,plotC,3);imshow(ron);title("Rondnoir_1 RGB");

subplot(plotR,plotC,4);histogram(roc_lbp, 59);title("Rocher_2 LBP");
subplot(plotR,plotC,5);histogram(raf_lbp, 59);title("Raffaello_2 LBP");
subplot(plotR,plotC,6);histogram(ron_lbp, 59);title("Rondnoir_2 LBP");

imgPath = "../../images/cuts/"+rocher{60};
roc = imread(imgPath);
imgPath = "../../images/cuts/"+rondnoir{70};
ron = imread(imgPath);
imgPath = "../../images/cuts/"+raffaello{17};
raf = imread(imgPath);

subplot(plotR,plotC,7);histogram(roc_lbp, 59);title("Rocher_3 LBP");
subplot(plotR,plotC,8);histogram(raf_lbp, 59);title("Raffaello_3 LBP");
subplot(plotR,plotC,9);histogram(ron_lbp, 59);title("Rondnoir_3 LBP");

%% STD
figure(5);
imgPath = "../../images/cuts/"+images{753};
ron = imread(imgPath);
imgPath = "../../images/cuts/"+images{852};
rej = imread(imgPath);

ron_gray = rgb2gray(ron);
rej_gray = rgb2gray(rej);

subplot(2,2,1);imshow(ron_gray);title("Rondnoir");
subplot(2,2,2);imshow(rej_gray);title("Rejection");
subplot(2,2,3);imhist(ron_gray);title("Rondnoir hist");
subplot(2,2,4);imhist(rej_gray);title("Rejection hist");


%% Superpixel cut
A = rgb2hsv(roc);
A = A(:,:,2);
t = round(length(A) / 10);
A_F = medfilt2(A, [t t], 'symmetric');
[L,N] = superpixels(A_F,30);
BW = boundarymask(L);


outputImage = zeros(size(A),'like',A);
idx = label2idx(L);
numRows = size(A,1);
numCols = size(A,2);
for labelVal = 1:N
    i = idx{labelVal};
    outputImage(i) = mean(A_F(i));
end

figure(7);
subplot(2,2,1);
imshow(A);
subplot(2,2,2);
imshow(A_F);
subplot(2,2,3);
imshow(imoverlay(A_F,BW,'cyan'))
subplot(2,2,4);
imshow(outputImage)
