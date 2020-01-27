addpath(genpath('functions/'));

%% Get list of images
scale_factor = 0.5;

dir_names = {"none", "raffaello", "rocher", "rondnoir"};

raffaello = [];
rondnoir = [];
rocher = [];
none = [];

images_list = readlist('../data/images.list');
scale_factor = 0.5;

%% Plottare tutte le feature normalizzando per la dimensione
%% Equalizzare l'immagine

img_path = '../../images/labeled/' + string(images_list{5});
[original, scaled_image, ~] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
images{1} = scaled_image;
