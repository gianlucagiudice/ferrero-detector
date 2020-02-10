function outV = inverse_transformation(T, errors, padding)
    outV = [];
    
    for i = 1 : length(errors)
        targetPos = errors(:, i) + padding;
        outV = [outV; tforminv(T, targetPos)];
    end

    outV = round(outV - padding'); 
end