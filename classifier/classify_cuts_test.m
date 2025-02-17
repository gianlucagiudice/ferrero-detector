clear all;
addpath(genpath('../functions/'));

%% Load descriptors and label
load('../data/cuts');

saveClassifier = false;

%% Get labels
labels = cuts.labels;
descriptor = cuts.descriptors;

%% Portion of taining-set test-set
testPortion = 0.25;
cv = cvpartition(labels, 'holdout', testPortion);

classifier = @fitcknn;
%classifier = @fitctree;
%classifier = @fitcnb;

feature1 = descriptor.lbp;
[tr1, ts1] = test_classifier(feature1, labels, cv, classifier);

feature2 = descriptor.cedd;
[tr2, ts2] = test_classifier(feature2, labels, cv, classifier);

feature3 = descriptor.qhist;
[tr3, ts3] = test_classifier(feature3, labels, cv, classifier);

feature4 = [descriptor.cedd, descriptor.lbp, descriptor.qhist];
[tr4, ts4] = test_classifier(feature4, labels, cv, classifier);

feature5 = descriptor.avg;
[tr5, ts5] = test_classifier(feature5, labels, cv, classifier);

feature6 = [descriptor.avg, descriptor.lbp];
[tr6, ts6] = test_classifier(feature6, labels, cv, classifier);

feature13 = descriptor.min_avg_region;
[tr13, ts13] = test_classifier(feature13, labels, cv, classifier);

feature14 = [descriptor.avg, descriptor.lbp, descriptor.min_avg_region];
[tr14, ts14, cutClassifier] = test_classifier(feature14, labels, cv, classifier);

feature7 = [descriptor.avg, descriptor.lbp, descriptor.cedd];
[tr7, ts7] = test_classifier(feature7, labels, cv, classifier);

feature8 = [descriptor.qhist, descriptor.lbp];
[tr8, ts8] = test_classifier(feature8, labels, cv, classifier);

feature9 = descriptor.std;
[tr9, ts9] = test_classifier(feature9, labels, cv, classifier);

feature10 = descriptor.qhist_hsv_s;
[tr10, ts10] = test_classifier(feature10, labels, cv, classifier);

feature11 = [descriptor.qhist, descriptor.lbp, descriptor.qhist_hsv_s];
[tr11, ts11] = test_classifier(feature11, labels, cv, classifier);

feature12 = [descriptor.avg, descriptor.lbp];
[tr12, ts12] = test_classifier(feature12, labels, cv, classifier);

%% Save classifier
if saveClassifier
    save('cutClassifier', 'cutClassifier');
end


%% Classification Learner toolbox
T7 = table(feature7, labels);

%% Show results
disp("LBP");
disp("Training set");
disp(tr1);
disp("Test set");
disp(ts1);

disp("- - - - - - - -");

disp("CEDD");
disp("Training set");
disp(tr2);
disp("Test set");
disp(ts2);

disp("- - - - - - - -");

disp("CEDD, LBP, QHIST");
disp("Training set");
disp(tr4);
disp("Test set");
disp(ts4);

disp("- - - - - - - -");

disp("AVG");
disp("Training set");
disp(tr5);
disp("Test set");
disp(ts5);

disp("- - - - - - - -");

disp("STD");
disp("Training set");
disp(tr9);
disp("Test set");
disp(ts9);

disp("- - - - - - - -");

disp("AVG, LBP, CEDD");
disp("Training set");
disp(tr7);
disp("Test set");
disp(ts7);

disp("- - - - - - - -");

disp("QHIST HSV_S");
disp("Training set");
disp(tr10);
disp("Test set");
disp(ts10);

disp("- - - - - - - -");

disp("QHIST HSV_S, LBP, HSV_S");
disp("Training set");
disp(tr11);
disp("Test set");
disp(ts11);

disp("- - - - - - - -");

disp("QHIST, LBP");
disp("Training set");
disp(tr8);
disp("Test set");
disp(ts8);

disp("- - - - - - - -");

disp("QHIST");
disp("Training set");
disp(tr3);
disp("Test set");
disp(ts3);

disp("- - - - - - - -");

disp("AVG, LBP, STD");
disp("Training set");
disp(tr12);
disp("Test set");
disp(ts12);

disp("- - - - - - - -");

disp("AVG, LBP");
disp("Training set");
disp(tr6);
disp("Test set");
disp(ts6);

disp("- - - - - - - -");

disp("MIN Region");
disp("Training set");
disp(tr13);
disp("Test set");
disp(ts13);

disp("- - - - - - - -");

disp("AVG, LBP, MIN Region");
disp("Training set");
disp(tr14);
disp("Test set");
disp(ts14);


%% Performance results

xlabels = {'lbp','qhist','avg','qhist+lbp','avg+lbp','avg+lbp+std','avg+lbp+min\_region'};

tr = [tr1.accuracy, tr3.accuracy, tr5.accuracy, tr8.accuracy, tr6.accuracy, tr12.accuracy];
ts = [ts1.accuracy, ts3.accuracy, ts5.accuracy, ts8.accuracy, ts6.accuracy, ts12.accuracy];

figure(10), bar([tr' ts']);
legend({'training','test'},'location','eastoutside');
set(gca,'XTick',1:numel(xlabels),'XTickLabel',xlabels);
ylim([0.93 1])