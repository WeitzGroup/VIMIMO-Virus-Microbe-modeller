clc;
clear all;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
addpath('./simulator/');

name = "HP1_13-15";
load(name+'.mat');
[indi_i,indi_j]= name_matrix_function(name);
time_free_phages = time_free_phages/60;

load('parameters.mat','pars');

%% plotting

% figure(1)
% semilogy(time_free_phages,free_phages,'-o');
% xlabel(string(cell2mat(labels.variables(1,1)))+' ('+string(cell2mat(labels.units(1,1)))+')','interpreter','none');
% ylabel(string(cell2mat(labels.variables(1,3)))+' ('+string(cell2mat(labels.units(1,3)))+')','interpreter','none');
% title(string(labels.phage)+'-'+string(labels.host))


%% collecting statistics

free_phages_mean = mean(free_phages,2);


seed = 1;
filestr = "one_step_results/"+name+"/local/seed"+string(seed);

data.ydata = free_phages_mean;
data.xdata = time_free_phages;

%% functions inclusion
NE =80; %number of exposed class

moi_mean = 0.1;

S0 = 1e8;
V0 = S0*moi_mean;

y(1,1) = S0;
y(1,2:NE+1) = 0;
y(1,NE+2) = 0 ;
y(1,NE+3) = V0;

%trial


% theta given by OSU lab
beta_osu = prior_values.burst_size;
r_osu = pars.r(indi_i);
phi_osu = pars.phi(indi_i,indi_j);
tau_osu = prior_values.latent_period/60;

theta_osu = [r_osu,phi_osu,tau_osu,beta_osu];
theta_raunak = [0.2,13e-8,85/60,194];

dilution_factor = 100;
%[time,y_series] = one_step_simulate(time_free_phages,y,theta_osu,NE, dilution_factor);
[time2,y_series2,time_abs,pre_dil] = one_step_simulate(time_free_phages,y,theta_raunak,NE, dilution_factor);


% figure(1)
% semilogy(time_free_phages,free_phages,'-o');
% xlabel(string(cell2mat(labels.variables(1,1)))+' ('+string(cell2mat(labels.units(1,1)))+')','interpreter','none');
% ylabel(string(cell2mat(labels.variables(1,3)))+' ('+string(cell2mat(labels.units(1,3)))+')','interpreter','none');
% title(string(labels.phage)+'-'+string(labels.host)+' using OSU parameters');
% hold on;
% semilogy(time,y_series(end,:),'-k');

figure(2)
semilogy(time_free_phages,free_phages,'-o');
xlabel(string(cell2mat(labels.variables(1,1)))+' ('+string(cell2mat(labels.units(1,1)))+')','interpreter','none');
ylabel(string(cell2mat(labels.variables(1,3)))+' ('+string(cell2mat(labels.units(1,3)))+')','interpreter','none');
title(string(labels.phage)+'-'+string(labels.host)+' using Raunak parameters');
hold on;
semilogy(time2,y_series2(end,:),'-k');




