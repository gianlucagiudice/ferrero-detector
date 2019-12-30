function vector = point_to_vector(pivot, vertex)
    if (pivot.value(1) > vertex.value(1) && pivot.value(2) > vertex.value(2))
        x = vertex.value(1) - pivot.value(1);
        y = pivot.value(2) - vertex.value(2);
    elseif(pivot.value(1) > vertex.value(1) && pivot.value(2) < vertex.value(2))
        x = vertex.value(1) - pivot.value(1);
        y = pivot.value(2) - vertex.value(2);
    elseif(pivot.value(1) < vertex.value(1) && pivot.value(2) > vertex.value(2))
        x = vertex.value(1) - pivot.value(1) ;
        y = pivot.value(2)  - vertex.value(2);
    elseif(pivot.value(1) < vertex.value(1) && pivot.value(2) < vertex.value(2))
        x = vertex.value(1) - pivot.value(1);
        y = pivot.value(2) - vertex.value(2);
    end
    vector = [x; y];
end