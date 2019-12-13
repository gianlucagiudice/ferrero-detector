images = readlist('data/images.list');
% 14, 27
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

%{
bw1 = edge(hsv_s, 'Canny');
bw2 = edge(hsv_s, 'Prewitt');
bw3 = edge(hsv_s, 'log');

figure(2);
imshowpair(bw1, bw2, bw3, 'montage');
 
%}

bw = edge(hsv_s, 'Prewitt');
figure(1);
imshow(bw);