

images = readlist('data/images.list');
path = 'images/original/'+string(images{15});
%path = 'images/extended/background_test/table_background_07.jpg';

scale_factor = 0.2;
% Read image
target_image = imread(path);
% Scale the image
target_image = imresize(target_image, scale_factor);

% Change color space
hsv = rgb2hsv(target_image);
hsv_s = hsv(:, :, 2);
hsv_s_eq = hsv_s;
hsv_s_eq_filtered = hsv_s;


% Non so se sia utile usare questi filtri

%{
 N = 100;
opt_sigma = ((N-1) / 2) / 2.5;
F11 = fspecial('gaussian', N , opt_sigma);
hsv_s_eq_filtered  = imfilter(hsv_s_eq_filtered , F11);
 
%}

hsv_s_eq_filtered = medfilt2(hsv_s_eq_filtered, [15 15]); 


figure(1);
subplot(2,3,1);imshow(hsv_s);title('HSV Saturaion');
subplot(2,3,2);imshow(hsv_s_eq);title('HSV Saturaion equalized');
subplot(2,3,3);imshow(hsv_s_eq_filtered);title('HSV Saturaion equalized filtered');
subplot(2,3,4);plot(imhist(hsv_s));
subplot(2,3,5);plot(imhist(hsv_s_eq));
subplot(2,3,6);plot(imhist(hsv_s_eq_filtered));


hsv_s_eq = hsv_s_eq_filtered;


%{
    NB: NON SONO SICURO DI QUELLO CHE HO SCRITTO
I filtri di edge, essendo delle derivate, sono molto sensibili al rimore,pertanto applico prima di tutto un filtro di smoothing 
%}

 
bw1 = edge(hsv_s_eq, 'Canny');
bw2 = edge(hsv_s_eq, 'log');
bw3 = edge(hsv_s_eq, 'Sobel');
bw4 = edge(hsv_s_eq, 'Prewitt');

figure(2);
subplot(2,2,1);imshow(bw1);title('Canny edge');
subplot(2,2,2);imshow(bw2);title('Log edge');
subplot(2,2,3);imshow(bw3);title('Sobel edge');
subplot(2,2,4);imshow(bw4);title('Prewitt edge');

% Sobel e prewitt funzionano meglio
figure(3)
imshow(bw3);title('Sobel edge');
figure(4)
imshow(bw4);title('Prewitt edge');

% Filtro mediano per eliminare punti isolati 
figure(5);
imshow(bw4_median);
 

%{
Applico un fltro mediano per miglirare edge di sobel 
%}

%{
bw = edge(hsv_s, 'Prewitt');
figure(2);
imshow(bw); 
%}
