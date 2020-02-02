function table_mask_cropped = find_table_cropped(box_cropped)
    %% Edge detection
    box_cropped_ycbcr = rgb2ycbcr(box_cropped);
    box_cropped_edge = edge(box_cropped_ycbcr(:,:,2), 'canny');
    
    %% Compute sum of window T
    padding = 150;
    half_padding = round(padding / 2);
    box_cropped_edge = ...
    padarray(box_cropped_edge, [padding padding], 0, 'both');
    [r, c] = size(box_cropped_edge);
    
    out = compute_local_descriptors(box_cropped_edge, 10, 3, @compute_sum);
    values = out.descriptors;
    
    %% Find windows which contains edges
    labels = values>0;
    img_labels = reshape(labels, out.nt_rows, out.nt_cols);
    img_labels_out = imresize(img_labels, [r, c], 'nearest'); 
    edge_mask = abs(1 - img_labels_out);
    edge_mask_open = imopen(edge_mask, strel('square', 15));

    %% Label all edge component
    edge_mask_labeled = bwlabel(edge_mask_open, 8);

    %% Find label connected with image border
    table_labels = [];
    for label_index = 1 : max(edge_mask_labeled(:))
        target_label = edge_mask_labeled == label_index;
        vertical_projection   = sum(target_label, 1);
        horizontal_projection = sum(target_label, 2);
        % Evaluate border of target label
        max_x = find(vertical_projection ~= 0, 1, 'last');
        min_x = find(vertical_projection ~= 0, 1);
        max_y = find(horizontal_projection ~= 0, 1, 'last');
        min_y = find(horizontal_projection ~= 0, 1);
        % Test if label is attach to image border
        if (max_x == c || min_x == 1 || max_y == r || min_y == 1)
            table_labels = [table_labels, label_index];
        end
    end

    %% Evaluate table mask
    table_mask = zeros(r, c);
    for label_index_table = 1 : numel(table_labels)
        label_mask = edge_mask_labeled == table_labels(label_index_table);
        table_mask = table_mask | label_mask;
    end

    %% Box shape enhancement
%{
 
    mask_padding = 150;
    half_padding = round(mask_padding/2);
    % Add padding
    table_mask_padding = ...
    padarray(table_mask, [mask_padding mask_padding], 1, 'both');
 
%}

    % Adjust shape
    se = strel('square', padding);
    table_mask_close = imclose(table_mask, se);
    table_mask_open = imopen(table_mask_close, se);
    table_mask_filtered = medfilt2(table_mask_open, [half_padding half_padding]);

    %% Apply mask to box cropped
    %total_padding = padding + mask_padding;

    [r, c, ~] = size(box_cropped);
    rectangle_crop = [padding, padding, c-1, r-1];
    table_mask_cropped = imcrop(table_mask_filtered, rectangle_crop);
    mask_apllied = box_cropped .* abs(1-table_mask_cropped);

    %{
    %% Show results
    figure(5);
    
    subplot(2,5,1); imshow(box_cropped);
    title("Box cropped");

    subplot(2,5,2); imshow(box_cropped_edge);
    title("Box cropped edge");
    
    subplot(2,5,3); imagesc(img_labels_out), axis image;
    title("Edge binary labels");
    
    subplot(2,5,4); imshow(edge_mask_open);
    title("Edge mask imopen()");
    
    subplot(2,5,5); imagesc(edge_mask_labeled), axis image;
    title("Edge mask labels");
    
    subplot(2,5,6); imshow(table_mask);
    title("Table mask");
 
    subplot(2,5,7); imshow(table_mask_close);
    title("Table mask imclose()");

    subplot(2,5,8); imshow(table_mask_open);
    title("Table mask imopen()");

    subplot(2,5,9); imshow(table_mask_filtered);
    title("Table mask medfilt2()");

    subplot(2,5,10); imshow(mask_apllied);
    title("Box cropped masked");
 
    %}

    table_mask_cropped = mask_apllied;

end
