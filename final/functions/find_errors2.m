function errorsPosition = find_errors2(cuts, classifier, debug)
    %% Valid masks
    valid1 = [2 2 2 2 2 2;
              1 1 1 1 1 1;
              1 1 1 1 1 1;
              3 3 3 3 3 3];

    valid2 = [3 3 3 3 3 3;
              1 1 1 1 1 1;
              1 1 1 1 1 1;
              2 2 2 2 2 2];
          
    %% Transpose cuts
    prediction = zeros(size(cuts));
    
    %% Predict
    for i = 1 : length(cuts(:,1))
        for j = 1 : length(cuts)
            cut = cuts{i, j}.value;
            cutConv = uint8(cut * 255);
            % Compute feature
            lbp = compute_lbp(cutConv);
            avg = compute_average_color(rgb2ycbcr(cut));
            min_region_avg = compute_min_region_avg(cut);
            % Zip data
            data = double([avg, lbp, min_region_avg]);
            %data = avg;
            % Predict
            prediction(i, j) = classifier.predict(data);
            
            %figure(80);imshow(cut);
            %disp(prediction(i,j));
        end
    end
    
    %% Errors
    
    diff1 = sum(prediction ~= valid1, 'all');
    diff2 = sum(prediction ~= valid2, 'all');

    outPrediction = prediction;
    if diff1 == 0 || diff2 == 0
        % Box is correct
        errors = boolean(zeros(4,6));
    else
        if diff1 < diff2
            errors = prediction ~= valid1;
        else
            errors = prediction ~= valid2;
        end
        outPrediction(errors) = 5;
    end
    
    %% Return list of errors position
    e = cuts(errors);
    errorsPosition = [];
    for i = 1 : numel(e)
        errorsPosition = [errorsPosition; e{i}.center];
    end
    
    if debug

        cmap = [232 185 35;
                229 228 225;
                52 34 17;
                179 33 52] / 255;
        l = [{'Rocher'}, {'Raffaello'}, {'Rondnoir'}, {'Wrong'}];
        
        figure(8);
        % Valid mask 1
        h1 = subplot(2,2,1);
        imagesc(valid1);title("Valid mask_1");
        set(gca, 'ytick', [1:4]);
        set(gca, 'xtick', [1:6]);
        N = 3;
        colormap(h1, cmap(1: 3, :));
        colorbar('Ticks',1:N, 'TickLabels', l(1:N));
        axis on, axis image;

        % Valid mask 2
        h2 = subplot(2,2,2);
        imagesc(valid2);title("Valid mask_2");
        set(gca, 'ytick', [1:4]);
        set(gca, 'xtick', [1:6]);
        N = 3;
        colormap(h2, cmap(1: 3, :));
        colorbar('Ticks',1:N, 'TickLabels', l(1:N));
        axis on, axis image;

        % Prediction
        h3 = subplot(2,2,3);
        imagesc(prediction);title("Predictions");
        set(gca, 'ytick', [1:4]);
        set(gca, 'xtick', [1:6]);
        N = length(unique(prediction));
        colormap(h3, cmap(1: N, :));
        colorbar('Ticks',1:N, 'TickLabels', l(1:N));
        axis on, axis image;

        % OutPrediction
        h4 = subplot(2,2,4);
        imagesc(outPrediction);title("Out predictions");
        set(gca, 'ytick', [1:4]);
        set(gca, 'xtick', [1:6]);
        N = length(unique(outPrediction));
        colormap(h4, cmap(1: N, :));
        colorbar('Ticks',1:N, 'TickLabels', l(1:N));
        
        axis on, axis image;

    end
end