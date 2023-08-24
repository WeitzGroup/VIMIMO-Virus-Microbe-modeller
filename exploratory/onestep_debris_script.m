clc;
clear all;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
addpath(genpath('./..'))
addpath('./simulator/');

name = "HP1_13-15";
load(name+'.mat');
[indi_i,indi_j]= name_matrix_function(name);
time_free_phages = time_free_phages/60;

load('./../results/results_same_phi/HP1_13-15_3-inferred.mat')

%% simulate again

y(1,1) = S0;
y(1,2:NE+1) = 0;
y(1,NE+2) = 0 ;
y(1,NE+3) = V0;
y(1,NE+4) = 0;
theta = median(chain_effective);
theta(5) = 6e6;

dilution_factor = 1;
%long_time = 0:0.1:5;
long_time = time_free_phages;
[time_debris,y_series_debris,~,~] = onestep_simulate_debris(long_time,y,theta,NE,dilution_factor);

%% plotting
 fig2 = figure();
 semilogy(time_free_phages,free_phages_mean,'ko',MarkerSize=8,MarkerEdgeColor='auto',MarkerFaceColor='k');
 hold on;
 semilogy(time,y_series_inferred(end,:),'-b',LineWidth=2)
 semilogy(time_debris,y_series_debris(end-1,:),'-r',LineWidth=2);
 legend('data','without debris','with debris');
 xlabel('Time (hr)');
 ylabel('Virion density (PFU/ml)');
 fontsize(fig2, 24, "points");



 fig3 = figure();
 semilogy(time,sum(y_series_inferred(1:end-1,:)),'-b',LineWidth=2);
 hold on;
 semilogy(time_debris,sum(y_series_debris(1:end-2,:)),'-r',LineWidth=2);
 legend('without debris','with debris');
 xlabel('Time (hr)');
 ylabel('Host cell density (/ml)');
 fontsize(fig3, 24, "points");
 
 prob_inhibition = 1 - 1./(1+(y_series_debris(end,end)/theta(5)).^2);