%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Read and manipulate the image
%path = 'images/extended/background_test/dots_background_04.jpg';
%path = 'images/extended/background_test/table_background_07.jpg';
%path = 'images/extended/background_test/white_background_01.jpg';
path = '../images/original/'+string(images{9});
scale_factor = 0.2;
color_space = @rgb2hsv;
channel = 2;
[original, target_image] = read_and_manipulate(path, scale_factor, color_space, channel);

%% Image enhancement
target_image_eq = histeq(target_image);
target_image_filtered = medfilt2(target_image, [3 3]);
N = 3;
opt_sigma = ((N-1) / 2) / 2.5;
F3 = fspecial('gaussian', N , opt_sigma);
target_image_filtered  = imfilter(target_image_filtered , F3);

%% Image binarization 
bw_canny = edge(target_image_filtered, 'Canny');
bw_log = edge(target_image_filtered, 'log');
bw_sobel = edge(target_image_filtered, 'Sobel');
bw_prewitt = edge(target_image_filtered, 'Prewitt');

%% Hough Transform
[H,T,R] = hough(bw_canny,'RhoResolution',0.5,'Theta',-90:0.5:89);

%% Show results
figure(1);
subplot(2,3,1);imshow(target_image);title('HSV S');
subplot(2,3,2);imshow(target_image_eq);title('HSV S equalized');
subplot(2,3,3);imshow(target_image_filtered);title('HSV S filtered');
subplot(2,3,4);plot(imhist(target_image));
subplot(2,3,5);plot(imhist(target_image_eq));
subplot(2,3,6);plot(imhist(target_image_filtered));

figure(2);
subplot(2,2,1);imshow(bw_canny);title('Canny edge');
subplot(2,2,2);imshow(bw_log);title('Log edge');
subplot(2,2,3);imshow(bw_sobel);title('Sobel edge');
subplot(2,2,4);imshow(bw_prewitt);title('Prewitt edge');

figure(3);
imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough transform of gantrycrane.png');
xlabel('\theta'), ylabel('\rho'); axis on, axis normal, hold on;
colormap(gca,hot);
