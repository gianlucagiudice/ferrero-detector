function regions = cut_type2(image)
    [r, c, ~] = size(image);
    cols  = floor(c / 6);
    rows = floor(r / 4);

    regions = cell(4, 6);
    radius = min(cols, rows) * 0.8;

    for i = 1 : 4
        center_r = round((i -1) * rows / 2);

        for j = 1 : 6
            center_c = round((j - 1) * cols / 2);
            regions{i, j}.value = crop_centroid(image, [center_r, center_c], radius);
            regions{i, j}.center = [center_r, center_c];
            regions{i, j}.radius = radius;
        end
    end
end