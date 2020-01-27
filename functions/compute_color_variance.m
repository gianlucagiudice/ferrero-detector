function out = compute_average_color(tassello)
    [r, c, ch] = size(tassello);
    reshaped = reshape(tassello, r*c, ch);

    out = [mean(reshaped), var(reshaped)];
end