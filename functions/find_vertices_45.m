function out_vertices = find_vertices(box_bw)
    [r, c] = size(box_bw);
    
    figure(2);
    imshow(box_bw);

    vertices = [];

    %% Evaluate Pivot
    % Pivot = Maximize function, m = +1 (positive = p)
    vertices(1).pivot = "max_p";
    flag = 0;
    for i = 1 : r
        for j = 1 : i
            if box_bw(i-j+1,j) == 1
                vertices(1).value = [j; i-j+1];
                flag = 1;
                break;
            end
        end
        if flag
            break
        end
    end

    disp(vertices(1).value);
    
    % Pivot = Minimize function, m = +1 (positive = p)
    vertices(2).pivot = "min_p";
    flag = 0;
    for i = 1 : r
        for j = 1 : i
            if box_bw(r-i+1, c-j+1) == 1
                disp(i);
                disp(j);
                disp(c-j+1);
                disp(r-i+1);

                vertices(2).value = [r-i; c-j];
                flag = 1;
                break;
            end
        end
        if flag
            break
        end
    end
    
    disp(vertices(2).value);

    % Pivot = S
    y = find(y_proj > 0, 1, 'last');
    x = find(box_bw(y, :) > 0, 1, 'first');
    vertices(3).value = [x; y];
    vertices(3).pivot = "s";
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

end