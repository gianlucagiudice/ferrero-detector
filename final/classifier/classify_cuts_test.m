clear all;
addpath(genpath('../functions/'));

%% Load descriptors and label
load('../../data/cuts');

saveClassifier = true;

%% Get labels
labels = cuts.labels;
descriptor = cuts.descriptors;

%% Portion of taining-set test-set
testPortion = 0.3;
cv = cvpartition(labels, 'holdout', testPortion);

classifier = @fitcknn;
%classifier = @fitctree;
%classifier = @fitcnb;

feature1 = descriptor.lbp;
[tr1, ts1] = test_classifier(feature1, labels, cv, classifier);

feature2 = descriptor.cedd;
[tr2, ts2] = test_classifier(feature2, labels, cv, classifier);

feature3 = descriptor.qhist;
[tr3, ts3, cutClassifier] = test_classifier(feature3, labels, cv, classifier);

feature4 = [descriptor.cedd, descriptor.lbp, descriptor.qhist];
[tr4, ts4] = test_classifier(feature4, labels, cv, classifier);

feature5 = descriptor.avg;
[tr5, ts5] = test_classifier(feature5, labels, cv, classifier);

feature6 = [descriptor.avg, descriptor.lbp];
[tr6, ts6] = test_classifier(feature6, labels, cv, classifier);

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

feature12 = [descriptor.avg, descriptor.lbp, descriptor.std];
[tr12, ts12, cutClassifier] = test_classifier(feature11, labels, cv, classifier);

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

disp("AVG, LBP");
disp("Training set");
disp(tr6);
disp("Test set");
disp(ts6);

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

%% Rocher type
rocher_1 = imread("../../images/cuts/IMG_50-15.png");
rocher_2 = imread("../../images/cuts/IMG_3-13.png");

rocher_1_hsv = rgb2hsv(rocher_1);
rocher_2_hsv = rgb2hsv(rocher_2);

figure(1);
subplot(2,2,1);imshow(rocher_2);title("Rocher tag")
subplot(2,2,2);imshow(rocher_1);title("Rocher no tag")
subplot(2,2,3);imhist(rocher_2_hsv(:,:,2));title("HSV_S")
subplot(2,2,4);imhist(rocher_1_hsv(:,:,2));title("HSV_S")