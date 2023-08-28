clear all;
clc;


load("chain_combined.mat");
%% for beta

fig1 = figure;

transient_id = 5000;
 

color1 = [76,132,147]./255;
color2 = [217,76,33]./255;

for i = 1:9

subplot(5,2,i)
plot(chain_1(transient_id:end,5+i),'Color',color1 );
xlim([0 5000])
hold on;

end


for i = 1:9

subplot(5,2,i)
plot(chain_2(transient_id:end,5+i),'Color',color2);
ylim([  min(min(chain_1(transient_id:end,5+i)),min(chain_2(transient_id:end,5+i)))-0.1,  max(max(chain_1(transient_id:end,5+i)),max(chain_2(transient_id:end,5+i)))+0.1 ]);
xlim([0 5000])
make_title(i);

end

han=axes(fig1,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'\beta (virions/cell)');
xlabel(han,'steps');
%title(han,'yourTitle');
set(gca,'FontSize',18)
%% for r



fig2 = figure;

 
for i = 1:5

subplot(3,2,i)
plot(chain_1(transient_id:end,i), 'Color',color1 );
xlim([0 5000])
hold on;

end


for i = 1:5

subplot(3,2,i)
plot(chain_2(transient_id:end,i),'Color',color2);
ylim([  min(min(chain_1(transient_id:end,i)),min(chain_2(transient_id:end,i))),  max(max(chain_1(transient_id:end,i)),max(chain_2(transient_id:end,i))) ]);
xlim([0 5000])
make_title_host(i);

end

han=axes(fig2,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'r (cells/hr)');
xlabel(han,'steps');
%title(han,'yourTitle');
set(gca,'FontSize',18)

%% for phi

fig3 = figure;


for i = 1:9
subplot(5,2,i)
plot(chain_1(transient_id:end,14+i), 'Color',color1 );
xlim([0 5000])
hold on;
end



for i = 1:9
subplot(5,2,i)
plot(chain_2(transient_id:end,14+i),'Color',color2);
ylim([  min(min(chain_1(transient_id:end,14+i)),min(chain_2(transient_id:end,14+i)))-0.1,  max(max(chain_1(transient_id:end,14+i)),max(chain_2(transient_id:end,14+i)))+0.1 ]);
xlim([0 5000])
make_title(i);
end

han=axes(fig3,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'log_{10} \phi (ml/hr) ');
xlabel(han,'steps');
%title(han,'yourTitle');
set(gca,'FontSize',18)


%% for tau


fig4 = figure;

for i = 1:9

subplot(5,2,i)
plot(chain_1(transient_id:end,24+i),'Color',color1);
xlim([0 5000])
hold on;

end



for i = 1:9

subplot(5,2,i)
plot(chain_2(transient_id:end,24+i),'Color',color2);
ylim([  min(min(chain_1(transient_id:end,24+i)),min(chain_2(transient_id:end,24+i)) -0.1) ,  max(max(chain_1(transient_id:end,24+i)),max(chain_2(transient_id:end,24+i)) +0.1)]);

xlim([0 5000])
make_title(i);
end


han=axes(fig4,'visible','off'); 
%han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'\tau (hr) ');
xlabel(han,'steps');
%title(han,'yourTitle');
set(gca,'FontSize',18)