function outMin = compute_min_region_avg(image)
    img = rgb2hsv(image);
    img = img(:,:,2);
    t = round(length(img) / 10);
    img_filt = medfilt2(img, [t t], 'symmetric');
    [L,N] = superpixels(img_filt, 30);
    
    idx = label2idx(L);
    outMin = +Inf;
    for labelVal = 1:N
        i = idx{labelVal};
        outMin = min(outMin, mean(img_filt(i)));
    end

end