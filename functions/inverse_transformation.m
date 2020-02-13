function outV = inverse_transformation(T, errors, padding)
    outV = [];
    
    for i = 1 : size(errors, 1)
        x = errors(i, 1) + padding;
        y = errors(i, 2) + padding;
        t = round(tforminv(T, x,y));
        outV = [outV; t(1, :)];
    end
    
    if isempty(outV) == false
        outV = round(outV - padding'); 
    end

end