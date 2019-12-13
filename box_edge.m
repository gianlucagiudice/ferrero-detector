images = readlist('data/images.list');
path = 'images/'+string(images{14});

scale_factor = 1;
target_image = imread(path);
target_image = imresize(target_image, scale_factor);

hsv = rgb2hsv(target_image);
hsv_s = hsv(:, :, 2);
figure(1);
imshow(hsv_s);


%{
    NB: NON SONO SICURO DI QUELLO CHE HO SCRITTO
I filtri di edge, essendo delle derivate, sono molto sensibili al rimore,pertanto applico prima di tutto un filtro di smoothing 
%}

bw1 = edge(hsv_s, 'Canny');
bw2 = edge(hsv_s, 'log');
bw3 = edge(hsv_s, 'Sobel');
bw4 = edge(hsv_s, 'Prewitt');

figure(2);
subplot(2,2,1);imshow(bw1);title('Canny edge');
subplot(2,2,2);imshow(bw2);title('Log edge');
subplot(2,2,3);imshow(bw3);title('Sobel edge');
subplot(2,2,4);imshow(bw4);title('Prewitt edge');

% Sobel e prewitt funzionano meglio

%{
Applico un fltro mediano per miglirare edge di sobel 
%}


%{
bw = edge(hsv_s, 'Prewitt');
figure(2);
imshow(bw); 
%}
