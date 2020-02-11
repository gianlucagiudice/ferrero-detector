function outV = inverse_transformation(T, errors, padding)
    outV = [];
    
    for i = 1 : length(errors)
        x = errors(i, 1) + padding;
        y = errors(i, 2) + padding;
        t = round(tforminv(T, y, x));
        outV = [outV; t(1, :)];
    end

    outV = round(outV - padding'); 
    disp(length(outV));
end