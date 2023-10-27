clc;
clear all;

addpath(genpath('./../..'))
load('./../combined_posteriors.mat');

load('./../../data/triplicate_data.mat');
linewidth = 2;

color_ofthe_fit = [1 0 0]*0.5;
color_ofthe_fit = [0 0 0];
color_ofthe_fill = [0.95 0 0];
transparency = 0.25;
tvec = 0:0.01:15.75; % for better viz
%% new parameters

pars2 = update_pars(pars1,pars_from_dist(chain_stored4(5001:end,:)),mcmcpars);
pars2.epsilon = ones(1,10);
pars2.prob = [0 0 0 0 0]';

   pars2.phi = 1.0e-07 *[         0    0.6000         0         0      0;
                             0.18    0.8000    0.2       0         0;
                                  0         0    0.6        0         0;
                                  0         0         0    0.7   0.1285;
                                  0         0         0    0.6   0.22];


pars2.tau =[0 3 0 0 0;
            1.7 2.7 2.3 0 0;
            0 0 2 0 0 ;
            0 0 0 1.8 4.7;
            0 0 0 2.3 2];
pars2.eta(pars2.tau>0) = 1./pars2.tau(pars2.tau>0);
pars2.eta

% r
pars2.r = [0.18,0.25,0.3,0.68,0.52]' ;


% beta

pars2.beta = [0  1.7231         0         0         0;
  200.7512  205.9496  100.1492         0         0;
         0         0   20.7017         0         0;
         0         0         0  522.0549  60.2599;
         0         0         0  485.1209  50.9918];



pars2.Dc = 5e6;
pars2.Dc2 = 6.13e6;
pars2.Dc3 =16e6;
pars2.Dc4 = 17.3e5;
pars2.Dc5 = 15.5e5;



% NE


pars2.NE = 100*pars2.M;


%%% new
% pars2.beta =                 [0   27.2507         0         0         0;
%   282.8029  196.0969  156.9419         0         0;
%          0         0   22.0430         0         0;
%          0         0         0  445.5575   68.7232;
%          0         0         0  584.7767   44.4537 ];
% 
% pars2.phi =   1.0e-06 *         [0    0.0815         0         0         0;
%     0.0201    0.0604    0.0362         0         0;
%          0         0    0.1104         0         0;
%          0         0         0    0.0483    0.0145;
%          0         0         0    0.0410    0.0218];
% 
% pars2.tau =        [0    4.7147         0         0         0;
%     3.6006    2.3868    5.1770         0         0;
%          0         0    3.3339         0         0;
%          0         0         0    2.5556    5.8830;
%          0         0         0    1.9522    2.2263];


% pars2.Dc = 1.8286e+06;
% pars2.Dc2 = 1.1698e+07;
% pars2.Dc3=4.4286e+06;
% pars2.Dc4=2.7893e+07;
% pars2.Dc5=8.6961e+06;




max_NE = round(max(max(pars2.NE)));
model = SEIVD_diff_NE_diff_debris_abs(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;
model.debris_inhib2 = 2;
model.debris_inhib3 = 2;
model.debris_inhib4 = 2;
model.debris_inhib5 = 2;

model.diff_beta = 0;


%        200.36
%        2.8754
%         206.1
%        99.669
%        19.982
%        521.92
%        484.63
%        60.601
%         51.42
%       -7.9521
%       -7.1768
%       -7.2758
%       -7.6932
%       -7.0759
%       -7.2621
%       -7.2215
%       -7.8834
%         -7.61
%        1.7021
%        2.9896
%        2.7028
%        2.2918
%        1.9965
%        1.7983
%        2.2942
%         4.707
%        2.0063
%       0.16085
%      0.082377
%       0.31452
%        0.5556
%       0.52857
%        6.7245
%        6.7598
%        7.0603
%        6.2622
%        6.1883


%  Iteration  Func-count       f(x)        Step-size       optimality
%      0          38          181.713                           188
%      1         152          179.412    5.31319e-05            302  
%      2         190           176.31              1            213  
%      3         228           158.21              1            171  
%      4         266          156.503              1            179  
%      5         304          154.118              1            164  
%      6         342          150.734              1            147  
%      7         380          148.066              1            144  
%      8         418          146.508              1            104  
%      9         456          145.155              1            120  
%     10         494          143.441              1            145  
%     11         532           141.24              1            177  


model.name = 'SEIVD-diffabs';

[t2,S_median,V_median,D_median,I_median,E_median] =  simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set
figure(1)
subplot(2,2,1)
plot(t2,sum(I_median,2)) %-- time series of sum of all infected cells.
ylabel('Infected cells (all hosts)');

subplot(2,2,2)
plot(t2,sum(I_median,2)+sum(E_median,2) + sum(S_median,2) )
ylabel('All hosts')

subplot(2,2,3)
plot(t2,D_median);
ylabel('Num dead cells (All hosts)')

error_from_pars(pars2,data,model)
%%

hf4 = figure;
subplot(2,5,1)
errorbar(time/60,mean(1e3*host1'),std(1e3*host1'),'o','MarkerSize',4,'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
    xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e5 1e6 1e7 1e8]);
ylabel({'Host density';'(cells/ml)'});
title('CBA 4','FontSize',18);
    plot(t2,S_median(:,1),'-','Color',color_ofthe_fit,'LineWidth',linewidth);




subplot(2,5,2)
errorbar(time/60,mean(1e3*host2'),std(1e3*host2'),'o','MarkerSize',4,  'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255] );hold on;
set(gca, 'YScale', 'log');
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
   xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e5 1e6 1e7 1e8]);
    title('CBA 18','FontSize',18);
   
    plot(t2,S_median(:,2),'-','Color',color_ofthe_fit,'LineWidth',linewidth);




subplot(2,5,3)
errorbar(time/60,mean(1e3*host3'),std(1e3*host3'),'o','MarkerSize',4, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
    xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e5 1e6 1e7 1e8]);
title('CBA 38','FontSize',18);

    plot(t2,S_median(:,3),'-','Color',color_ofthe_fit,'LineWidth',linewidth);



subplot(2,5,4)
errorbar(time/60,mean(1e3*host4'),std(1e3*host4'),'o','MarkerSize',4, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'FontSize',20)
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
  xticks([0 2 4 6 8 10 12 14 16]);
  axis('square');
    yticks([1e5 1e6 1e7 1e8]);
    title('PSA H100','FontSize',18);
    
    plot(t2,S_median(:,4),'-','Color',color_ofthe_fit,'LineWidth',linewidth);




subplot(2,5,5)
errorbar(time/60,mean(1e3*host5'),std(1e3*host5'),'o','MarkerSize',4, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'FontSize',20);
set(gca,'fontname','times')  % Set it to times
ylim([1e5 1e8]);
    xlim([0 16]);
    xticks([0 2 4 6 8 10 12 14 16]);
    axis('square');
    yticks([1e5 1e6 1e7 1e8]);
    title('PSA 13-15','FontSize',18);
    
    plot(t2,S_median(:,5),'-','Color',color_ofthe_fit,'LineWidth',linewidth);

%xlabel("Time (hours)");
%ylabel("Host density (cell/ml)");






subplot(2,5,6)
errorbar(time/60,mean(1e3*virus1'),std(1e3*virus1'),'o','MarkerSize',4,'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
   xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e4 1e6 1e8 1e10]);
ylabel({'Phage density';'(virions/ml)'});
title('\phi18:2','FontSize',18);
    
    plot(t2,V_median(:,1),'-','Color',color_ofthe_fit,'LineWidth',linewidth);

subplot(2,5,7)
errorbar(time/60,mean(1e3*virus2'),std(1e3*virus2'),'o','MarkerSize',4,  'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255] );hold on;
set(gca, 'YScale', 'log');
set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
  xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
    yticks([1e4 1e6 1e8 1e10]);
    title('\phi18:3','FontSize',18);
    
    plot(t2,V_median(:,2),'-','Color',color_ofthe_fit,'LineWidth',linewidth);




subplot(2,5,8)
errorbar(time/60,mean(1e3*virus3'),std(1e3*virus3'),'o','MarkerSize',4, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
  xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
   yticks([1e4 1e6 1e8 1e10]);
   title('\phi38:1','FontSize',18);
    
    plot(t2,V_median(:,3),'-','Color',color_ofthe_fit,'LineWidth',linewidth);

subplot(2,5,9)
errorbar(time/60,mean(1e3*virus4'),std(1e3*virus4'),'o','MarkerSize',4, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
   xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
   yticks([1e4 1e6 1e8 1e10]);
   title('PSA HP1','FontSize',18);
    
    plot(t2,V_median(:,4),'-','Color',color_ofthe_fit,'LineWidth',linewidth);




subplot(2,5,10)
errorbar(time/60,mean(1e3*virus5'),std(1e3*virus5'),'o','MarkerSize',4, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
ylim([1e4 1e11]);
    xlim([0 16]);
 xticks([0 2 4 6 8 10 12 14 16]);
    set(gca,'FontSize',20);
    axis('square');
  yticks([1e4 1e6 1e8 1e10]);
  title('PSA HS6','FontSize',18);
    
    plot(t2,V_median(:,5),'-','Color',color_ofthe_fit,'LineWidth',linewidth);
    %legend('Data','95% confidence interval','Bayesian fit');
    %legend('Box','off');

han=axes(hf4,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
set(gca,'FontSize',20);
set(gca,'fontname','times')  % Set it to times
xlabel("Time (hours)");

