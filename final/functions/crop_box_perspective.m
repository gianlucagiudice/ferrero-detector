function [boxCropped, tForm] = crop_box_perspective(image, sf, imgPadding, vertices, type, debug)
    vertices = (vertices - imgPadding) * sf;

    %% Evaluate edges length
    edgesLength = edges_length(vertices);
    edgesLengthSorted = sort(edgesLength);

    %% Evaluate new vertices
    if type == 1
        vertical = edgesLengthSorted(1);
        horizontal = edgesLengthSorted(1);
    else
        vertical =  edgesLengthSorted(1);
        horizontal =  edgesLengthSorted(4);
    end

    %% Evaluate new vertices
    newV1 = [1, 1];
    newV2 = [horizontal, 1];
    newV3 = [horizontal, vertical];
    newV4 = [1, vertical];
    outVertices = [newV1; newV2; newV3; newV4];

    %% Compute Transformation
    H = fitgeotrans(vertices, outVertices, 'projective');
    tForm = maketform('projective', H.T);
    Iwarp = imwarp(image, H, 'OutputView', imref2d(size(image)));
    
    %% Crop box
    boxCropped = imcrop(Iwarp, [1, 1, horizontal, vertical]);

    %% Debug
    if debug
        figure(5);
        subplot(2,2,1)
        imshow(image);title("Original Image");
        subplot(2,2,2)
        imshow(Iwarp);title("Perspective adjust");
        subplot(2,2,3)
        imshow(boxCropped);title("Box cropped");
    end

end