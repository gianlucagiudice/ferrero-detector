function [train_perf, test_perf, c] = test_classifier(descriptor, labels, cv, classifier)
    % Testa un classificatore con i dati descrittori e partizionamento.
    % Paramnetri: 
    %   descriptor : descrittore/i da usareper la classificazione
    %   labels : etichette dell eimmagini
    %   cv : output di cvpartition con le partizioni train set / test set
    %
    %   Ritorna le performance del classificatore in fase di training e in
    %   fase di test
    
    %% Reshape descriptor
    train.values = descriptor(cv.training,:);
    train.labels = labels(cv.training);
    
    test.values  = descriptor(cv.test,:);
    test.labels  = labels(cv.test);
    
    %% Train classifier
    c = classifier(train.values, train.labels);
	
	%% Predict using classifier
	train.predicted = predict(c, train.values);
    train_perf = confmat(train.labels, train.predicted);
  
    test.predicted = predict(c, test.values);
	test_perf = confmat(test.labels, test.predicted);
	
end