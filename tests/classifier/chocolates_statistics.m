addpath(genpath('functions/'));

%% Get list of images
%scale_factor = 0.5;

path = "../../images/labeled/";
dir_names = ["none", "raffaello", "rocher", "rondnoir"];
n_classes = length(dir_names);
statistics = cell(1, n_classes);

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
        %% Far vedere bene che equalizzato fa schifo!
        %target_image = histeq(target_image);
        reshaped = reshape(target_image, r*c, 1, ch);
        stats = cat(1, stats, reshaped);
    end
    statistics{i}.value = stats;
    statistics{i}.label = dir_names{i};
end

%% Plot the statistics
figure(1);
channels = ["r", "g", "b"];
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
    train_values = [train_values; stats];
    % Label must be an integere value
    target_label = string(statistics{i}.label);
    target_label = i;
    labels = repmat(target_label, r*c, 1);
    train_labels = [train_labels; labels];
end

%% Non funziona, devo andare in palestra, poi vedo perchè
classifier_bayes = fitcnb(train_values, train_labels);


image = im2double(imread("../../images/original/IMG_8609.JPG"));
figure(2);
imshow(image);

% Evaluate the target image
[r, c, ch] = size(image);
pixs = reshape(image, r*c, 3);

predicted = predict(classifier_bayes, pixs);
predicted = reshape(predicted, r, c, 1);
show_result(image, predicted); 

