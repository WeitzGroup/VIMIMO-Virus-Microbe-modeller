function figarray = plot_mcmc_histograms(mcmcpars, chain, transient_id)
% returns a figure array with n figures:
%  n is the number of parameters included in the mcmc
%  for each parameter, sub-parameters are plotted on separate subplots

load('data/parameters','pars','pars_units','pars_labels'); % "true values" from sullivan lab
tmpvars = fieldnames(mcmcpars);
n = length(tmpvars);

k = 0;
for i = 1:n
    figarray(i) = figure('Name',tmpvars{i});
    
    % grab parameter i and its chain
    tmps = mcmcpars.(tmpvars{i}); % substruct
    tmpchain = chain(:,k+(1:length(tmps.subid)));
    if exist('transientID','var') && ~isempty(transient_id)
        tmpchain = tmpchain(transient_id:end,:);
    end
    
    % was value log transformed or not
    if tmps.log==0
        tmpf = @(x) x;
    elseif tmps.log==1
        tmpf = @(x) log10(x);
    end
    
    % x limits
    tmpxlim = [min(tmpchain(:)) max(tmpchain(:))];
    tmpxrange = diff(tmpxlim);
    tmppercent = abs(tmpxlim-tmpf(tmps.lims))/tmpxrange; % how close are chain limits to manual limits?
    if tmppercent(1)<0.3 % expand xlim a little bit to show manual limits
        tmpxlim(1) = tmpf(tmps.lims(1))-tmpxrange/10;
    end
    if tmppercent(2)<0.3
        tmpxlim(2) = tmpf(tmps.lims(2))+tmpxrange/10;
    end
    
    if strcmp(tmpvars{i},'epsilon') % special case for epsilon parameter - show full allowed range
        tmpxlim = tmps.lims;
    elseif strcmp(tmpvars{i},'q') % special case for q parameter - show 0 to 1
        tmpxlim = [0 1];
    end

    % subplot layout
    if rem(length(tmps.subid),5)==0
        tmpcol = 5;
        tmprow = length(tmps.subid)/5;
    elseif rem(length(tmps.subid),4)==0
        tmpcol = 4;
        tmprow = length(tmps.subid)/4;
    elseif length(tmps.subid)>5
        tmpcol = 5;
        tmprow = ceil(length(tmps.subid)/5);
    else
        tmpcol = length(tmps.subid);
        tmprow = 1;
    end
    
    % histogram subplot for each sub parameter
    for j = 1:length(tmps.subid)
        subplot(tmprow,tmpcol,j)
        histogram(tmpchain(:,j),300,'Normalization','pdf','BinLimits',tmpxlim,'DisplayStyle', 'stairs');
        hold on;
        tmpy = ylim;
        
        % true value
        tmptrue = tmpf(pars.(tmpvars{i})(tmps.subid(j)));
        if isnan(tmptrue) || isinf(tmptrue)
            text(.98,.95,sprintf('%s',tmptrue),'Units','Normalized','HorizontalAlignment','right','Color','r');
        else
            plot([tmptrue tmptrue],tmpy,'r','LineWidth',3);
        end
 
        % starting value
        tmpstart = tmpf(tmps.startval(j));
        set(gca,'ColorOrderIndex',1);
        plot([tmpstart tmpstart],tmpy,'g:','LineWidth',1.5);
        
        % prior distribution
        tmpxvec = linspace(tmpxlim(1),tmpxlim(2),100);
        tmppdf = normpdf(tmpxvec,tmpf(tmps.priormu(j)),tmpf(tmps.priorstd(j)));
        plot(tmpxvec,tmppdf,'k','LineWidth',1);
                
        % shade to show where sampling limits are
        tmph = area([tmpf(tmps.lims(2)) tmpxlim(2)],[1 1]*tmpy(2),'FaceColor',[.7 .7 .7],'EdgeAlpha',0); % upper limit
        uistack(tmph,'bottom');
        tmph = area([tmpxlim(1) tmpf(tmps.lims(1))],[1 1]*tmpy(2),'FaceColor',[.7 .7 .7],'EdgeAlpha',0); % lower limit
        uistack(tmph,'bottom');
        
        % reset limits and set title
        hold off;
        ylim(tmpy);
        xlim(tmpxlim);
        tmpstr = pars_labels.(tmpvars{i})(tmps.subid(j)); % e.g. 'CBA 18 - CBA 18:2'
        %tmpstr = sprintf('%s%d',tmpvars{i},tmps.subid(j)); % e.g. 'beta2'
        %if tmps.log==1
        %    tmpstr = sprintf('log10 %s',tmpstr);
        %end
        if strcmp(tmpvars{i},'q') && length(tmps.subid)==1 % special case when q parameter is uniform across virus types
            tmpstr = 'uniform q';
        end
        title(tmpstr);
        
        % add side label
        if j==1 && length(tmps.subid)>1
            tmpstr = sprintf('%s (%s)',tmpvars{i},pars_units.(tmpvars{i}));
            if tmps.log==1
                tmpstr = sprintf('log10 %s',tmpstr);
            end
            text(-.45,-.18,tmpstr,'Units','normalized','Rotation',90,'HorizontalAlignment','center','FontSize',12);
        end
        
    end
    figarray(i).Position(3:4) = figarray(i).Position(3:4).*[tmpcol/2 tmprow/2];
    figarray(i).Position(2) = figarray(i).Position(2)-figarray(i).Position(4)*.7;
    figarray(i).Position(1) = figarray(i).Position(1)-figarray(i).Position(3)*.4;
    k = k+length(tmps.subid);
end

end
