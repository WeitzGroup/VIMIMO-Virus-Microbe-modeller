function fig = plot_timeseries2_gradations(t,S,V,tcell,Scell,Vcell,parvec)
% plot simulated timeseries on top of qpcr data, each channel separately
% tcell, Scell, and Vcell are simulations of modified parameter sets
% use area() to show gradations, instead of lines -> easier to see

load('data/qpcr','data');
fig = figure;
fig.Position(3:4) = fig.Position(3:4).*[2.5 1];
fig.Position(1) = fig.Position(1)-fig.Position(3)*.1;

n = 5;
K = length(tcell);
tmpS = [Scell{:}];
tmpV = [Vcell{:}];
grab_type = @(j) (0:K-1)*n+j;

cmap = flip(colormap('parula'));
cmapid = (0:K-1)*floor((length(cmap)-1)/(K-1))+1;

% hosts
for i = 1:n
    subplot(2,n,i);
    
    % qpcr
    tmph1 = semilogy(data.xdata,data.ydata(:,data.id.S(i)),'.','Color',.3*[1 1 1],'MarkerSize',7);
    hold on;
    
    % baseline
    tmph2 = semilogy(t,S(:,i),'Color','k','LineWidth',2);
    
    % gradations
    tmpy = [S(:,i) tmpS(:,grab_type(i))];
    tmpy = diff(tmpy,1,2);
    tmpy = [S(:,i) tmpy];
    tmpa = area(t,tmpy);
    tmpa(1).FaceAlpha = 0;
    tmpa(1).EdgeAlpha = 0;
    for k = 2:K+1
        tmpa(k).EdgeAlpha = 0;
        tmpa(k).FaceColor = cmap(cmapid(k-1),:);
    end
    
    uistack(tmph2,'top');
    uistack(tmph1,'top');
    hold off;
    xlabel('time (hrs)');
    ylabel('density (1/ml)');
    title(sprintf('host %s',data.labels.host(i)));
    ylim([1e4 1e8]);
end

% viruses
for i = 1:n
    subplot(2,n,i+n);
    
    % qpcr
    tmph1 = semilogy(data.xdata,data.ydata(:,data.id.V(i)),'.','Color',.3*[1 1 1],'MarkerSize',7);
    hold on;
    
    % baseline
    tmph2 = semilogy(t,V(:,i),'Color','k','LineWidth',2);

    % gradations
    tmpy = [V(:,i) tmpV(:,grab_type(i))];
    tmpy = diff(tmpy,1,2);
    tmpy = [V(:,i) tmpy];
    tmpa = area(t,tmpy);
    tmpa(1).FaceAlpha = 0;
    tmpa(1).EdgeAlpha = 0;
    for k = 2:K+1
        tmpa(k).EdgeAlpha = 0;
        tmpa(k).FaceColor = cmap(cmapid(k-1),:);
    end
    
    uistack(tmph2,'top');
    uistack(tmph1,'top');    
    hold off;
    xlabel('time (hrs)');
    ylabel('density (1/ml)');
    title(sprintf('phage %s',data.labels.phage(i)));
    ylim([1e2 1e12]);
end

ax = gca;
tmppos = ax.Position;
cbar = colorbar();
cbar.Parent.Colormap = flip(cmap(cmapid,:));
cbar.Label.String = 'Dc (1/mL)';
tmpf = factor(K-1);
if length(tmpf)>1
    if tmpf(1) > 2
        tmpf = tmpf(1);
    else
        tmpf = tmpf(2);
    end
end
tmpid = 1:tmpf:K;
tmptick = (tmpid-1)/(K-1);
cbar.Ticks = tmptick;
cbar.TickLabels = flip(cellstr(num2str(parvec(tmpid)','%.1g')));
ax.Position = tmppos;
cbar.Position(1) = cbar.Position(1)+.02;
cbar.Position(2) = cbar.Position(2)+.24;

end