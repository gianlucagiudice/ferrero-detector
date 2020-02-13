relPath = "../";
addpath(genpath(relPath + 'functions/'));

%% Parameters
scaleFactor = 0.5;
paddingSize = 300;
processImages = true;

%% Process all images
if processImages
    %% Read the labeled shapes
    T = readtable(relPath + 'data/shapes.csv', 'HeaderLines', 0);
    images = T{:, 1};
    labels = T{:, 2};
    lenEdges = zeros(length(images), 4);
    imgs = cell(1, length(images));

    tic
    disp("Start reading images . . .");
    parfor targetIndex = 1:length(images)
        % Read image
        imgPath = relPath + 'images/original/'+string(images{targetIndex});
        [~, ~, targetImage] = ...
            read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);
        imgs{targetIndex} = targetImage;

        disp("Read " + targetIndex + " - " + length(images));

    end
    disp("Read completed.");
    
    disp(" - - - - - - -");
    
    %% Start processing
    disp('Start processing . . .');
    parfor targetIndex = 1:length(images)
        % Get a target image
        targetImage = imgs{targetIndex};
        % Find edges
        cannyEdge = image_to_edge(targetImage);
        % Box mask
        boxMask = box_detection(cannyEdge, paddingSize);
        % Find vertices
        vertices = box_vertices(boxMask, paddingSize);
        % Evaluate edges length
        lenEdges(targetIndex, :) = edges_length(vertices) / scaleFactor;
    
        disp("Processed " + targetIndex + " - " + length(images));
    end
    disp("Processing completed.");
    toc
    
    %% Save descriptor
    edges.descriptors = lenEdges;
    edges.labels = labels;
    save(relPath + 'data/edges.mat', 'edges');
end


%% Load data
load(relPath + 'data/edges.mat', 'edges');

ratios = edges.ratio;

%% Plot results
figure(1);
subplot(1, 1, 1);
histogram(ratios, 20);
title("Edges ratio");
xlabel("Ratio");
ylabel("Occurence")

%% Evaluate statistics
sum_ratios_rectangles = 0;
num_recatngles = 0;

%% Average
sum_ratios_squares = 0;
num_squares = 0;

for i = 1:length(images_list)

    if labels{i} == "square"
        sum_ratios_squares = sum_ratios_squares + ratios(i);
        num_squares = num_squares + 1;
    else
        sum_ratios_rectangles = sum_ratios_rectangles + ratios(i);
        num_recatngles = num_recatngles + 1;
    end

end

mu_ratio_squares = sum_ratios_squares / num_squares;
mu_ratio_rectangles = sum_ratios_rectangles / num_recatngles;

%% Standard deviation
varince_ratio_squares = 0;
varince_ratio_rectangles = 0;

for i = 1:length(images_list)

    if labels{i} == "square"
        varince_ratio_squares = ...
            varince_ratio_squares + (ratios(i) - mu_ratio_squares)^2;
    else
        varince_ratio_rectangles = ...
            varince_ratio_rectangles + (ratios(i) - mu_ratio_rectangles)^2;
    end

end

std_ratio_squares = sqrt(varince_ratio_squares / num_squares);
std_ratio_rectangles = sqrt(varince_ratio_rectangles / num_recatngles);

fisher_criterion = ...
    ((mu_ratio_rectangles - mu_ratio_squares)^2) / ...
    (std_ratio_rectangles^2 + std_ratio_squares);

%% Show results
disp("Mean ratio squares    = "+mu_ratio_squares);
disp("Std ratio squares     = "+std_ratio_squares);
disp("--------");
disp("Mean ratio rectangles = "+mu_ratio_rectangles);
disp("Std ratio rectangles  = "+std_ratio_rectangles);