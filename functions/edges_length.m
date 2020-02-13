function edgesLength = edges_length(vertices)
    edgesLength = zeros(1, length(vertices));

    for i = 1:length(vertices)
        % Evaluate next index
        nextI = mod(i + 1, 5) + floor(i / length(vertices));
        v1 = vertices(i, :);
        v2 = vertices(nextI, :);
        edgesLength(i) = norm(v1 - v2);
    end
    
    edgesLength = round(edgesLength);

end
