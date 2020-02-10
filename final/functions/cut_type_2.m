function cuts = cut_type2(boxCropped, debug)

    [r, c, ~] = size(boxCropped);
    tWidth  = floor(c / 6);
    tHeight = floor(r / 4);

    cuts = cell(4, 6);

    k = 1;
    for i = 1 : 4
        startIndexI = (i - 1) * tHeight + 1;
        endIndexI = i * tHeight;
        for j = 1 : 6
            startIndexJ = (j - 1) * tWidth + 1;
            endIndexJ   = j * tWidth;
            target = boxCropped(startIndexI:endIndexI, startIndexJ:endIndexJ, :);

            % Save cut value
            cuts{k}.value = target;
            % Save center
            x = mean([startIndexJ, endIndexJ]);
            y = mean([startIndexI, endIndexI]);
            cuts{k}.center = [y; x];
            
            k = k +1;
        end
    end

    if debug
        figure(7);
        for k = 1 : 24
            subplot(4, 6, k);
            imshow(cuts{k}.value);
            j = floor((k - 1)/6) + 1;
            i = mod((k - 1), 6) + 1;
            text = "(" + j + ", " + i + ")";
            title(text);
        end        
    end
    
end