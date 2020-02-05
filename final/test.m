image = imread('out.png');
out = box_vertices(image, 5);
bar = regionprops(image, 'Centroid');

[r, c] = size(image);
i = zeros(r, c, 1);
i(out(1, 2), out(1, 1)) = 1;
i(out(2, 2), out(2, 1)) = 1;
i(out(3, 2), out(3, 1)) = 1;
i(out(4, 2), out(4, 1)) = 1;

i(1,1) = 1;


%{
 i = i + insertShape(zeros(r, c), 'line', [out(1, 1) out(1, 2) out(2, 1) out(2, 2)], 'Color', [0.5 0.5 0.5], 'SmoothEdges', false);
i = i + insertShape(zeros(r, c), 'line', [out(1, 1) out(1, 2) out(3, 1) out(3, 2)], 'Color', [0.5 0.5 0.5], 'SmoothEdges', false);
i = i + insertShape(zeros(r, c), 'line', [out(1, 1) out(1, 2) out(4, 1) out(4, 2)], 'Color', [0.5 0.5 0.5], 'SmoothEdges', false);
i = i + insertShape(zeros(r, c), 'line', [out(2, 1) out(2, 2) out(3, 1) out(3, 2)], 'Color', [0.5 0.5 0.5], 'SmoothEdges', false);
i = i + insertShape(zeros(r, c), 'line', [out(2, 1) out(2, 2) out(4, 1) out(4, 2)], 'Color', [0.5 0.5 0.5], 'SmoothEdges', false);
i = i + insertShape(zeros(r, c), 'line', [out(3, 1) out(3, 2) out(4, 1) out(4, 2)], 'Color', [0.5 0.5 0.5], 'SmoothEdges', false); 
%}



figure(1);
imshow(i);
axis on 
hold on;


%{
 viscircles(out(1, :), 10);
viscircles(out(2, :), 10);
viscircles(out(3, :), 10);
viscircles(out(4, :), 10); 
%}


P = out;
k = convhull(P);
plot(P(:,1),P(:,2),'*')
hold on
plot(P(k,1),P(k,2)) 

