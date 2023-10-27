clear all;
clc;


%% add all files to path
addpath(genpath('./..'));



%% load file only beta
seed = 20017;
load('./../corrected2/revised50040.mat')
pars = pars2;
pars1 = pars2;

initial_error = error_from_pars(pars2,data,model);
tvec = 0:0.05:15.75; % for better viz

%initialization of gaussian priors.
r_sd = 0.00; %for 5 parameters
beta_sd = 20; % for 9 parameters
phi_sd = 1*1e-10; %for 9 parameters;
epsilon_sd = 0; %will not sample this.
tau_sd = 0.6; % will increase later -- after truncating.

transparency = 0.1;
color = [70/255,130/255,180/255];
num_samples = 1000;

%% figures

figure(1)
subplot(1,5,1)
plot(data.xdata,data.ydata(:,6),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,2)
plot(data.xdata,data.ydata(:,7),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,3)
plot(data.xdata,data.ydata(:,8),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,4)
plot(data.xdata,data.ydata(:,9),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,5)
plot(data.xdata,data.ydata(:,10),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');

figure(2)
subplot(1,5,1)
plot(data.xdata,data.ydata(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,2)
plot(data.xdata,data.ydata(:,2),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,3)
plot(data.xdata,data.ydata(:,3),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,4)
plot(data.xdata,data.ydata(:,4),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,5)
plot(data.xdata,data.ydata(:,5),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');



%samples
for i = 1:num_samples
    i
    
    pars_samples = pars2; %initialization
    
    pars_samples.beta = pars2.beta + randn(5,5).*beta_sd.*pars.M;
    theta(i,1:9) = (pars_samples.beta(pars_samples.beta~=0))';

    pars_samples.phi = pars2.phi + randn(5,5).*phi_sd.*pars.M;
    theta(i,10:18) = (pars_samples.phi(pars_samples.phi>0))';

    
    pars_samples.tau = pars2.tau + randn(5,5).*tau_sd.*pars.M;
    theta(i,19:27) = (pars_samples.tau(pars_samples.tau~=0))';

    [t3,S3,V3,~] = simulate_ode(model,pars_samples,tvec,pars2.S0,pars2.V0);
    figure(1)
    subplot(1,5,1)
    patchline(t3,V3(:,1),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;
  
    subplot(1,5,2)
    patchline(t3,V3(:,2),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    subplot(1,5,3)
    patchline(t3,V3(:,3),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    subplot(1,5,4)
    patchline(t3,V3(:,4),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    subplot(1,5,5)
    patchline(t3,V3(:,5),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    figure(2)
    subplot(1,5,1)
    patchline(t3,S3(:,1),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    subplot(1,5,2)
    patchline(t3,S3(:,2),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;
    
    subplot(1,5,3)
    patchline(t3,S3(:,3),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;
    
    subplot(1,5,4)
    patchline(t3,S3(:,4),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;
    
    subplot(1,5,5)
    patchline(t3,S3(:,5),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

end



figure(1)
subplot(1,5,1)
plot(data.xdata,data.ydata(:,6),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,2)
plot(data.xdata,data.ydata(:,7),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,3)
plot(data.xdata,data.ydata(:,8),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,4)
plot(data.xdata,data.ydata(:,9),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,5)
plot(data.xdata,data.ydata(:,10),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
saveas(gcf,'virus-v4.png')

figure(2)
subplot(1,5,1)
plot(data.xdata,data.ydata(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,2)
plot(data.xdata,data.ydata(:,2),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,3)
plot(data.xdata,data.ydata(:,3),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,4)
plot(data.xdata,data.ydata(:,4),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(1,5,5)
plot(data.xdata,data.ydata(:,5),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');

saveas(gcf,'host-v4.png')



