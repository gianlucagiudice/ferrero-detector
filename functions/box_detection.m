function boxOpened = box_detection(cannyEdge, paddingSize, debug)
    %% Label edges
    [r, c] = size(cannyEdge);

    % 30px is the border size
    out = compute_local_descriptors(cannyEdge, 10, 3, @compute_average_color);

    % Label the image using k-means clustering
    labels = kmeans(out.descriptors, 2);
    img_labels = reshape(labels, out.nt_rows, out.nt_cols);
    img_labels_out = imresize(img_labels, [r, c], 'nearest'); 

    %% Find label relative to background
    bkg_label = -1;
    min_value = Inf;
    for label = 1:length(unique(labels))
        cmp = mean(cannyEdge(img_labels_out == label));
        if (cmp < min_value)
            min_value = cmp;
            bkg_label = label;
        end
    end

    elements = img_labels_out ~= bkg_label;

    %% Delete all non-box elements
    % Assume the box is the biggest element
    objects = bwlabel(elements);
    box_label = mode(objects(objects > 0), 'all');
    boxBinary = (objects == box_label);

    %% Fill holes
    boxFilled = imfill(boxBinary, 'holes');
    se = strel("square", 30);
    boxFilled = imclose(boxFilled, se);
    boxFilled = imfill(boxFilled, 'holes');

    %% Median filter
    boxFiltered = medfilt2(boxFilled, [30 30]);
    
    %% Fill holes
    boxFilteredFilled = imfill(boxFiltered, 'holes');

    
    %% Add padding to box
    boxPadding = padarray(boxFilteredFilled, [paddingSize paddingSize], 0, 'both');

    %% Delete elemnts connected to box
    se = strel('disk', 50);
    boxOpened = imopen(boxPadding, se);
    
    if debug
        %% Caso particolare: 6
        figure(3);
        subplot(2,5,1);imshow(cannyEdge);title('Edges');
        subplot(2,5,2);imagesc(img_labels_out), axis image; title('Sum > 0');
        subplot(2,5,3);imshow(elements);title('All elements');
        subplot(2,5,4);imagesc(objects), axis image;title('Elements labels');
        subplot(2,5,5);imshow(boxBinary);title('Box');
        subplot(2,5,6);imshow(boxFilled);title('Fill holes');
        subplot(2,5,7);imshow(boxFiltered);title('medfilt2()');
        subplot(2,5,8);imshow(boxFilteredFilled);title('Fill holes filtered');
        subplot(2,5,9);imshow(boxPadding);title('Box padding');
        subplot(2,5,10);imshow(boxOpened);title('Box imopen()');
    end

    %{   
    K>> subplot(2,2,2);imshow(boxFilteredFilled)
    K>> subplot(2,2,2);imshow(boxFilteredFilled);title("Fill holes filtered");
    K>> subplot(2,2,3);imshow(boxPadding);title("Box padding");
    K>> subplot(2,2,4);imshow(boxOpened);title("Mathematical morphology - Opening (Disk)");
    K>> subplot(2,2,4);imshow(boxOpened);title("Opening (Disk)");
    %}


end