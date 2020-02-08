%% Load descriptors and label
addpath(genpath('../functions/'));
load('../../data/edges.mat');

saveClassifier = false;

%% Get data
labels = edges.labels;
lenEdges = edges.descriptors;
% Sort each rows
lenEdges = sort(lenEdges, 2);

%% Feature 1 - Variance middle edges sorted
feature1 = std(lenEdges(:, 2:3), 1, 2) ./ lenEdges(:, 4);

%% Feature 2 - Ratio edges middle
feature2 = lenEdges(:, 2) ./ lenEdges(:, 3);

%% Feature 3 - Ratio edges outermost
feature3 = lenEdges(:, 1) ./ lenEdges(:, 4);

% Remove outlier
c1 = feature3(labels == 1);
c1 = sort(c1);
c2 = feature3(labels == 2);
c2 = sort(c2);
outlier = 0.1;

n1 = round(length(c1) * outlier);
out1 = c1(1 + n1 : length(c1) - n1);
out1 = [out1, zeros(length(out1), 1) + 1];

n2 = round(length(c2) * outlier);
out2 = c2(1 + n2 : length(c2) - n2);
out2 = [out2, zeros(length(out2), 1) + 2];

enhancementF3 = [out1; out2];

%% Outliers removed
features = enhancementF3(:, 1);
labels = enhancementF3(:, 2);

%% Portion of taining-set test-set
testPortion = 0.8;
cv = cvpartition(labels, 'holdout', testPortion);

%% Nearest neighbor
disp("Nearest neighbor:")
[tr1, ts1, boxTypeClassifier] = test_classifier(features, labels, cv, @fitcknn);
disp("Training set");
disp(tr1);
disp("Test set");
disp(ts1);

%% Classification tree
disp("- - - - - - -");
disp("Classification tree:")
[tr2, ts2, ~] = test_classifier(features, labels, cv, @fitctree);
disp("Training set");
disp(tr2);
disp("Test set");
disp(ts2);

%% Naive Bayes model
disp("- - - - - - -");
disp("Naive Bayes model:")
[tr3, ts3, ~] = test_classifier(features, labels, cv, @fitcnb);
disp("Training set");
disp(tr3);
disp("Test set");
disp(ts3);

%% Classification Learner toolbox
T = table(features, labels);

%% Save classifier
if saveClassifier
    save('boxTypeClassifier', 'boxTypeClassifier');
end

%{
%% Fisher criterion:
disp("- - - - - - -");
disp("Fisher criterion:")
% Average
muRatioSquares = mean(feature2(labels == 1));
muRatioRectangles = mean(feature2(labels == 2));
% Variance
stdRatioSquares = std(feature2(labels == 1));
stdRatioRectangles = std(feature2(labels == 2));
% Threshold
fisherCriterion = ...
    ((muRatioRectangles - muRatioSquares)^2) / ...
    (stdRatioRectangles^2 + stdRatioSquares^2);

%% Show results
disp("Mean ratio squares    = "+muRatioSquares);
disp("Std ratio squares     = "+stdRatioSquares);
disp("---");
disp("Mean ratio rectangles = "+muRatioRectangles);
disp("Std ratio rectangles  = "+stdRatioRectangles);
disp("---");
disp("Best threshold using Fisher Criterion = "+ fisherCriterion);
%}


%% Plot features
figure
subplot(2, 2, 1);
histogram(feature1, 64), title("F1 - Variance middle edges sorted");
xlabel("Variance");
ylabel("Occurence")

subplot(2, 2, 2);
histogram(feature2, 64), title("F2 - Ratio middle edges sorted ");
xlabel("Ratio outermost");
ylabel("Occurence")

subplot(2, 2, 3);
histogram(feature3, 'Normalization','probability','BinWidth',0.005), title("F3 - Ratio outermost edges sorted");
xlabel("Ratio middle");
ylabel("Occurence")

subplot(2, 2, 4);
histogram(enhancementF3(:, 1), 'Normalization','probability', 'BinWidth',0.005), title("F3 outliers (0.1%) removed");
xlabel("Ratio middle");
ylabel("Occurence")
