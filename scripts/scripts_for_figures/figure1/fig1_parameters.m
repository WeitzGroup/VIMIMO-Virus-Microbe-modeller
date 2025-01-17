clear all;
clc;

x=1:8;




%% one-steps

% one steps conventional 
beta_onestep_conventional = [0.94,91.2,25.7,10.4,44.3,319,54.2,357];
tau_onestep_conventional = [1,1.25,1.5,1,0.833,1.5,0.667,1.167];
phi_onestep_conventional = [1.83e-7,1.88e-8,1.33e-7,9.9e-8,1.79e-7,7.6e-8,1.87e-7,1e-7];

%one step bayesian
beta_onestep = [1.81,118.2,60.5,8.246,99.2,437,93,413];
tau_onestep = [1.749,1.89,2.19,1.9,1.47,2.14,1.42,1.97];
phi_onestep = [5.14e-8,1.45e-8,9.57e-8,1.227e-7,1.56e-7, 6.46e-8,1.31e-7,8.02e-8 ];

beta_onestep_error = [2.02,68.8,50,21.9,43.8,79.5,50,86];
tau_onestep_error = [0.56,0.18,0.19,0.4,0.13,0.13,0.12,0.09] ;
phi_onestep_error = [1.92e-8,9.57e-9,1.39e-8,1.68e-8, 2.29e-8,1.75e-8,1.99e-8,1.7e-8];

r_onestep_conventional = [0.19,0.245,0.22,0.28,0.25];

boxes_onestep = [77,74,85,55,83,98,87,109];
boxes_onestep_error = [41,39,37,40,34,35,35,31];

%% figures -- one step

%color_def = [70/255,130/255,180/255];
%color_def = [70/255,210/255,130/255];

color_def2 = [0.9290 0.6940 0.1250];
color_def = [111,193,157]./255;


figure
subplot(2,3,1)
plot(x-0.1,beta_onestep_conventional,'^','MarkerSize',14,'MarkerFaceColor',color_def2,'Color',color_def2);
hold on;
errorbar(x+0.1,beta_onestep,beta_onestep_error,'bo','MarkerSize',14,'MarkerFaceColor',color_def,'Color',color_def);
title({'Burst size', '\beta (virions/cell)'});
ylim([1 600]);
set(gca,'FontSize',18);
xticks(1:8)
xticklabels([1,2,3,5,6,7,8,9]);
yticks(0:100:600);
ylim([-1 600])
xlim([0 9]);


subplot(2,3,2)
plot(x-0.1,tau_onestep_conventional,'^','MarkerSize',14,'MarkerFaceColor',color_def2,'Color',color_def2);
hold on;
errorbar(x+0.1,tau_onestep,tau_onestep_error,'bo','MarkerSize',14,'MarkerFaceColor',color_def,'Color',color_def);
title({'Latent period',' \tau (hr)'});
ylim([0.2 3]);
set(gca,'FontSize',18);
xticks(1:8);
xticklabels([1,2,3,5,6,7,8,9]);
xlim([0 9]);


subplot(2,3,3)
plot(x-0.1,phi_onestep_conventional,'^','MarkerSize',14,'MarkerFaceColor',color_def2,'Color',color_def2);
hold on;
errorbar(x+0.1,phi_onestep,phi_onestep_error,'bo','MarkerSize',14,'MarkerFaceColor',color_def,'Color',color_def);
title({'Adsorption rate','\phi (ml/hr)'})
ylim([1e-10 2.5e-7]);
set(gca,'FontSize',18);
xticks(1:8)
xticklabels([1,2,3,5,6,7,8,9]);
xlim([0 9]);
%legend('Conventional','Bayesian');
%legend('boxoff');



cv_mean_onestep  = 1./sqrt(boxes_onestep);
cv_onestep_error = 0.5* (boxes_onestep).^(-1.5).*boxes_onestep_error;
%cv_onestep_error  = 1./sqrt(boxes_onestep + boxes_onestep_error) - 1./sqrt(boxes_onestep + boxes_onestep_error)

subplot(2,3,4)
errorbar(x,cv_mean_onestep,cv_onestep_error,'ko','MarkerSize',14,'MarkerFaceColor',color_def,'Color',color_def);
title({'Coefficient of',' variation (CV)'});
set(gca,'FontSize',18);
xticks(1:8);
xticklabels([1,2,3,5,6,7,8,9]);
ylim([0 0.25])
%yticks(0:0.1:0.3);
xlim([0 9]);


subplot(2,3,5)
plot(1:5,r_onestep_conventional,'^','MarkerSize',14,'MarkerFaceColor',color_def2,'Color',color_def2);
title({'Growth rate','r (cells/hr)'});
ylim([0.15 0.3]);
set(gca,'FontSize',18);
xlim([0.5 5.5])
xticks(1:5);
xticklabels({'CBA 4','CBA 18','CBA 38','PSA H100','PSA 13-15'});
set(gca,'XTickLabelRotation',90);




