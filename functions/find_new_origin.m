function new_origin = find_new_origin(rotated_image, rotation_matrix)
    gray_image = rgb2gray(rotated_image);
    [r, c] = size(gray_image);

    cosine = rotation_matrix(1,1);
    sine = rotation_matrix(2,1);

    %% Evaluate new origin position
    if (cosine >= 0 && sine >= 0)
        % West side
        non_zero_pos = find(gray_image(:, 1) > 0, 1);
        new_origin = [1; non_zero_pos];
    elseif (cosine >= 0 && sine <= 0)
        % North side
        non_zero_pos = find(gray_image(1,:) > 0, 1);
        new_origin = [non_zero_pos; 1];
    elseif (cosine <= 0 && sine >= 0)
        % South side
        non_zero_pos = find(gray_image(r-1, :) > 0, 1);
        new_origin = [non_zero_pos; r];
    elseif (cosine <= 0 && sine <= 0)
        % East side
        non_zero_pos = find(gray_image(:, c-1) > 0, 1);
        new_origin = [c; non_zero_pos];
    end

end