function out_vertices = find_vertices(box_bw)
    [r, c] = size(box_bw);
    vertices = [];

    %% Pivot max_n: Maximize function, m = -1 (n = negative)
    vertices(1).pivot = "max_n";
    flag = 0;
    for i = 1 : r + c
        for j = 1 : i
            y = j;
            x = c - i + j;
            if (y > r)
                break
            end
            if box_bw(y, x) == 1
                vertices(1).value = [x; y];
                flag = 1;
                break;
            end
        end
        if flag
            break
        end
    end
    
    %% Pivot max_p: Maximize function, m = +1 (p = positive)
    vertices(2).pivot = "max_p";
    flag = 0;
    for i = 1 : r + c
        for j = 1 : i
            y = i - j + 1;
            x = j;
            if (i > r)
                y = r - j + 1;
                x = i - r + j;
            end
            if (y<1)
                break
            end
            if box_bw(y, x) == 1
                vertices(2).value = [x; y];
                flag = 1;
                break;
            end
        end
        if flag
            break
        end
    end
    
    %% Pivot min_p: Minimize function, m = +1 (p = positive)
    vertices(3).pivot = "min_p";
    flag = 0;
    for i = 1 : r + c
        for j = 1 : i
            y = r-i+j;
            x = c-j+1;
            if (y < 1)
                y = abs(r-i);
                x = c - y;
            end
            if box_bw(y, x) == 1
                vertices(3).value = [x; y];
                flag = 1;
                break;
            end
        end
        if flag
            break
        end
    end
    
    %% Pivot min_n: Minimize function, m = -1 (n = negative)
    vertices(4).pivot = "min_n";
    flag = 0;
    for i = 1 : r + c
        for j = 1 : i
            x = j;
            y = r-i+j;
            if (i > r)
                y = j;
                x = i - r + j;
            end
            if (y > r)
                break
            end
            if box_bw(y, x) == 1
                vertices(4).value = [x; y];
                flag = 1;
                break;
            end
        end
        if flag
            break
        end
    end

    %% Evaluate valid Pivot
    % Invalid max_n => min_n
    if vertex_is_valid(vertices(1), r, c) % max_n
        if vertex_is_valid(vertices(3), r, c) % min_p
            if vertex_is_valid(vertices(2), r, c) % max_p
                % max_n pivot is valid
                out_vertices = [vertices(2);vertices(1);vertices(3)];
            else
                % Invalid max_p => take min_p
                out_vertices = [vertices(1);vertices(3);vertices(4)];
            end
        else
            % Invalid min_p => take max_p
            out_vertices = [vertices(1);vertices(2);vertices(4)];
        end
    else
        % Invalid max_n => min_n
        out_vertices = [vertices(2);vertices(4);vertices(3)];
    end

end