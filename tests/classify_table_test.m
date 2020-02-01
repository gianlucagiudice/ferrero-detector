addpath(genpath('../functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
crop_padding = 0.10;

start_index = 1;
end_index = numel(images_list);

%% Read image
parfor i = start_index : end_index
    img_path = '../images/original/'+string(images_list{i});
    [~, scaled_image, target_image] = ...
    read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
    
    %% Box edge
    canny_edge = image_to_edge(target_image);
    bw = canny2binary(canny_edge);
    
    %% Evaluate vertices
    vertices45 = find_vertices_45(bw);
    vertices90 = find_vertices_90(bw);
    best_vertices = decide_best_vertices(vertices45, vertices90);
    
    %% Cop box
    [box_cropped, rotated, sheared, rot_matrix] = ...
    crop_box(scaled_image, best_vertices, crop_padding);
    
    %% Classify table
    table_binary = find_table_cropped(box_cropped);

    %{    
    figure(1);
    subplot(1,1,1);imshow(table_binary); 
    %}
    
    path = "../images/tables/mask_" + string(images_list{i});
    imwrite(table_binary, path);
    disp(i);

end

