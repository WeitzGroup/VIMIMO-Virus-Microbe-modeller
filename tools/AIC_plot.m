clear all;
clc;



load('./figure4/SEIVD_datasheet.mat');

% approximately equal.
sigma_S = (S_max - S_min)./4;
sigma_V = (V_max - V_min)./4;


mu_S = (S_max + S_min)./2;
mu_V = (V_max + V_min)./2;

data_S = data.ydata(:,1:5);
data_V = data.ydata(:,6:10);

mu_S = mu_S(1:11:303,:);
mu_V = mu_V(1:11:303,:);
sigma_S = sigma_S(1:11:303,:);
sigma_V = sigma_V(1:11:303,:);

llf = sum(sum( (-(data_S - mu_S).^2./(2*sigma_S.^2))   + (-(data_V - mu_V).^2./(2*sigma_V.^2)))) + sum(sum(-log(1/sqrt(2*pi)./sigma_S)/log(10)) + sum(-log(1/sqrt(2*pi)./sigma_V)/log(10)))    ;
AIC(1) = 2*43 - 2*llf

load('./figure3/SEIV_datasheet.mat');



% approximately equal.
sigma_S = (S_max - S_min)./4;
sigma_V = (V_max - V_min)./4;


mu_S = (S_max + S_min)./2;
mu_V = (V_max + V_min)./2;

data_S = data.ydata(:,1:5);
data_V = data.ydata(:,6:10);

mu_S = mu_S(1:11:303,:);
mu_V = mu_V(1:11:303,:);
sigma_S = sigma_S(1:11:303,:);
sigma_V = sigma_V(1:11:303,:);

llf = sum(sum( (-(data_S - mu_S).^2./(2*sigma_S.^2))   + (-(data_V - mu_V).^2./(2*sigma_V.^2)))) + sum(sum(-log(1/sqrt(2*pi)./sigma_S)/log(10)) + sum(-log(1/sqrt(2*pi)./sigma_V)/log(10)))    ;
AIC(2) = 2*42 - 2*llf

%% plots

RMSE = [0.4363    0.5845];
figure(1)
subplot(1,3,1)
name = {'SEIVD';'SEIV'};
x= [1,2];
b = bar(x,RMSE,'FaceColor','flat');
b.CData(1,:) = [76,132,147]./255;
b.CData(2,:) = [217,76,33]./255;


set(gca,'XTickLabel',name);
ylabel('RMSE');
set(gca,'FontSize',20);


subplot(1,3,2)
b = bar(x,[43 42],'FaceColor','flat');ylim([40 45]);
set(gca,'XTickLabel',name);
ylabel('Number of parameters');
set(gca,'FontSize',20);
b.CData(1,:) = [76,132,147]./255;
b.CData(2,:) = [217,76,33]./255;

subplot(1,3,3)
b = bar(x,AIC,'FaceColor','flat');
set(gca,'XTickLabel',name);
ylabel('AIC');
ylim([1.56e6 1.575e6]);
b.CData(1,:) = [76,132,147]./255;
b.CData(2,:) = [217,76,33]./255;

set(gca,'FontSize',20);