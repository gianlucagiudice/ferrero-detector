load('lbp');
load('cedd');
load('qhist');
load('cnn');

[images, labels]= readlists();

cv = cvpartition(labels,'Holdout',0.2);

[tr1, ts1] = test_classifier(lbp,labels,cv)

[tr2, ts2] = test_classifier(cedd,labels,cv)

[tr3, ts3] = test_classifier(qhist,labels,cv)

[tr4, ts4] = test_classifier([cedd lbp qhist],labels,cv)


%[tr, ts] = test_classifier(cnn,labels,cv)
