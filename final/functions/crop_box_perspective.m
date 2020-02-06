function boxCropped = crop_box_perspective(image, imgPadding, vertices, type)
    vertices = vertices - imgPadding;

    %% Evaluate edges length
    edgesLength = edges_length(vertices);
    edgesLengthSorted = sort(edgesLength);

    %% Evaluate new vertices
    if type == 1
        applyRotation = false;
        vertical = edgesLengthSorted(1);
        horizontal = edgesLengthSorted(1);
    else
        edgePivot = norm(vertices(1, :) - vertices(2, :));
        % Check if need rotation
        if edgePivot == edgesLengthSorted(1) ||  edgePivot == edgesLengthSorted(2)
            applyRotation = true;
            vertical = edgesLengthSorted(4);
            horizontal = edgesLengthSorted(1);
        else
            applyRotation = false;
            vertical =  edgesLengthSorted(1);
            horizontal =  edgesLengthSorted(4);
        end
    end

    % New v1
    newV1 = [1, 1];
    % New v2 
    newV2 = [horizontal, 1];
    % New v3
    newV3 = [horizontal, vertical];
    % New v4
    newV4 = [1, vertical];
    % Oout vertices
    outVertices = [newV1; newV2; newV3; newV4];

    %% Evaluate Transformation
    H = fitgeotrans(vertices, outVertices, 'projective');
    [Iwarp, ref] = imwarp(image, H, 'OutputView', imref2d(size(image)));

    %% Crop box
    boxCropped = imcrop(Iwarp, [1, 1, horizontal, vertical]);

    %% Rotate if necessary
    if applyRotation
        tform = affine2d([0 1 0; -1 0 0; 0 0 1]);
        boxCropped = imwarp(boxCropped, tform);
    end

end