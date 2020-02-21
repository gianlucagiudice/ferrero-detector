%% Normalize resolution
% Resize all images to a fixed height

function outImage = normalize_resolution(image)
    % Dataset original height resolution
    fixedRow = 2592;
    [r, ~, ~] = size(image);

    scaleFactor = fixedRow / r;
    % Normalize resolution
    outImage = imresize(image, scaleFactor);

end
