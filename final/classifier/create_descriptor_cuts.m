addpath(genpath('../../functions/'));
path = "../../images/cuts/";

%% Classes
T = readtable('../../data/cuts.csv', 'HeaderLines', 0);
images = T{:, 1};
labels = T{:, 2};

%% Target color space
change_color_space = @rgb2ycbcr;

%% Compute all features for each images
tic


N = numel(images);
parfor targetIndex = 1 : N

    %% skip non choccolates
    if labels(targetIndex) > 3
        continue
    end

    %% Read image
    targetPath = path + images{targetIndex};
    im = imread(targetPath);

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

    im = change_color_space(im2double(im));
    % Color average
    avg{targetIndex} = compute_average_color(im);
    % Standard deviation
    std{targetIndex} = compute_std(im);

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

disp("All descriptors created.");


disp("Reshape feature . . .");
%% Reshape descriptors
fn = fieldnames(descriptors);
for k = 1:numel(fn)
    % Target field
    field = fn{k};
    % Matrix size
    nCols = length(descriptors.(field){1});
    nRows = length(descriptors.(field));
    % reshape
    matrix = reshape(cell2mat(descriptors.(field)), nCols, nRows);
    % Override 
    descriptors.(field) = double(matrix)'; 
end

toc

%% Zip cuts
cuts.descriptors = descriptors;
cuts.labels = zipLabels';

%% Save descriptor
save('../../data/cuts.mat', 'cuts');