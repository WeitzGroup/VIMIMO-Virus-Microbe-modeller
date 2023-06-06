clear all;
clc;


str1 = './../results/local/SEIV70_00000_Dbeprt_1001/seed339L0_datasheet.mat';
str2 = './../results/local/SEIV70_00000_Dbeprt_1001/seed341L0_datasheet.mat';

%% for beta

fig1 = figure;
load(str1);
chain1 = chain;
load(str2);
chain2= chain;
transient_id = 5000;
 
for i = 1:9

subplot(5,2,i)
plot(chain1(transient_id:end,5+i));
xlim([0 5000])
hold on;

end


for i = 1:9

subplot(5,2,i)
plot(chain2(transient_id:end,5+i),'r');
ylim([  min(min(chain1(transient_id:end,5+i)),min(chain2(transient_id:end,5+i))),  max(max(chain1(transient_id:end,5+i)),max(chain2(transient_id:end,5+i))) ]);
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
plot(chain1(transient_id:end,i));
xlim([0 5000])
hold on;

end


for i = 1:5

subplot(3,2,i)
plot(chain2(transient_id:end,i),'r');
ylim([  min(min(chain1(transient_id:end,i)),min(chain2(transient_id:end,i))),  max(max(chain1(transient_id:end,i)),max(chain2(transient_id:end,i))) ]);
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
plot(chain1(transient_id:end,14+i));
xlim([0 5000])
hold on;
end



for i = 1:9
subplot(5,2,i)
plot(chain2(transient_id:end,14+i),'r');
ylim([  min(min(chain1(transient_id:end,14+i)),min(chain2(transient_id:end,14+i))),  max(max(chain1(transient_id:end,14+i)),max(chain2(transient_id:end,14+i))) ]);
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
plot(chain1(transient_id:end,34+i));
xlim([0 5000])
hold on;

end



for i = 1:9

subplot(5,2,i)
plot(chain2(transient_id:end,34+i),'r');
ylim([  min(min(chain1(transient_id:end,34+i)),min(chain2(transient_id:end,34+i))),  max(max(chain1(transient_id:end,34+i)),max(chain2(transient_id:end,34+i))) ]);

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