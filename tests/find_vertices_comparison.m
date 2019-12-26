%% Import functions
addpath(genpath('functions/'));

%% Get list of images
images = readlist('../data/images.list');

%% Find Edges
scale_factor = 0.5;
% 5, 6, 57
img_path = '../images/original/'+string(images{18}); %14; 21
[original, target_image] = read_and_manipulate(img_path, scale_factor, @rgb2ycbcr, 3);
canny_edge = image_to_edge(target_image);
box_bw = canny2binary(canny_edge);
[r, c] = size(box_bw);

%% Evaluate Pivot
x_proj = sum(box_bw);
y_proj = sum(box_bw');
vertices = [];
[r, c] = size(box_bw);

% Pivot = N
y = find(y_proj > 0, 1, 'first');
x = find(box_bw(y, :)>0, 1, 'last');
vertices(1).value = [x; y];
vertices(1).pivot = "n";
% Pivot = E
x = find(x_proj > 0, 1, 'last');
y = find(box_bw(:, x) > 0, 1, 'first');
vertices(2).value = [x; y];
vertices(2).pivot = "e";
% Pivot = S
y = find(y_proj > 0, 1, 'last');
x = find(box_bw(y, :) > 0, 1, 'first');
vertices(3).value = [x; y];
vertices(3).pivot = "s";
s_vertex = [x; y];
% Pivot = W
x = find(x_proj > 0, 1, 'first');
y = find(box_bw(:, x) > 0, 1, 'first');
vertices(4).value = [x; y];
vertices(4).pivot = "w";

%% Evaluate valid Pivot
% Invalid North => Take south
if vertex_is_valid(vertices(1), r, c) % N
    if vertex_is_valid(vertices(2), r, c) % E
        if vertex_is_valid(vertices(4), r, c) % W
            % North pivot is valid
            out_vertices = [vertices(4);vertices(1);vertices(2)];
            %{
            % Perspective error
            tollerance = 0.15;
            new_vertex = [];
            % Check Perspective error W-S
            difference = vertices(4).value - vertices(3).value;
            if abs(difference(2)) / r < tollerance
                % Correct Perspective error
                new_vertex.value = vertices(3).value + difference;
                new_vertex.pivot = "w";
                out_vertices = [new_vertex;vertices(2);vertices(1)];
            end
            % Check Perspective error E-S
            difference = vertices(2).value - vertices(3).value;
            if abs(difference(2)) / r < tollerance
                % Correct Perspective error
                new_vertex.value = vertices(3).value + difference;
                new_vertex.pivot = "e";
                out_vertices = [vertices(1);vertices(4);new_vertex];
            end
            %}
        else
            % Invalid West => take East
            out_vertices = [vertices(1);vertices(2);vertices(3)];
        end
    else
        % Invalid East => take West
        out_vertices = [vertices(1);vertices(4);vertices(3)];
    end
else
    % Invalid North => take South
    out_vertices = [vertices(4);vertices(3);vertices(2)];
end


%% Show results
figure(1);
subplot(2,2,1);imshow(original);title('Original Image');
subplot(2,2,2);imshow(box_bw);title('Box bw');
% Draw vertices on box
subplot(2,2,3);imshow(box_bw);title('Box bw vertices');
for i = 1:4
    x_plot = vertices(i).value(1);
    y_plot = vertices(i).value(2);
    hold on;
    if vertices(i).pivot == out_vertices(2).pivot
        color = 'g+';
    else
        color = 'r+';
    end
    plot(x_plot, y_plot, color, 'MarkerSize',30, 'LineWidth', 2); 
end
%%Draw vertices on Image
subplot(2,2,4);imshow(original);title('Original Image vertices');
for i = 1:4
    x_plot = vertices(i).value(1) / scale_factor;
    y_plot = vertices(i).value(2) / scale_factor;
    hold on;
    if vertices(i).pivot == out_vertices(2).pivot
        color = 'g+';
    else
        color = 'r+';
    end
    plot(x_plot, y_plot, color,'MarkerSize',30, 'LineWidth', 2);  
end