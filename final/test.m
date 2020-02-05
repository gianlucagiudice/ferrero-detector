image = imread('out.png');
out = box_vertices(image, 5);
bar = regionprops(image, 'Centroid');

[r, c] = size(image);
i = zeros(r, c, 1);
disp(out);
figure(1);
imshow(image);
axis on 
hold on;

viscircles(out.vertices_s(1, :), 10, 'Color', 'r');
viscircles(out.vertices_s(2, :), 10, 'Color', 'g');
viscircles(out.vertices_s(3, :), 10, 'Color', 'b');
viscircles(out.vertices_s(4, :), 10, 'Color', 'y');

