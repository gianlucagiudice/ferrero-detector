function vector = vector_point_pivot(vertex, pivot)
    if (pivot.value(1) > vertex.value(1) && pivot.value(2) > vertex.value(2))
        x = pivot.value(1) - vertex.value(1);
        y = pivot.value(2) - vertex.value(2);
    elseif(pivot.value(1) > vertex.value(1) && pivot.value(2) < vertex.value(2))
        x = pivot.value(1)  - vertex.value(1);
        y = vertex.value(2) - pivot.value(2);
    elseif(pivot.value(1) < vertex.value(1) && pivot.value(2) > vertex.value(2))
        x = vertex.value(1) - pivot.value(1) ;
        y = pivot.value(2)  - vertex.value(2);
    elseif(pivot.value(1) < vertex.value(1) && pivot.value(2) < vertex.value(2))
        x = pivot.value(1)  - vertex.value(1) ;
        y = vertex.value(2) - pivot.value(2);
    end
    vector = [x, y];
end