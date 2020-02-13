function regions = cut_type2(image, debug)
    [r, c, ~] = size(image);
    cols  = floor(c / 6);
    rows = floor(r / 4);

    regions = cell(4, 6);
    radius = min([cols / 2, rows / 2]) * 0.8;
    

    for i = 1 : 4
        center_r = round((i -1) * rows + rows / 2);

        for j = 1 : 6
            center_c = round((j - 1) * cols + cols / 2);
            regions{i, j}.value = crop_centroid(image, [center_c, center_r], radius);
            regions{i, j}.center = [center_c, center_r];
            regions{i, j}.radius = radius;
        end
    end

    if debug
        figure(7);
        k = 1;
        for i = 1 : 4
            for j = 1 : 6
                subplot(4, 6, k);
                imshow(regions{i, j}.value);
                k = k + 1;
                text = "(" + i + ", " + j + ")";
                title(text);
            end
        end
    end
end