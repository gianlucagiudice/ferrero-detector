function [boxEnhanced, padding] = crop_enhancement(img, debug)
    p1 = 0.05;
    p2 = 0.04;

    % Box image
    [r, c, ~] = size(img);
    
    % Different padding based on box type
    if r == c
        p = p1;
    else
        p = p2;
    end

    % Padding size
    xPad = c*p;
    yPad = r*p;
    boxEnhanced = imcrop(img, [xPad yPad c-2*xPad r-2*yPad]);

    % Padding vector
    padding = [xPad; yPad];
    
    if debug
        figure(6);
        subplot(1,2,1);
        imshow(img); title("Original cropped image");
        subplot(1,2,2);
        imshow(boxEnhanced); title("Crop enhanced");
    end
end