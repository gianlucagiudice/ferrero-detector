clear all;
close all;

load('data2.mat');

[lbp_tr, lbp_ts] = eval_cart(training.lbp,training.labels,test.lbp,test.labels);

[ghist_tr, ghist_ts] = eval_cart(training.ghist,training.labels,test.ghist,test.labels);

[glcm_tr, glcm_ts] = eval_cart(training.glcm,training.labels,test.glcm,test.labels);

[lbpglcm_tr, lbpglcm_ts] =  eval_cart([training.lbp,training.glcm],training.labels,[test.lbp,test.glcm],test.labels);

[lbpghist_tr, lbpghist_ts] =  eval_cart([training.lbp,training.ghist],training.labels,[test.lbp,test.ghist],test.labels);

[ghistglcm_tr, ghistglcm_ts] =  eval_cart([training.ghist,training.glcm],training.labels,[test.ghist,test.glcm],test.labels);

[ghistglcmlbp_tr, ghistglcmlbp_ts] =  eval_cart([training.ghist,training.glcm,training.lbp],training.labels,[test.ghist,test.glcm,test.lbp],test.labels);

xlabels = {'ghist','lbp','glcm','lbp+glcm','lbp+ghist','ghist+glcm','ghist+glcm+lbp'};

tr = [ghist_tr, lbp_tr, glcm_tr, lbpglcm_tr, lbpghist_tr, ghistglcm_tr, ghistglcmlbp_tr];

ts = [ghist_ts, lbp_ts, glcm_ts, lbpglcm_ts, lbpghist_ts, ghistglcm_ts, ghistglcmlbp_ts];

figure, bar([tr' ts']);
legend({'training','test'},'location','eastoutside');
set(gca,'XTick',1:numel(xlabels),'XTickLabel',xlabels);


