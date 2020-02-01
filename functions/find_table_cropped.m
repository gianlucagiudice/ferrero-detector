function table_mask_close = find_table_cropped(box_cropped)
    %% Edge detection
    box_cropped_ycbcr = rgb2ycbcr(box_cropped);
    box_cropped_edge = edge(box_cropped_ycbcr(:,:,2), 'canny');
    
    %% Box size
    [r, c] = size(box_cropped_edge);
    
    %% Compute sum of window T
    box_cropped_edge = padarray(box_cropped_edge, [50 50], 0, 'both');
    out = compute_local_descriptors(box_cropped_edge, 10, 3, @compute_sum);
    values = out.descriptors;
    
    %% Find windows which contains edges
    labels = values>0;
    img_labels = reshape(labels, out.nt_rows, out.nt_cols);
    img_labels_out = imresize(img_labels, [r, c], 'nearest'); 
    edge_mask = abs(1 - img_labels_out);
    
    %% Close holes in edge mask
    se = strel('line', 20, 0);
    edge_mask_open = imopen(edge_mask, se);
    se = strel('line', 20, 90);
    edge_mask_open = imopen(edge_mask_open, se);
    
    edge_mask_open = imopen(edge_mask, strel('square', 60));

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


    %% Close holes table mask
    se = strel('square', 50);
    table_mask_close = imclose(table_mask, se);
    

    padding = 150;
    D = padarray(table_mask,[padding padding],1,'both');
    
    D = medfilt2(D, [80 80]);

    se = strel('square', 150);
    D = imclose(D, se);

    se = strel('square', 40);
    D = imerode(D, se);
    
    half_padding = round(padding /2);
    X = imcrop(D, [padding, padding, c-1, r-1]);

    A = repmat(abs(1-X), 1, 1, 3) .* box_cropped;

    table_mask_close = A;

%{
 
    %% Show results
    figure(5);
    
    subplot(2,4,1); imshow(box_cropped);
    title("Box cropped");

    subplot(2,4,2); imshow(box_cropped_edge);
    title("Box cropped edge");
    
    subplot(2,4,3); imagesc(img_labels_out), axis image;
    title("Edge binary labels");
    
    subplot(2,4,4); imshow(edge_mask_open);
    title("Edge mask imopen()");
    
    subplot(2,4,5); imagesc(edge_mask_labeled), axis image;
    title("Edge mask labels");
    
    subplot(2,4,6); imshow(table_mask);
    title("Table mask");
 
    subplot(2,4,7); imshow(A);
    title("Table mask imdilate()");


    subplot(2,4,8); imshow(table_mask_close);
    title("Table mask imclose()");
 
%}


end
