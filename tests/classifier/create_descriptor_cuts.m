addpath(genpath('../../functions/'));

%% Get list of images
%scale_factor = 0.5;

path = "../../images/labeled/";

%% Classes
classes.name  = ["raffaello_cut", "rocher_cut", "rondnoir_cut"];
classes.label = [1, 2, 3];
%% Target color space
change_color_space = @rgb2hsv;

%% Equalization

%% Features
lbp     = []; % Local binary pattern histograms
cedd    = []; % Gray-Level Co-Occurence 
qhist   = [];
ghist   = []; % Gray-level histograms
glcm    = []; % Gray-Level Co-Occurence Matrices
avg     = []; % Color average
std     = []; % Standard deviation

images = {};
lables = [];

%% Read all images
n = 0;
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
        n = n + 1;
        lables(n) = classes.label(i);
    end
end

disp('Read completed');


%% Compute all features foreach images
N = numel(images);
j = 1;
for i = 1 : N
    if isempty(images{i}) == false
        im = images{i};
        % Compute features
        lbp{i}   = compute_lbp(im);
        cedd{i}  = compute_CEDD(im);
        qhist{i} = compute_qhist(im);
        ghist{i} = compute_ghist(im);
        glcm{i}  =  compute_glcm(rgb2gray(im));
    
        im = change_color_space(im2double(im));
        avg{i}   = compute_average_color(im);
        std{i}   = compute_std(im);
    
        disp(string(j) + " - " + string(n));
        j = j + 1;
    end

end


save('lbp', 'lbp');
save('cedd', 'cedd');
save('qhist', 'qhist');
save('ghist', 'ghist');
save('glcm', 'glcm');
save('avg', 'avg');
save('std', 'std');
save('labels', 'labels');
