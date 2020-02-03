addpath(genpath('../functions/'));
load(fullfile('..', 'classifier_bayes.mat'));
change_color_space = @rgb2hsv;

%% Get list of images
images_list = readlist('../data/images.list');
scale_factor = 0.5;
crop_padding = 0.10;

%% Test particolari: 16, 11, 6, 8
target_index = 6;

start_index = 1;
end_index = numel(images_list);

for i = start_index : end_index
    %% Read image
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

    %% Classification
    classify_target = change_color_space(box_cropped); 
    [r, c, ch] = size(classify_target);

    %% Classify choccolates
    pixs = reshape(classify_target, r*c, 3);
    predicted = predict(classifier_bayes, pixs);
    predicted = reshape(predicted, r, c, 1);

    %% Classification enhancement
    predicted_filtered = medfilt2(predicted, [10 10]);
    table_mask = find_table_mask_cropped(box_cropped);
    prediction = predicted_filtered .* abs(1 - table_mask);

    %% Consider the size of a choccolate, btained from dataset
    choccolate_size_percentage = 0.166;
    %% Lables = [0 = table; 1 = raffaello; 2 = rocher; 3 = rondnoir]
    %% NOTA BENE: Uso elemento strutturante quadrato perchè la sliding windows sarà quadrata



    %% Enhance raffaello
    raffaello = prediction == 1;
    %% Erase non-raffaello
    raffaello_labels = bwlabel(raffaello);
    % Threshold is 1/2 of choccolate
    choccolate_fraction = 1/2;
    tsize = round(r * choccolate_size_percentage * choccolate_fraction);

    valid_raffaello = [];
    for label_index = 1 : numel(unique(raffaello_labels))
        target_label = raffaello_labels == label_index; 
        if sum(target_label, 'all') > tsize ^ 2
            valid_raffaello = [valid_raffaello, label_index];
        end
    end
    %% Evaluate valid raffaello
    raffaello_mask_deleted = zeros(r, c);
    for label_index = 1 : numel(valid_raffaello)
        valid_label_mask = raffaello_labels == valid_raffaello(label_index);
        %valid_raffaello_label = raffaello_labels == label_index;
        %raffaello_label_mask = raffaello_labels == raffaello_labels(label_index);
        raffaello_mask_deleted = raffaello_mask_deleted | valid_label_mask;
    end
    %% Mask enhancement
    choccolate_fraction = 1/2;
    tsize = round(r * choccolate_size_percentage * choccolate_fraction);
    raffaello_mask_filtered = medfilt2(raffaello, [tsize tsize]);
    % Open small holes
    choccolate_fraction = 1/6;
    tsize = round(r * choccolate_size_percentage * choccolate_fraction);
    se = strel('disk', tsize);
    raffaello_mask_filtered_opened = imopen(raffaello_mask_filtered, se);
    % Close holes
    choccolate_fraction = 1.5;
    tsize = round(r * choccolate_size_percentage * choccolate_fraction);
    se = strel('square', tsize);
    raffaello_mask_filtered_closed = imclose(raffaello_mask_filtered_opened, se);
    % Dilate
    choccolate_fraction = 1/3;
    tsize = round(r * choccolate_size_percentage * choccolate_fraction);
    se = strel('square', tsize);
    raffaello_mask_filtered_dilated = imdilate(raffaello_mask_filtered_closed, se);


    %% Enhance rondnoir
    rondnoir = prediction == 3;
    %% Rondnoir median filter
    choccolate_fraction = 1;
    tsize = round(r * choccolate_size_percentage * choccolate_fraction);
    rondnoir_mask_filtered = medfilt2(rondnoir, [tsize tsize]);
    % Open small holes
    choccolate_fraction = 1/4;
    tsize = round(r * choccolate_size_percentage * choccolate_fraction);
    se = strel('disk', tsize);
    rondnoir_mask_filtered_opened = imopen(rondnoir_mask_filtered, se);
    % Close small holes
    choccolate_fraction = 1/3;
    tsize = round(r * choccolate_size_percentage * choccolate_fraction);
    se = strel('disk', tsize);
    rondnoir_mask_filtered_closed = imclose(rondnoir_mask_filtered_opened, se);
    % Dilate
    choccolate_fraction = 1/3;
    tsize = round(r * choccolate_size_percentage * choccolate_fraction);
    se = strel('square', tsize);
    rondnoir_mask_filtered_dilated = imdilate(rondnoir_mask_filtered_closed, se);


    %% Evaluate box enhanced
    box_enhanced = zeros(r, c) + 2;
    box_enhanced(raffaello_mask_filtered_dilated) = 1;
    box_enhanced(rondnoir_mask_filtered_dilated) = 3;
    box_enhanced(table_mask) = 0;

    %% -------- Show results -------- 
    f = figure('visible', 'off');
    %% Classification
    subplot(5,4,1);
    imshow(box_cropped);
    title("Box cropped"); 
    subplot(5,4,2);
    imagesc(predicted), axis image;
    title("Labels HSV_S");
    subplot(5,4,3);
    imagesc(predicted_filtered), axis image;
    title("Labels filtered");
    subplot(5,4,4);
    imagesc(prediction), axis image;
    title("Labels with table");
    %% Raffaello
    subplot(5,4,5);
    imshow(raffaello), axis image; title("Raffaello mask");
    subplot(5,4,6);
    imagesc(raffaello_labels), axis image;
    title("Raffaello labels()");
    %% Raffaello labels
    subplot(5,4,7);
    histogram(raffaello_labels(raffaello_labels~=0));
    title("Raffaello lables dimension");
    subplot(5,4,8);
    imshow(raffaello_mask_deleted), axis image;
    title("Deleted non raffaello");
    %% Raffaello median filter
    subplot(5,4,9);
    imshow(raffaello_mask_filtered);
    title("Raffaello mask medfilt2()");    
    subplot(5,4,10);
    imshow(raffaello_mask_filtered_opened), axis image;
    title("Raffaello mask filtered imopen()");
    subplot(5,4,11);
    imshow(raffaello_mask_filtered_closed), axis image;
    title("Raffaello mask filtered imclose()");
    subplot(5,4,12);
    imshow(raffaello_mask_filtered_dilated), axis image;
    title("Raffaello mask filtered imdilate()");
    %% Rondnoir
    subplot(5,4,13);
    imshow(rondnoir), axis image; title("Rondnoir mask");
    subplot(5,4,14);
    imshow(rondnoir_mask_filtered); title("Rondnoir mask medfilt2()");
    subplot(5,4,15);
    imshow(rondnoir_mask_filtered_opened);
    title("Rondnoir mask filtered imopen()");
    subplot(5,4,16);
    imshow(rondnoir_mask_filtered_closed);
    title("Rondnoir mask filtered imclose()");
    subplot(5,4,17);
    imshow(rondnoir_mask_filtered_dilated);
    title("Rondnoir mask filtered dilated()");

    subplot(5,4,18);
    imagesc(box_enhanced), axis image; title("Box enhanced");
    subplot(5,4,19);
    imagesc(box_enhanced), axis image; title("Box enhanced");

    subplot(5,4,20);
    imagesc(box_enhanced), axis image; title("Box enhanced");

    %% Save
    name = split(string(images_list{i}), '.');
    path = "../images/classify_box/classified_" + name(1);
    saveas(f, path, 'png');
    disp(i);

end