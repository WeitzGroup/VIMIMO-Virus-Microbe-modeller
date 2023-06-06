

load('chain_combined.mat');

grand_mean = (mean_chain_1 + mean_chain_2 )/2;

%chain_1 and chain_2 are the chains.

B = N/(M-1) * ((mean_chain_1 - grand_mean).^2 + (mean_chain_2 - grand_mean).^2) ;

v_1 = (std(chain_1)).^2 ;
v_2 = (std(chain_2)).^2 ;

W = (1/M) * (v_1 + v_2) ;



R =  ( (N-1)/N * W + (B/N) ) ./W;
R(24) = [];

%% plot bars


figure(1)
subplot(2,1,1)
b = bar(R,'FaceColor','flat');

for i = 1:5
b.CData(i,:) = [211,23,24]./255;
end

for i = 6:14
b.CData(i,:) = [15,104,82]./255;
end

for i = 15:23
b.CData(i,:) = [211,119,46]./255;
end

for i=24:32
b.CData(i,:) = [62,137,168]./255;
end



b.CData(33,:) = [217,76,33]./255;
set(gca,'XTickLabel','');
hold on;
line([0.2, 35.8], [1.1, 1.1], 'Color', [0.1,0.1,0.1],'LineStyle','--',LineWidth=2);
set(gca,'FontSize',20);
xlim([0 35])
ylabel('R_{GR}')
ylim([0 1.2])
yticks([0 0.5 1 1.1]);
%% geweke
store = chainstats(chain_1);
R_geweke = store(:,5);
R_geweke(24) = [];

subplot(2,1,2)
b = bar(R_geweke,'FaceColor','flat');

for i = 1:5
b.CData(i,:) = [211,23,24]./255;
end

for i = 6:14
b.CData(i,:) = [15,104,82]./255;
end

for i = 15:23
b.CData(i,:) = [211,119,46]./255;
end

for i=24:32
b.CData(i,:) = [62,137,168]./255;
end



b.CData(33,:) = [217,76,33]./255;
set(gca,'XTickLabel','');
hold on;
line([0.2, 38], [0.9, 0.9],'Color', [0.1,0.1,0.1],'LineStyle','--',LineWidth=2  );
set(gca,'FontSize',20);
xlim([0 35])
ylabel('R_{geweke}')
yticks([0 0.2 0.4 0.6 0.8 0.9 1]);


set(gca, 'XTick', [3 10 19 28 33]);
set(gca, 'XTickLabel', {'r_i' '\beta_{ij} ' '\phi_{ij}' '\tau_{ij}' 'D_c'});



