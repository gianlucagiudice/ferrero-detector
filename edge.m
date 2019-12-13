images = readlist('data/images.list');
path = 'images/' + string(images{4});

scale_factor = 1;
target_image = imread(path);
target_image = imresize(target_image, scale_factor);

hsv = rgb2hsv(target_image);
hsv_s = hsv(:,:,2);
figure(1);
imshow(hsv_s);

%%% I filtri di edge, essendo delle derivate, sono molto sensibili al rimore, pertanto applico prima di tutto un filtro di smoothing

