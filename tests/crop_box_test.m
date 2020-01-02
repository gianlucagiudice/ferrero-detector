addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
padding_crop = 0.10;


img_path = '../images/original/'+string(images_list{7});
[~, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);

canny_edge = image_to_edge(target_image);

bw = canny2binary(canny_edge);

vertices45 = find_vertices_45(bw);
vertices90 = find_vertices_90(bw);
best_vertices = decide_best_vertices(vertices45, vertices90);

[box_cropped, rotated, rot_matrix] = crop_box(scaled_image, best_vertices, padding_crop);


figure(1);
%% Show orignal image
subplot(2,2,1);
imshow(scaled_image);title("Original Image");
%% Show vertices on image
subplot(2,2,2);
imshow(scaled_image);title("Best vertices method");
plot_vertices(best_vertices);
%% Show vertices on bw
subplot(2,2,3);
imshow(bw);title("Bw box");
plot_vertices(best_vertices);
%% Show vertices on bw
subplot(2,2,4);
imshow(box_cropped);title("Box cropped");

figure(2);
imshow(rotated);