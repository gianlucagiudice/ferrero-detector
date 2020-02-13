function errors = find_errors1(cuts, classifier, debug)
    % Assume image is valid
    errors = [];


%{
     %% Convert to HSV, S channel
    target = rgb2hsv(histeq(cropeEnhanced));
    target = target(:,:,2);

    % Tag size base on percentage
    tagSize = round(0.0158/2 * length(cropeEnhanced));

    % Image enhancemet
    targetFilt = medfilt2(target, [tagSize tagSize], 'symmetric');

    %% Binarization using very low threshold
    tags = targetFilt < 1 / 5;

    %% Morfologia matetmatica
    se = strel('disk', round(tagSize * 1.5));
    tagsClosed = imclose(tags, se);
    se = strel('disk', round(tagSize / 2));
    tagsOpened = imopen(tagsClosed, se);
    
    %% Connected labels
    labels = bwlabel(tagsOpened);
 
%}

%{
 
        

    if debug
        figure(8);
        subplot(2,2,1);
        imshow(target);title("HSV_S");
        subplot(2,2,2);
        imshow(targetFilt);title("Median filter");
        subplot(2,2,3);
        imshow(tagsOpened);title("Binarization low t");
        subplot(2,2,4);
        imagesc(labels), axis image;title("Labels");
    end 
%}

    predictions = zeros(size(cuts));

    %% Predict
    for i = 1 : length(cuts)
        cut = cuts{i}.value;
        cutConv = uint8(cut * 255);
        % Compute feature
        lbp = compute_lbp(cutConv);
        avg = compute_average_color(rgb2ycbcr(cut));
        min_region_avg = compute_min_region_avg(cut);
        % Zip data
        data = double([avg, lbp, min_region_avg]);
        % Predict
        prediction(i) = classifier.predict(data);
    end

    cutErrors = cuts(prediction ~= 1);
    for errorIndex = 1 : numel(cutErrors)
        errors = [errors; cutErrors{errorIndex}.center];
    end
    
    if debug
        for errorIndex = 1 : numel(cutErrors)
            disp(cutErrors{errorIndex}.center);
        end
    end
    

end