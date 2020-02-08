function cuts = cut_type1(boxCropped)

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
            cuts{k} = target;
            k = k +1;
        end
    end
    
end