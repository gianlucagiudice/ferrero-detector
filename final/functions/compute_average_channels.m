function out = compute_average_color(tassello)
    [r, c, ch] = size(tassello);
    hsv   = rgb2hsv(tassello);
    ycbcr = rgb2ycbcr(tassello); 
    mean_saturation = mean(reshape(hsv(:,:,2), r*c, 1));
    mean_cb = mean(reshape(ycbcr(:,:,2), r*c, 1));
    out = [mean_saturation, mean_cb];

end