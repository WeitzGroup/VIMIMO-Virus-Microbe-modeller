function overlay_timeseries2_envelope(fig,tsenv)
% plot additional timeseries on an existing figure created w/ plot_timeseries2()

n = 5;

% hosts
for i = 1:n
    set(fig,'CurrentAxes',fig.Children(end+1-i));
    tmpy = ylim;
    set(gca,'ColorOrderIndex',4);
    hold on;
    tmpx = [tsenv.t; flip(tsenv.t)];
    tmpy2 = [tsenv.Smin(:,i); flip(tsenv.Smax(:,i))];
    tmph = fill(tmpx,tmpy2,[1 1 1]*.85,'EdgeColor','none','HandleVisibility','off');
    uistack(tmph,'bottom');
    ylim(tmpy);
end

% viruses
for i = 1:n
    set(fig,'CurrentAxes',fig.Children(end-n+1-i));
    tmpy = ylim;
    set(gca,'ColorOrderIndex',4);
    hold on;
    tmpx = [tsenv.t; flip(tsenv.t)];
    tmpy2 = [tsenv.Vmin(:,i); flip(tsenv.Vmax(:,i))];
    tmph = fill(tmpx,tmpy2,[1 1 1]*.85,'EdgeColor','none','HandleVisibility','off');
    uistack(tmph,'bottom');
    ylim(tmpy);
end

end