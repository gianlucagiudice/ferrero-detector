function image = plot_errors(image, vertices, errors, scaleFactor, padding)
    %% Evaluate original points position
    vertices = (vertices - padding) / scaleFactor;
    errors = errors / scaleFactor;
    
    if length(errors) == 0
        % No errors
        boundaryColor = 'g';
    else
        boundaryColor = 'r';

        %% Draw errors
        circle = [];
        for i = 1:length(errors)
            circle = [circle; errors(i, 1), errors(i, 2), 100];
        end
        image = insertShape(image, 'Circle', circle,'LineWidth',15,'Color','blue');

    end
    
    %% Draw boundary
    boundary = [];
    for i = 1:length(vertices)
        boundary = [boundary, vertices(i, 1), vertices(i, 2)];
    end
    boundary = [boundary, vertices(1,1), vertices(1,2)];
    
    image = insertShape(image, 'Line',boundary,'LineWidth',40,'Color',boundaryColor);
end