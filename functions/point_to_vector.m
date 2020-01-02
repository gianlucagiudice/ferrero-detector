function vector = point_to_vector(pivot, vertex)
    if (isfield(pivot, 'value'))
        pivot = pivot.value;
    end
    if (isfield(vertex, 'value'))
        vertex = vertex.value;
    end
    
    if (pivot(1) >= vertex(1) && pivot(2) >= vertex(2))
        x = vertex(1) - pivot(1);
        y = pivot(2) - vertex(2);
    elseif(pivot(1) >= vertex(1) && pivot(2) <= vertex(2))
        x = vertex(1) - pivot(1);
        y = pivot(2) - vertex(2);
    elseif(pivot(1) <= vertex(1) && pivot(2) >= vertex(2))
        x = vertex(1) - pivot(1) ;
        y = pivot(2)  - vertex(2);
    elseif(pivot(1) <= vertex(1) && pivot(2) <= vertex(2))
        x = vertex(1) - pivot(1);
        y = pivot(2) - vertex(2);
    end

    vector = [x; y];

end