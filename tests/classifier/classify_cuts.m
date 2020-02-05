clear all;

%% Load descriptors and label
load('data');

%% Get labels
labels = data.labels;
descriptor = data.descriptor;

%% Portion of taining-set test-set
testPortion = 0.2;
cv = cvpartition(labels, 'holdout', testPortion);


feature = descriptor.lbp;
[tr1, ts1] = test_classifier(feature, labels, cv)

feature = descriptor.cedd;
[tr2, ts2] = test_classifier(feature, labels, cv)

feature = descriptor.qhist;
[tr3, ts3] = test_classifier(feature, labels, cv)

feature = [data.descriptor.cedd data.descriptor.lbp data.descriptor.qhist];
[tr4, ts4] = test_classifier( feature, labels, cv)

feature = descriptor.avg;
[tr5, ts5] = test_classifier( feature, labels, cv)


