% compute AIC for different mcmc fits

clear;

modelnum = 2; % which model to compute for
dirstr = dir(sprintf('results_pace/model%d_combo*',modelnum));
dirstr = {dirstr.name};

% computing sum of squares - omit phage HP1
load('data/qpcr','data');
ydata = data.ydata(:,[1:8 10]);
ssfun = @(ymodel) sum((log(ydata(:))-log(ymodel(:))).^2,'omitnan');

% all combos + all runs for the chosen model
for j = 1:length(dirstr)
    filestr = what(dirstr{j});
    if ~isempty(filestr)
        filestr = filestr.mat;
        
        % compute error for pars_example
        % this gets overwritten for each combo, but they're uniform so it
        % shouldn't matter
        load(sprintf('%s/%s',dirstr{j},filestr{1}),'model','pars_example','S0','V0');
        [~,S,V] = simulate_ode(model,pars_example,data.xdata,S0,V0);
        mcmcfit.model = model;
        mcmcfit.sumsquares_original = ssfun([S V(:,[1:3 5])]); % omit HP1
        
        % compute error for each mcmc run
        for i = 1:length(filestr)  
            load(sprintf('%s/%s',dirstr{j},filestr{i}),'pars2','param','include_pars');
            [~,S2,V2] = simulate_ode(model,pars2,data.xdata,S0,V0);
            mcmcfit.sumsquares(i,j) = ssfun([S2 V2(:,[1:3 5])]); % omit HP1
        end
        
        % information about the combo, pulled from last run
        mcmcfit.numruns(j) = length(filestr);
        mcmcfit.numparam(j) = length(param);
        mcmcfit.paramstr{j} = string(include_pars);
        clear pars2 param include_pars S2 V2 pars_example S0 V0 S V;
    end
    clear filestr;
end
clear i j data model;
mcmcfit.dirstr = dirstr;
mcmcfit.AIC = 2*repmat(mcmcfit.numparam,[length(dirstr) 1]) + 2*log(mcmcfit.sumsquares);
save(sprintf('results_pace/model%d_mcmcfit',modelnum));

%%
fig = plot_AIC(mcmcfit);
print(fig,sprintf('results_pace/model%d_mcmcfit',modelnum),'-dpng');


