addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;

%{
Alcuni vertici problemati
3; 7; 8; 16; 21; 22; 23; 24; 25; 27; 32; 34; 35; 36; 44; 51; 54

8, 3, 34, 35 = Casi esemplare
%}

img_path = '../images/original/'+string(images_list{18});
[original, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
canny_edge = image_to_edge(target_image);
bw = canny2binary(canny_edge);
vertices90 = find_vertices_90(bw);
vertices45 = find_vertices_45(bw);
best_vertices = decide_best_vertices(vertices45, vertices90);

figure(1);
%% Show orignal image
subplot(3,2,1)
imshow(scaled_image);title("Original Image");
%% Show binary image
subplot(3,2,2)
imshow(bw);title("Binary image Image");
%% Show vertices 90
subplot(3,2,3)
imshow(scaled_image);title("Vertices 90 method");
plot_vertices(vertices90);
%% Show vertices 45
subplot(3,2,4)
imshow(scaled_image);title("Vertices 45 method");
plot_vertices(vertices45);
%% Show best vertices
subplot(3,2,5)
imshow(scaled_image);title("Best vertices method");
plot_vertices(best_vertices);