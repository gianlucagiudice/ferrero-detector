function box_binary = canny2binary(canny_edge)
    %% Label edges
    [r, c] = size(canny_edge);

    % 11px is the border size
    out = compute_local_descriptors(canny_edge, 11, 5, @compute_average_color);
    % Label the image using k-means clustering
    labels = kmeans(out.descriptors, 2);
    img_labels = reshape(labels, out.nt_rows, out.nt_cols);
    img_labels_out = imresize(img_labels, [r, c], 'nearest'); 

    %% Find label relative to background
    label_list = zeros(1, length(unique(labels)));
    for label = 1:length(unique(labels))
        label_list(label) = sum(img_labels_out == label .* canny_edge, 'all');
    end
    [~, bkg_label] = min(label_list);
    elements = img_labels_out ~= bkg_label;

    %% Delete all non-box elements
    % Assume the box is the biggest element
    objects = bwlabel(elements);
    box_label = mode(objects(objects > 0), 'all');
    box_binary = (objects == box_label);

    %% Box enhancement
    box_binary = medfilt2(box_binary, [15 15]);
end