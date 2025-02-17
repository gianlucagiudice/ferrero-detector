%% Classify box type
% given 4 vertices, returns if the box is square (1) or rectangular (2)

function boxType = classify_box_type(vertices, classifier, debug)
    typeFeature = compute_type_feature(vertices);
    boxType = classifier.predict(typeFeature);

    if debug
        if boxType == 1
            disp("Box shape is: Square");
        else
            disp("Box shape is: Rectangle");
        end
    end

end
