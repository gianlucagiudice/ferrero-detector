function out = compute_std(tassello)
    [r, c, ch] = size(tassello);
    out = std(reshape(tassello, r*c, ch));
end