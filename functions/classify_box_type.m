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