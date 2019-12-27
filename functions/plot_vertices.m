function plot_vertices(vertices)
    hold on;
    for j = 1:3
        x_plot = vertices(j).value(1);
        y_plot = vertices(j).value(2);
        if j == 2
            color = 'g+';
        else
            color = 'r+';
        end
        plot(x_plot, y_plot, color, 'MarkerSize',30, 'LineWidth', 2); 
    end
end