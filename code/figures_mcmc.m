%% figures after an mcmc run
% to make figures for a specific run, load the .mat file and then run any
% of the sections below

%% mcmc chains
fig = plot_mcmc_chains(mcmcpars,chain,transient_id);
print(fig,sprintf('%s_chain',filestr),'-dpng');
clear fig;

%% error for each step
if exist('err','var') && ~isempty(err)
    fig = plot_mcmc_error(err,transient_id);
    print(fig,sprintf('%s_error',filestr),'-dpng');
    clear fig
end

%% mcmc histograms
figarray = plot_mcmc_histograms(mcmcpars,chain,transient_id);
for i = 1:length(figarray)
    print(figarray(i),sprintf('%s_dist_%s',filestr,figarray(i).Name),'-dpng');
end
clear figarray i;

%% timeseries
%{
fig = plot_timeseries(model,t2,S2,V2); % mcmc result
%overlay_timeseries(fig,t1,S1,V1); % original
print(fig,sprintf('%s_timeseries',filestr),'-dpng');
clear fig;
%}

%% timeseries2, by channel
%{
fig = plot_timeseries2(model,t1,S1,V1); % original (grey)
overlay_timeseries2(fig,t2,S2,V2); % mcmc result (purple)
print(fig,sprintf('%s_timeseries2',filestr),'-dpng');
clear fig;
%}

%% timeseries2, with enevelope
fig = plot_timeseries2(model,t2,S2,V2); % mcmc result
if exist('tsenv','var') && ~isempty(tsenv)
    overlay_timeseries2_envelope(fig,tsenv)
end
print(fig,sprintf('%s_tsenv',filestr),'-dpng');
clear fig;

%% phi matrix
if exist('flags','var') && flags.phi_entire_matrix==1
    fig = imagesc_phi(mcmcpars,pars2);
    print(fig,sprintf('%s_phi',filestr),'-dpng');
    clear fig;
end
