addpath(genpath('../functions/'));

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
padding_crop = 0.08;

%% Processing
start_limit = 1;
end_limit = 64;

tic
for i = start_limit:end_limit
    %% Processing
    img_path = '../images/original/' + string(images_list{i});
    [~, scaled_image, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);

    canny_edge = image_to_edge(target_image);

    bw = canny2binary(canny_edge);
    
    vertices45 = find_vertices_45(bw);
    vertices90 = find_vertices_90(bw);
    best_vertices = decide_best_vertices(vertices45, vertices90);
        
    [box_cropped, rotated, sheared, rot_matrix] = ...
    crop_box(scaled_image, best_vertices, crop_padding);
    
    %% Show results
    figure(i);
    imshow(imresize(box_cropped, 0.5));
    
end
toc
