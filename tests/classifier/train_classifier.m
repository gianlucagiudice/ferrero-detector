addpath(genpath('../../functions/'));

%% Get list of images
%scale_factor = 0.5;

path = "../../images/labeled/";
%dir_names = ["none", "raffaello", "rocher", "rondnoir"];
dir_names = ["0_raffaello", "0_rocher", "0_rondnoir"];

n_classes = length(dir_names);
statistics = cell(1, n_classes);
change_color_space = @rgb2hsv;
channels = ["h", "s", "v"];

%% Read all the images
for i = 1 : n_classes
    stats = [];
    target_path = path + dir_names(i) + "/";
    dir_output = dir(target_path); % Contains "." and ".."
    files = {dir_output.name};
    for j = 3 : length(files)
        % Read the image
        target_image = im2double(imread(target_path + "/" + files{j}));
        [r, c, ch] = size(target_image);
        %% Far vedere che equalizzato fa schifo!
        %target_image = histeq(target_image);
        
        target_image = change_color_space(target_image);
        
        reshaped = reshape(target_image, r*c, 1, ch);
        stats = cat(1, stats, reshaped);
    end
    statistics{i}.value = stats;
    statistics{i}.label = dir_names{i};
end

%% Plot the statistics
figure(1);
for i = 1 : n_classes
    stats = statistics{i}.value;
    [r, c, ch] = size(stats);
    for j = 1 : ch
        index_plot =  1 + (j - 1)*n_classes + (i-1);
        subplot(ch, n_classes, index_plot);
        channel_value = stats(:,:,j);
        imhist(channel_value);
        title(statistics{i}.label + "_" + channels(j));
    end
end

%% Create classifier
train_values = [];
train_labels = [];
for i = 1 : n_classes
    stats = statistics{i}.value;
    [r, c, ch] = size(stats);
    stats = reshape(stats, r*c, ch);
    train_values = [train_values; stats];
    % Label must be an integere value
    target_label = string(statistics{i}.label);
    target_label = i;
    labels = repmat(target_label, r*c, 1);
    train_labels = [train_labels; labels];
end

%classifier_bayes = fitcknn(train_values, train_labels);
%classifier_bayes = fitctree(train_values, train_labels);
classifier_bayes = fitcnb(train_values, train_labels);


%image = im2double(imread("../../images/original/IMG_8629.JPG"));
%image = histeq(im2double(imread("../../images/original/IMG_8650.JPG")));
image = im2double(imread("../../images/original/IMG_8634.JPG"));

show_color_spaces(image, 3);

image = change_color_space(image);

figure(2);
subplot(2,2,1);
imshow(image);

% Evaluate the target image
[r, c, ch] = size(image);
pixs = reshape(image, r*c, 3);

predicted = predict(classifier_bayes, pixs);
predicted = reshape(predicted, r, c, 1);

subplot(2,2,2);
imagesc(predicted), axis image;

%filtered = medfilt2(predicted, [20 20]);
filtered = medfilt2(predicted, [30 30]);

subplot(2,2,3);
imagesc(filtered), axis image;

%% Export classifier
save(fullfile('..', '..', 'classifier_bayes.mat'), 'classifier_bayes');