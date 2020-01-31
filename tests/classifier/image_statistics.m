addpath(genpath('../../functions/'));

%% Get list of images
%scale_factor = 0.5;

path = "../../images/labeled/";
%dir_names = ["none", "raffaello", "rocher", "rondnoir"];
dir_names = ["box", "corner", "table"];

n_classes = length(dir_names);
statistics = cell(1, n_classes);
change_color_space = @rgb2hsv;

lbp   = [];
cedd  = [];
qhist = [];
labels= [];

observation_index = 0;

%% Read all the images
for i = 1 : n_classes
    stats = [];
    target_path = path + dir_names(i) + "/";
    dir_output = dir(target_path); % Contains "." and ".."
    files = {dir_output.name};
    for j = 3 : length(files)
        observation_index = observation_index + 1;
        % Read the image
        target_image = imread(target_path + "/" + files{j});
        [r, c, ch] = size(target_image);
        
        out = compute_local_descriptors(image, 100, 700, @compute_CEDD);
        cedd  = [cedd;out.descriptors];

        lbp   = [lbp;compute_lbp(target_image)];
        qhist = [qhist;compute_qhist(target_image)];
        
        reshaped = reshape(target_image, r*c, 1, ch);
        stats = cat(1, stats, reshaped);

        append_label = repmat(i, size(out.descriptors, 1), 1);
        labels = cat(1, labels, append_label);
    
    end
    
end

save('lbp','lbp');
save('cedd','cedd');
save('qhist','qhist');
save('labels', 'labels');
