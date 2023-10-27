%load('./../corrected3/revised80002.mat');
%close all;
load('./../corrected3/revised90015.mat');
close all;



transparency = 0.1;
color = [70/255,130/255,180/255];

figure(1)
subplot(2,5,6)
plot(data.xdata,data.ydata(:,6),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(2,5,7)
plot(data.xdata,data.ydata(:,7),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(2,5,8)
plot(data.xdata,data.ydata(:,8),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(2,5,9)
plot(data.xdata,data.ydata(:,9),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(2,5,10)
plot(data.xdata,data.ydata(:,10),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');


subplot(2,5,1)
plot(data.xdata,data.ydata(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(2,5,2)
plot(data.xdata,data.ydata(:,2),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(2,5,3)
plot(data.xdata,data.ydata(:,3),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(2,5,4)
plot(data.xdata,data.ydata(:,4),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');
subplot(2,5,5)
plot(data.xdata,data.ydata(:,5),'o','MarkerEdgeColor','k','MarkerFaceColor',color);hold on;
set(gca, 'YScale', 'log');



    
  %%

for i = 100:10:2000
 pars_samples = update_pars(pars2,chain(i,:),mcmcpars);
 pars_samples.beta2 = pars_samples.beta;

[t3,S3,V3,~] = simulate_ode(model,pars_samples,tvec,pars2.S0,pars2.V0);
    figure(1)
    subplot(2,5,6)
    patchline(t3,V3(:,1),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;
  
    subplot(2,5,7)
    patchline(t3,V3(:,2),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    subplot(2,5,8)
    patchline(t3,V3(:,3),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    subplot(2,5,9)
    patchline(t3,V3(:,4),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    subplot(2,5,10)
    patchline(t3,V3(:,5),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    
    subplot(2,5,1)
    patchline(t3,S3(:,1),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;

    subplot(2,5,2)
    patchline(t3,S3(:,2),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;
    
    subplot(2,5,3)
    patchline(t3,S3(:,3),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;
    
    subplot(2,5,4)
    patchline(t3,S3(:,4),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;
    
    subplot(2,5,5)
    patchline(t3,S3(:,5),'edgecolor',[0 0 0],'linewidth',1,'edgealpha',transparency);hold on;


end

    