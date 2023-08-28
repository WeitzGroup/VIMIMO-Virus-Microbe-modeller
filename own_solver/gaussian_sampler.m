clear all;
clc;


%% add all files to path
addpath(genpath('./..'));



%% load file only beta
seed = 20017;
load('./../results/SEIVD-onlybeta-seed'+string(seed)+'.mat')
pars = pars2;
pars1 = pars2;

initial_error = error_from_pars(pars2,data,model);
tvec = 0:0.05:15.75; % for better viz

%initialization of gaussian priors.
r_sd = 0.02; %for 5 parameters
beta_sd = 50; % for 9 parameters
phi_sd = 0*1e-8; %for 9 parameters;
epsilon_sd = 0; %will not sample this.
tau_sd = 0.6; % will increase later -- after truncating.

figure(1)
subplot(1,5,1)
plot(data.xdata,data.ydata(:,6),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');
subplot(1,5,2)
plot(data.xdata,data.ydata(:,7),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');
subplot(1,5,3)
plot(data.xdata,data.ydata(:,8),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');
subplot(1,5,4)
plot(data.xdata,data.ydata(:,9),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');
subplot(1,5,5)
plot(data.xdata,data.ydata(:,10),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');

figure(2)
subplot(1,5,1)
plot(data.xdata,data.ydata(:,1),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');
subplot(1,5,2)
plot(data.xdata,data.ydata(:,2),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');
subplot(1,5,3)
plot(data.xdata,data.ydata(:,3),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');
subplot(1,5,4)
plot(data.xdata,data.ydata(:,4),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');
subplot(1,5,5)
plot(data.xdata,data.ydata(:,5),'ko','MarkerEdgeColor','k','MarkerFaceColor','k');hold on;
set(gca, 'YScale', 'log');



%samples
for i = 1:100
    i
    pars_samples = pars2; %initialization
    pars_samples.r = pars2.r + randn(5,1)*r_sd;
    pars_samples.beta = pars2.beta + randn(5,5)*beta_sd*pars.M;
    pars_samples.phi = pars2.phi + randn(5,5)*phi_sd*pars.M;
    pars_samples.epsilon = pars2.epsilon + randn(1,10)*epsilon_sd;
    [t3,S3,V3,~] = simulate_ode(model,pars_samples,tvec,pars2.S0,pars2.V0);
    figure(1)
    subplot(1,5,1)
    plot(t3,V3(:,1),'b'); hold on;
    subplot(1,5,2)
    plot(t3,V3(:,2),'b'); hold on;
    subplot(1,5,3)
    plot(t3,V3(:,3),'b'); hold on;
    subplot(1,5,4)
    plot(t3,V3(:,4),'b'); hold on;
    subplot(1,5,5)
    plot(t3,V3(:,5),'b'); hold on;

    figure(2)
    subplot(1,5,1)
    plot(t3,S3(:,1),'b'); hold on;
    subplot(1,5,2)
    plot(t3,S3(:,2),'b'); hold on;
    subplot(1,5,3)
    plot(t3,S3(:,3),'b'); hold on;
    subplot(1,5,4)
    plot(t3,S3(:,4),'b'); hold on;
    subplot(1,5,5)
    plot(t3,S3(:,5),'b'); hold on;
   
end

%% store the artificial posterior distribution


