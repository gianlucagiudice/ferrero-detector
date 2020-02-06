%{
Returns a struct containing:
vertices:unsorted list of 4 vertices
distances:list of pairwise distances between vertices
vertices_s:sorted list of 4 vertices, the first pair is the one with the longet distance
distances_s:list of sorted distances
%}
function outVertices = box_vertices(box_label, padding_size)
    debug = true;

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

    % Get valid lines
    nhv_edges = 0;
    validLines = [];

    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        x1 = xy(1, 1); y1 = xy(1, 2);
        x2 = xy(2, 1); y2 = xy(2, 2);

        if nhv_edges < 4

            if peaks_count == 4
                validLines = [validLines; lines(:, k)];

                if (x1 ~= x2)
                    nhv_edges = nhv_edges + 1;
                end

            elseif (x1 ~= x2) && (y1 ~= y2)
                validLines = [validLines; lines(:, k)];
                nhv_edges = nhv_edges + 1;
            end

        else
            break
        end

    end

    %% Find intersection points
    rhos = [validLines.rho];
    % Converts degrees to radiants
    thetas = [validLines.theta] * pi / 180;

    %% Vertices
    vertices = [];

    for i = 1 : numel(validLines)

        for j = i + 1 : numel(validLines)
            A = [cos(thetas(i)) sin(thetas(i)); cos(thetas(j)) sin(thetas(j))];
            B = [rhos(i); rhos(j)];
            C = round(linsolve(A, B));
            x = C(1); y = C(2);

            if (x < 0) || (y < 0) || x > cols || y > rows
                continue;
            end

            vertices = [vertices; x y];
        end

    end

    % Calculate convex hull for vertices sorting
    convex_hull = convhull(vertices);

    for i = 1:length(convex_hull) - 1
        distances(i) = round(pdist2(vertices(convex_hull(i), :), vertices(convex_hull(i + 1), :)));
        outVertices(i, :) = vertices(convex_hull(i), :);
    end
    %{
    box_descriptor.vertices = zeros(4, 2);
    box_descriptor.distances = zeros(4, 1);

    for i = 1:length(convex_hull) - 1
        box_descriptor.distances(i) = round(pdist2(vertices(convex_hull(i), :), vertices(convex_hull(i + 1), :)));
        box_descriptor.vertices(i, :) = vertices(convex_hull(i), :);
    end

    % Sorting vertices based on edge length
    [~, index] = max(box_descriptor.distances);
    index = index - 1;
    box_descriptor.distances_s = circshift(box_descriptor.distances, index * -1);
    box_descriptor.vertices_s = circshift(box_descriptor.vertices, index * -1);
    %}


    if debug
        %% Casi particolari = 17
        
        
        figure;
        
        %% Box mas
        subplot(2,2,1); 
        imshow(box_label), title("Box mask");
        
        %% Box edge
        subplot(2, 2, 2);
        imshow(edges), title("Edges image");
        
        %% Hough transform
        subplot(2,2,3);
        imagesc(H), colorbar, title("Hough Transform");
        xlabel('\theta'), ylabel('\rho');
        axis on, axis normal, hold on;
        plotX = T(P(:,2)) + 90;
        plotY = R(P(:,1)) + round(length(H) / 2);
        plot(plotX, plotY,'s','color','white');
        
        %% Mask with lines
        subplot(2,2,4);
        imshow(box_label), title("Vertices");
        hold on
        X = [1: size(box_label, 2)];
        
        for n = 1:numel(rhos)
            Y = (rhos(n) - X * cos(thetas(n))) / sin(thetas(n)); % valori delle coordinate y
            % Si risolve su y l'equazione rho=x*cos(theta)+y*sin(theta)
            plot(X, Y, 'r-', 'LineWidth', 1);
        end
        
        % Vertices
        viscircles(vertices(1, :), 10, 'Color', 'm');
        viscircles(vertices(2, :), 10, 'Color', 'g');
        viscircles(vertices(3, :), 10, 'Color', 'b');
        viscircles(vertices(4, :), 10, 'Color', 'y');
        %imshow(vertices_mask);
    end

end
