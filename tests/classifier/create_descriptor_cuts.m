addpath(genpath('../../functions/'));

%% Get list of images
%scale_factor = 0.5;

path = "../../images/labeled/";

%% Classes
classes.name  = ["raffaello_cut", "rocher_cut", "rondnoir_cut"];
classes.label = [1, 2, 3];
%% Target color space
change_color_space = @rgb2hsv;

images = {};

data.labels = [];

%% Read all images
N = 0;
for i = 1 : length(classes.name)
    % Path
    target_path = path + classes.name(i) + "/";
    % Class folder
    dir_output = dir(target_path); % Contains "." and ".."
    % Files in target class
    files = {dir_output.name};
    % Iterate each image in class
    for j = 3 : length(files)
        % Read the image
        images{j - 2, i} = imread(target_path + "/" + files{j});
        N = N + 1;
        data.labels(N) = classes.label(i);
    end
end

disp('Read completed');


%% Compute all features for each images
j = 1;
for i = 1 : numel(images)
    if isempty(images{i}) == false
        %% Compute features
        im = images{i};
        % Local binary pattern histograms
        descriptor.lbp{j}   = compute_lbp(im);
        descriptor.cedd{j}  = compute_CEDD(im);
        % Gray-Level Co-Occurence 
        descriptor.qhist{j} = compute_qhist(im);
        % Gray-level histograms
        descriptor.ghist{j} = compute_ghist(im);
        % Gray-Level Co-Occurence Matrices
        descriptor.glcm{j}  =  compute_glcm(rgb2gray(im));

        im = change_color_space(im2double(im));
        % Color average
        descriptor.avg{j}   = compute_average_color(im);
        % Standard deviation
        descriptor.std{j}   = compute_std(im);
    

        disp(string(j) + " - " + string(N));
        
        j = j + 1;
    end
end

%% Reshape descriptors
fn = fieldnames(descriptor);
for k = 1:numel(fn)
    % Target field
    field = fn{k};
    % Matrix size
    nCols = length(descriptor.(field){1});
    nRows = length(descriptor.(field));
    % reshape
    matrix = reshape(cell2mat(descriptor.(field)), nCols, nRows);
    % Override 
    descriptor.(field) = double(matrix)'; 
end

%% Descriptor in data
data.descriptor = descriptor;

%% Save descriptor
save('data', 'data');
clear all

load('data');