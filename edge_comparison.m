

images = readlist('data/images.list');
path = 'images/'+string(images{27});
%path = 'images/'+string(images{27});

scale_factor = 0.8;
% Read image
target_image = imread(path);
% Scale the image
target_image = imresize(target_image, scale_factor);

% Change color space
hsv = rgb2hsv(target_image);
hsv_s = hsv(:, :, 2);
hsv_s_eq = histeq(hsv_s);

% Non so se sia utile usare questi filtri
hsv_s_eq_filtered = medfilt2(hsv_s_eq, [5 5]);
F11 = fspecial('gaussian', 20 , 3);
hsv_s_eq_filtered  = imfilter(hsv_s_eq_filtered , F11);

figure(1);
subplot(1,3,1);imshow(hsv_s);title('HSV Saturaion');
subplot(1,3,2);imshow(hsv_s_eq);title('HSV Saturaion equalized');
subplot(1,3,3);imshow(hsv_s_eq_filtered);title('HSV Saturaion equalized filtered');
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
bw4_median = medfilt2(bw4, [3 3]);
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
