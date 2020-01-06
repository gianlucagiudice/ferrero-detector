addpath(genpath('functions/'));

scale_factor = 0.5;

%% Read the data
T = readtable('../data/shapes.csv', 'HeaderLines', 0);  % skips the first three rows of data
images_list = T{:, 1};
labels = T{:, 2};



tic
for i = 1:length(images_list) 
    img_path = '../images/original/'+string(images_list{i});
    [~, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
    canny_edge = image_to_edge(target_image);
    bw = canny2binary(canny_edge);
    vertices90 = find_vertices_90(bw);
    vertices45 = find_vertices_45(bw);
    best_vertices = decide_best_vertices(vertices45, vertices90);

    %{
    sf = 0.10; 
    figure(i);
    imshow(imresize(scaled_image, sf));title("Best vertices method");
    plot_vertices(round([best_vertices.value] .* sf));
    %}

    imshow(scaled_image);title("Best vertices method");
end
toc
