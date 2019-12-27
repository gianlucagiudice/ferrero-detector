function scaled_vertices = scale_vertices(vertices, scale_factor)
    scaled_vertices = [];
    for i = 1 : length(vertices)
        scaled_vertices(i).pivot = vertices(i).pivot;
        scaled_vertices(i).value = vertices(i).value / scale_factor;
    end
end