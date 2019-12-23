%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.5;
% 5, 6, 57
img_path = '../images/original/'+string(images{8}); %14; 21
[original, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
canny_edge = image_to_edge(target_image);
box_bw = canny2binary(canny_edge);

box_bw_vertices = box_bw;

[r, c] = size(box_bw);


%% Evaluate PIVOT
pivot = 'n';
valid_pivot = false;
x_proj = sum(box_bw);
y_proj = sum(box_bw');

% Pivot = N
y = find(y_proj > 0, 1, 'first');
x = find(box_bw(y, :)>0, 1, 'last');
n_vertex = [x; y];
% Pivot = S
y = find(y_proj > 0, 1, 'last');
x = find(box_bw(y, :) > 0, 1, 'first');
s_vertex = [x; y];
% Pivot = W
x = find(x_proj > 0, 1, 'first');
y = find(box_bw(:, x) > 0, 1, 'last');
w_vertex = [x; y];
% Pivot = E
x = find(x_proj > 0, 1, 'last');
y = find(box_bw(:, x) > 0, 1, 'first');
e_vertex = [x; y];

%% List of all vertices
vertices = [n_vertex, s_vertex, w_vertex, e_vertex];

% Distanza minore del 15% alora cambia il vertice perchè è un errore prospettico

%% Show results
figure(1);
subplot(2,2,1);imshow(original);title('Original Image');
subplot(2,2,2);imshow(box_bw);title('Box bw');
% Draw vertices on box
subplot(2,2,3);imshow(box_bw);title('Box bw vertices');
for i = 1:4
    hold on;
    plot(vertices(1, i), vertices(2, i),'r+','MarkerSize',30, 'LineWidth', 2); 
end
%%Draw vertices on Image
subplot(2,2,4);imshow(original);title('Original Image vertices');
vertices = vertices / scale_factor;
for i = 1:4
    hold on;
    plot(vertices(1, i), vertices(2, i),'r+','MarkerSize',30, 'LineWidth', 2); 
end