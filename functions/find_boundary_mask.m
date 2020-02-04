function outputImage = find_boundary_mask(boxCroppped, numLabels)
    [r, c, ch] = size(boxCroppped);
    
    [L, N] = superpixels(boxCroppped, numLabels);
    
    outputImage = zeros(size(boxCroppped),'like', boxCroppped);
    idx = label2idx(L);
    
    for targetLabel = 1 : N
        redIdx = idx{targetLabel};
        greenIdx = idx{targetLabel} + r * c;
        blueIdx = idx{targetLabel} + 2 * r * c;
        outputImage(redIdx) = mean(boxCroppped(redIdx));
        outputImage(greenIdx) = mean(boxCroppped(greenIdx));
        outputImage(blueIdx) = mean(boxCroppped(blueIdx));
    end

end
