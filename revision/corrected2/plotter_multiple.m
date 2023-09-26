load('./revised50020.mat');
close all;

transparency = 0.1;
color = [70/255,130/255,180/255];

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
    
  %%

for i = 1:50:1000
 pars_samples = update_pars(pars2,chain(i,:),mcmcpars);

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

    