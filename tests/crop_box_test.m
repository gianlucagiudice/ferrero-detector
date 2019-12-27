addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;

%{
Alcuni vertici problemati
3; 7; 8; 16; 21; 22; 23; 24; 25; 27; 32; 34; 35; 36; 44; 51; 54

8, 3, 34, 35 = Casi esemplare
%}

img_path = '../images/original/'+string(images_list{32});
[original, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);

canny_edge = image_to_edge(target_image);

bw = canny2binary(canny_edge);

vertices45 = find_vertices_45(bw);
vertices90 = find_vertices_90(bw);
best_vertices = decide_best_vertices(vertices45, vertices90);
best_vertices = scale_vertices(best_vertices, scale_factor);


figure(1);
%% Show orignal image
subplot(2,2,1);
imshow(original);title("Original Image");
%% Show best vertices
subplot(2,2,2);
imshow(original);title("Best vertices method");
plot_vertices(best_vertices);
subplot(2,2,3);
imshow(original);title("Original Image");
