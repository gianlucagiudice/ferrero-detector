%{
   Returns a struct containing:
   vertices: unsorted list of 4 vertices
   distances: list of pairwise distances between vertices
   vertices_s: sorted list of 4 vertices, the first pair is the one with the longet distance
   distances_s: list of sorted distances      
%}
function box_descriptor = box_vertices(box_label, padding_size)
    debug = false;

   [rows, cols] = size(box_label);
   
   box_label = medfilt2(box_label, [40 40]);
   
   % Detecting the number of hough peaks to find based on the number of incomplete sides
   peaks_count = length(unique(box_label(:, padding_size))) + ...
      length(unique(box_label(:, cols - padding_size))) + ...
      length(unique(box_label(padding_size, :))) + ...
      length(unique(box_label(rows - padding_size, :)));

   %  Preparing input data for Hough transform
   edges = edge(box_label, 'prewitt');   
   [H, T, R] = hough(edges);   
   P = houghpeaks(H, peaks_count, 'Threshold', 0);
   lines = houghlines(edges, T, R, P, 'FillGap', 400, 'MinLength', 30);

   % Preparing vertices map
   vertices_mask = zeros(rows, cols, 3);
   nhv_edges = 0;
   % Draw lines in image
   for k = 1:length(lines)
      xy = [lines(k).point1; lines(k).point2];
      x1 = xy(1,1);
      y1 = xy(1,2);
      x2 = xy(2,1);
      y2 = xy(2,2);
      if (((peaks_count == 4) && (x1 ~= x2)) || ((x1 ~= x2) && (y1 ~= y2))) && nhv_edges < 4
         nhv_edges = nhv_edges + 1;
         m = (y2-y1)/(x2-x1);
         line = insertShape(zeros(rows, cols, 3), 'line', [1, m*(1-x1)+y1, cols, m*(cols-x1)+y1], 'LineWidth', 3, 'Color', [0.5 0.5 0.5], 'SmoothEdges', false);
         vertices_mask = vertices_mask + line;      
      elseif (peaks_count == 4 && (x1 == x2))
         row_mask = zeros(rows, cols);
         row_mask(:, x1) = [0.5 0.5 0.5];
         vertices_mask = vertices_mask + row_mask;
      end
   end
   
   
   % Calculate and return vertex centroid
   vertices_regions = regionprops((vertices_mask(:, :, 1) == 1), 'Centroid');
   vertices = zeros(4, 2);
   for k = 1 : numel(vertices_regions)
      vertices(k, :) = vertices_regions(k).Centroid(:);
   end
   
   disp(vertices);
   % Calculate convex hull for vertices sorting
   convex_hull = convhull(vertices);
   box_descriptor.vertices = zeros(4, 2);
   box_descriptor.distances = zeros(4, 1);
   
   for i = 1 : length(convex_hull) - 1
      box_descriptor.distances(i) = round(pdist2(vertices(convex_hull(i), :), vertices(convex_hull(i + 1), :)));
      box_descriptor.vertices(i, :) = vertices(convex_hull(i), :);
   end

   disp(box_descriptor.vertices);

   % Sorting vertices based on edge length
   [~, index] = max(box_descriptor.distances);
   index = index - 1;
   box_descriptor.distances_s = circshift(box_descriptor.distances, index * -1);
   box_descriptor.vertices_s = circshift(box_descriptor.vertices, index * -1);

   if debug
        figure(4);
        subplot(1,2,1);
        imshow(vertices_mask);
   end
end