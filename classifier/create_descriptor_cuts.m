clear all

addpath(genpath('../functions/'));
path = "../images/cuts/";
save = false;

%% Classes
T = readtable('../data/cuts.csv', 'HeaderLines', 0);
images = T{:, 1};
labels = T{:, 2};

%% Target color space
change_color_space = @rgb2ycbcr;

%% Compute all features for each images
tic

N = numel(images);
parfor targetIndex = 1 : N

    %% Read image
    targetPath = path + images{targetIndex};
    im = imread(targetPath);

    %% Cop cut

    %% Compute feature
    % Local binary pattern histograms
    lbp{targetIndex}   = compute_lbp(im);
    % Color and Edge Directivity Descriptor
    cedd{targetIndex}  = compute_CEDD(im);
    % Gray-Level Co-Occurence 
    qhist{targetIndex} = compute_qhist(im);
    % Gray-level histograms
    ghist{targetIndex} = compute_ghist(im);
    % Gray-Level Co-Occurence Matrices
    glcm{targetIndex}  =  compute_glcm(rgb2gray(im));
    
    % Custom Features
    im_1 = change_color_space(im2double(im));
    % Color average
    avg{targetIndex} = compute_average_color(im_1);
    % Standard deviation
    std{targetIndex} = compute_std(im_1);
    % Saturation channel
    im_2 = uint8(rgb2hsv(im));
    qhist_hsv_s{targetIndex} = compute_qhist(im_2(:,:,2));
    % Min ragion segmentation
    min_avg_region{targetIndex} = compute_min_region_avg(im2double(im));

    %% Save labels
    zipLabels(targetIndex) = labels(targetIndex);
    disp(string(targetIndex) + " - " + string(N));
    
end

%% Zip descriptors
descriptors.lbp = lbp;
descriptors.cedd = cedd;
descriptors.qhist = qhist;
descriptors.ghist = ghist;
descriptors.glcm = glcm;
descriptors.avg = avg;
descriptors.std = std;
descriptors.qhist_hsv_s = qhist_hsv_s;
descriptors.min_avg_region = min_avg_region;

disp("All descriptors created.");

%% Reshape values
disp("Reshape features . . .");
fn = fieldnames(descriptors);
for k = 1:numel(fn)
    % Target feature
    feature = descriptors.(fn{k});
    % Reshape
    matrix = [];
    for i= 1 : length(feature)
        matrix(i,:) = feature{i};
    end
    descriptors.(fn{k}) = matrix;
end
toc

%% Zip cuts
cuts.descriptors = descriptors;
cuts.labels = zipLabels';

%% Save descriptor
if save
    save('../data/cuts.mat', 'cuts');
end