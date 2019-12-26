addpath(genpath('functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;

%% Processing
start_limit = 14;
end_limit = 60;
bw_box = {};
images = {};

tic

% 9; 15; 21; 23; 24;    5, 6 57
img_path = '../images/original/'+string(images_list{60});
[original, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
canny_edge = image_to_edge(target_image);
bw = canny2binary(canny_edge);
%vertices = find_vertices(bw);
vertices = find_vertices_45(bw);

figure(1);
imshow(original);
hold on;

for j = 1:3
    x_plot = vertices(j).value(1) / scale_factor;
    y_plot = vertices(j).value(2) / scale_factor;
    if j == 2
        color = 'g+';
    else
        color = 'r+';
    end
    plot(x_plot, y_plot, color, 'MarkerSize',30, 'LineWidth', 2); 
end 

toc