addpath(genpath('../functions/'));

%% Get list of images
images = readlist('../data/images.list');
scaleFactor = 0.5;
imgPadding = 300;

%% Processing
targetIndex = 46;

%% Read image
imgPath = '../images/original/'+string(images{targetIndex});
[~, scaledImage, targetImage] = read_and_manipulate(imgPath, scaleFactor, @rgb2ycbcr, 2);

%% Find edges
cannyEdge = image_to_edge(targetImage);


%% Adjust Perspective
vertices = [937 29; 1450 328; 946 1031; 394 634];

type = 2; %% Recatangular

%% Out vertices
% Find longest and shortes edge
edgesLength = zeros(1, 4);
for i = 1 : 4
    % Evaluate next index
    nextI = mod(i+1, 5) + floor(i / length(vertices));
    v1 = vertices(i, :);
    v2 = vertices(nextI, :);
    edgesLength(i) = norm(v1 - v2);
end
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
[Iwarp, ref] = imwarp(scaledImage, H, 'OutputView', imref2d(size(scaledImage)));

%% Crop box
boxCropped = imcrop(Iwarp, [1, 1, horizontal, vertical]);

%% Rotate if necessary
if applyRotation
    tform = affine2d([0 1 0; -1 0 0; 0 0 1]);
    boxCroppedRotated = imwarp(boxCropped, tform);
end

%% Show results
figure(1);
%% Show orignal image
subplot(2,2,1)
imshow(scaledImage);title("Original Image");
hold on;
% Plot vertice
for i = 1 : 4
    x = vertices(i, 1);
    y = vertices(i, 2);
    plot(x, y, 'g+', 'MarkerSize', 15, 'LineWidth', 2);
end
subplot(2,2,2)
imshow(Iwarp);title("Perspective adjust");
subplot(2,2,3)
imshow(boxCropped);title("Perspective adjust");
subplot(2,2,4)
imshow(boxCroppedRotated);title("Perspective adjust");
