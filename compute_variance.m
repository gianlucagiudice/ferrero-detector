function out = compute_average_color(tassello)
    [r, c, ch] = size(tassello);
    out = var(reshape(tassello, r*c, ch));
end