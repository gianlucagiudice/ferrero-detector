function boxBinary = box_detection(cannyEdge, paddingSize)
    %% Label edges
    [r, c] = size(cannyEdge);

    % 30px is the border size
    out = compute_local_descriptors(cannyEdge, 30, 10, @compute_average_color);

    % Label the image using k-means clustering
    labels = kmeans(out.descriptors, 3);
    img_labels = reshape(labels, out.nt_rows, out.nt_cols);
    img_labels_out = imresize(img_labels, [r, c], 'nearest'); 

    %% Find label relative to background
    label_list = zeros(1, length(unique(labels)));
    for label = 1:length(unique(labels))
        label_list(label) = sum(img_labels_out == label .* cannyEdge, 'all');
    end
    [~, bkg_label] = min(label_list);
    elements = img_labels_out ~= bkg_label;

    %% Delete all non-box elements
    % Assume the box is the biggest element
    objects = bwlabel(elements);
    box_label = mode(objects(objects > 0), 'all');
    boxBinary = (objects == box_label);

    %% Fill holes
    boxBinary = imfill(boxBinary, 'holes');

    %% Add padding to box
    boxBinary = padarray(boxBinary, [paddingSize paddingSize], 0, 'both');

    %% Delete elemnts connected to box
    se = strel('disk', 60);
    boxBinary = imopen(boxBinary, se);
end