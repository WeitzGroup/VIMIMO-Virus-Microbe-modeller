function overlay_timeseries(fig,t,S,V)
% plot additional timeseries on an existing figure created w/ plot_timeseries()

% hosts
set(fig,'CurrentAxes',fig.Children(4));
tmpy = ylim;
set(gca,'ColorOrderIndex',1);
hold on;
semilogy(t,S,'--','HandleVisibility','off');
ylim(tmpy);

% viruses
set(fig,'CurrentAxes',fig.Children(2));
tmpy = ylim;
set(gca,'ColorOrderIndex',1);
hold on;
semilogy(t,V,'--','HandleVisibility','off');
ylim(tmpy);

end