clear all;
clc;

% read here
% https://bookdown.org/rdpeng/advstatcomp/monitoring-convergence.html

%% load data
%load('./../results/local/SEIV10_00002_Dbeprt_1001/seed106L0_datasheet.mat');

addpath("/Users/rdey33/Downloads/VIMIMO/mcmcstat/mcmcstat");
addpath("/Users/rdey33/Downloads/VIMIMO/src");
load('./../results/local/SEIV70_00000_Dbeprt_1001/seed341L0_datasheet.mat');

%chain_1 = randn(1,2000);
transient_id = 1;
chain_1 = [chain(transient_id:end,1:23) chain(transient_id:end,33:43)];
mean_chain_1 = mean(chain_1);

N = mcmcoptions.nsimu - transient_id + 1 ;
M = 3;

%load('./../results/local/SEIV10_00002_Dbeprt_1001/seed107L0_datasheet.mat');
load('./../results/local/SEIV70_00000_Dbeprt_1001/seed340L0_datasheet.mat');

transient_id = 1;
%chain_2 = randn(1,2000)+0.1;
chain_2 = [chain(transient_id:end,1:23) chain(transient_id:end,33:43)];
mean_chain_2 = mean(chain_2);


load('./../results/local/SEIV70_00000_Dbeprt_1001/seed339L0_datasheet.mat')

transient_id = 1;
%chain_2 = randn(1,2000)+0.1;
chain_3 = [chain(transient_id:end,1:23) chain(transient_id:end,33:43)];
mean_chain_3 = mean(chain_3);


grand_mean = (mean_chain_1 + mean_chain_2 + mean_chain_3)/M;

%chain_1 and chain_2 are the chains.

B = N/(M-1) * ((mean_chain_1 - grand_mean).^2 + (mean_chain_2 - grand_mean).^2 +  (mean_chain_3 - grand_mean).^2) ;

v_1 = (std(chain_1)).^2 ;
v_2 = (std(chain_2)).^2 ;
v_3 = (std(chain_3)).^2 ;

W = (1/M) * (v_1 + v_2 + v_3) ;



R =  ( (N-1)/N * W + (B/N) ) ./W;

%% plot bars


figure(1)
subplot(2,1,1)
b = bar(R,'FaceColor','flat');

for i = 1:5
b.CData(i,:) = [0 0.8 0];
end

for i = 6:14
b.CData(i,:) = [0 0 0.8];
end

for i = 15:23
b.CData(i,:) = [0.8 0 0];
end

for i=24:33
b.CData(i,:) = [0.7 0.7 0];
end



b.CData(34,:) = [0 0.2 0.2];
set(gca,'XTickLabel','');
hold on;
line([0.2, 35.8], [1.1, 1.1], 'Color', [0.1,0.1,0.1],'LineStyle','--',LineWidth=2);
set(gca,'FontSize',20);
xlim([0 35])
ylabel('R_{GR}')

%% geweke
store = chainstats(chain_1);
R_geweke = store(:,5);

subplot(2,1,2)
b = bar(R_geweke,'FaceColor','flat');

for i = 1:5
b.CData(i,:) = [0 0.8 0];
end

for i = 6:14
b.CData(i,:) = [0 0 0.8];
end

for i = 15:23
b.CData(i,:) = [0.8 0 0];
end

for i=24:33
b.CData(i,:) = [0.7 0.7 0];
end



b.CData(34,:) = [0 0.2 0.2];
set(gca,'XTickLabel','');
hold on;
line([0.2, 38], [0.9, 0.9],'Color', [0.1,0.1,0.1],'LineStyle','--',LineWidth=2  );
set(gca,'FontSize',20);
xlim([0 35])
ylabel('R_{geweke}')


