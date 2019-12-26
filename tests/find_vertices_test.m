addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;

%{
3; 7; 8; 16; 21; 22; 23; 24; 25; 27; 32; 34; 35; 36; 44; 51; 54 
%}

img_path = '../images/original/'+string(images_list{22});
[original, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
canny_edge = image_to_edge(target_image);
bw = canny2binary(canny_edge);
vertices90 = find_vertices_90(bw);
vertices45 = find_vertices_45(bw);

figure(1);
%% Show orignal image
subplot(3,2,1)
imshow(original);title("Original Image");
%% Show binary image
subplot(3,2,2)
imshow(bw);title("Binary image Image");
%% Show vertices 90
subplot(3,2,3)
imshow(original);title("Vertices 90 method");
plot_vertices(vertices90, scale_factor);
%% Show vertices 45
subplot(3,2,4)
imshow(original);title("Vertices 45 method");
plot_vertices(vertices45, scale_factor);
%% Show best vertices
subplot(3,2,5)
imshow(original);title("Best vertices method");
plot_vertices(vertices45, scale_factor);