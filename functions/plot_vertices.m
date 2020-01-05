function plot_vertices(vertices)
    save_vertices = vertices;
    vertices = [];
    for i = 1 : length(save_vertices)
        if (isfield(save_vertices(i), 'value'))
            vertex = save_vertices(i).value;
        else
            vertex = save_vertices(:, i);
        end
        vertices = [vertices, vertex(:)];
    end
    
    hold on;
    for j = 1:3
        x_plot = vertices(1, j);
        y_plot = vertices(2, j);
        if j == 2
            color = 'g+';
        else
            color = 'r+';
        end
        plot(x_plot, y_plot, color, 'MarkerSize',30, 'LineWidth', 2); 
    end
end