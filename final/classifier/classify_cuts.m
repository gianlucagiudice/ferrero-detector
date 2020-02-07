clear all;

%% Load descriptors and label
load('../../data/cuts');

%% Get labels
labels = cuts.labels;
descriptor = cuts.descriptors;

%% Portion of taining-set test-set
testPortion = 0.3;
cv = cvpartition(labels, 'holdout', testPortion);

classifier = @fitcknn;
%classifier = @fitctree;
%classifier = @fitcnb;

feature = descriptor.lbp;
[tr1, ts1] = test_classifier(feature, labels, cv, classifier)

feature = descriptor.cedd;
[tr2, ts2] = test_classifier(feature, labels, cv, classifier)

feature = descriptor.qhist;
[tr3, ts3] = test_classifier(feature, labels, cv, classifier)

feature = [cuts.descriptors.cedd cuts.descriptors.lbp cuts.descriptors.qhist];
[tr4, ts4, c] = test_classifier(feature, labels, cv, classifier)

feature = descriptor.avg;
[tr5, ts5] = test_classifier(feature, labels, cv, classifier)


