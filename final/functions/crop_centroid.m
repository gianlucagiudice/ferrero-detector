function pixels = crop_centroid(image, center, radius)
   [r, c, ~] = size(image);
   image = im2double(image);
   radius = min([radius, center(1), center(2), c-center(1), r-center(2)]) - 1;
   radius = round(radius);
   pixels = image(center(2)-radius:center(2)+radius, center(1)-radius:center(1)+radius, :);
end