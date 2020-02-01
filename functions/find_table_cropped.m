function table_binary = find_table_cropped(box_cropped)

    box_cropped_ycbcr = rgb2ycbcr(box_cropped);
    box_cropped_edge = edge(box_cropped_ycbcr(:,:,2), 'canny');

    %% Label edges
    [r, c] = size(box_cropped_edge);
    % 11px is the border size
    out = compute_local_descriptors(box_cropped_edge, 7, 3, @compute_sum);

    values = out.descriptors;
    labels = values>0;
    img_labels = reshape(labels, out.nt_rows, out.nt_cols);
    img_labels_out = imresize(img_labels, [r, c], 'nearest'); 

    table_mask = abs(1 - img_labels_out);

    %% Close holes
    se = strel('square', 10);
    table_mask_open = imopen(table_mask, se);

%{
     sum_edge = [];
    for i = 1: n_cluster
       sum_edge(i) = sum(box_cropped_edge(img_labels_out == i), 'all');
    end
    [~, table_label] = min(sum_edge);

    table_mask = img_labels_out(table_label); 
%}

    
    % The label relative to table has less edges
    

    %{
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

    ciao come stai oggi io tutto bene grazie



    %% Box enhancement
    table_binary = medfilt2(box_binary, [15 15]);
    %}

    table_binary = table_mask_open;



%{
     figure(5);
    subplot(3,2,1);imshow(box_cropped);
    subplot(3,2,2);imshow(box_cropped_edge);
    subplot(3,2,3);imagesc(img_labels_out), axis image;
    subplot(3,2,4);imshow(table_mask);
    subplot(3,2,5);imshow(table_mask_open);
 
%}

end
