function overlay_timeseries2(fig,t,S,V,colorid)
% plot additional timeseries on an existing figure created w/ plot_timeseries2()

if ~exist('colorid','var') || isempty(colorid)
    colorid = 4;
end

n = 5;

% hosts
for i = 1:n
    set(fig,'CurrentAxes',fig.Children(end+1-i));
    tmpy = ylim;
    set(gca,'ColorOrderIndex',colorid);
    hold on;
    semilogy(t,S(:,i))%,'HandleVisibility','off');
    ylim(tmpy);
    grid on;
end

% viruses
for i = 1:n
    set(fig,'CurrentAxes',fig.Children(end-n+1-i));
    tmpy = ylim;
    set(gca,'ColorOrderIndex',colorid);
    hold on;
    semilogy(t,V(:,i))%,'HandleVisibility','off');
    ylim(tmpy);
    grid on;
end

end