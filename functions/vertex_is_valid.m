function valid = vertex_is_valid(vertex, r, c)
    valid = true;
    if vertex.pivot == "n"
        if vertex.value(2) == 1
            valid = false;
        end
    elseif vertex.pivot == "e"
        if vertex.value(1) == r
            valid = false;
        end
    elseif vertex.pivot == "s"
        if vertex.value(2) == c
            valid = false;
        end
    elseif vertex.pivot == "w"
        if vertex.value(1) == 1
            valid = false;
        end
    end
end
