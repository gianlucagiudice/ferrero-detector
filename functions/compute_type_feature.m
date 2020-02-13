function typeFeature = compute_type_feature(vertices)
    edgesLength = edges_length(vertices);
    eSorted = sort(edgesLength);
    typeFeature = eSorted(1) / eSorted(4);
end