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
            cuts{i, j}.value = target;
            
            % Save center
            x = mean([startIndexJ, endIndexJ]);
            y = mean([startIndexI, endIndexI]);
            cuts{i, j}.center = [x; y];
            
            k = k +1;
        end
    end

    
    if debug
        figure(7);
        k = 1;
        for i = 1 : 4
            for j = 1 : 6
                subplot(4, 6, k);
                imshow(cuts{i, j}.value);
                k = k + 1;
                text = "(" + i + ", " + j + ")";
                title(text);
            end        
        end
    end
    
end