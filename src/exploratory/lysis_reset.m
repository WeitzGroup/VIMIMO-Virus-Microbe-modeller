% lysis reset

clear;

% import parameter set
tmp_parstr = 'mcmc';
switch tmp_parstr
    
    case 'original' % original experimental pars
        load('data/parameters_example','pars');
        pars1 = pars;
        clear pars;
        flags.tau_mult = 5;
        pars1.tau = pars1.tau*flags.tau_mult;
        pars1.eta(pars1.tau>0) = 1./pars1.tau(pars1.tau>0);
        pars2 = pars1;
        
    case 'mcmc' % mcmc pars best run
        load('figures/figure5_SEIV5_0000_bep_00000.mat','pars2');
        pars1 = pars2;
end

% import qpcr data
load('data/qpcr','data');

% model setup
model1 = SEIV(5,5,5);
model1.lysis_reset = 0;
model2 = model1;
model2.lysis_reset = 1;

% scalar epsilon for all host-phage pairs
epsilon_reset = [0.01 0.1 0.3 1];

% simulate baseline model
tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model1,pars1,tvec,pars1.S0,pars1.V0);
[err(1),errlog(1)] = compute_rmse(data,t1,[S1 V1]);

% modified model runs
for i = 1:length(epsilon_reset)
	pars2.epsilon_reset = epsilon_reset(i);
	[t2{i},S2{i},V2{i},D2{i}] = simulate_ode(model2,pars2,tvec,pars2.S0,pars2.V0); % model 2
    [err(i+1),errlog(i+1)] = compute_rmse(data,t2{i},[S2{i} V2{i}]);
end


%%
% plot host/phage timeseries
fig = plot_timeseries2(model1,t1,S1,V1,'',2); % model 1 (grey)
for i = 1:length(epsilon_reset)
    overlay_timeseries2(fig,t2{i},S2{i},V2{i},i+2);
end
tmpax = gca;
tmppos = tmpax.Position;
tmpstr = strcat('epsilon=',string(epsilon_reset));
tmpstr = ['qPCR data','baseline model',tmpstr];
legend(tmpstr,'Location','eastoutside');
tmpax.Position = tmppos;

% plot debris timeseries
fig2 = plot_debris(t1,D1,t2,D2,epsilon_reset,'epsilon');

% plot error
fig3 = plot_rmse_bar(errlog,strcat('epsilon=',string(epsilon_reset)));

print(fig,'results/exploratory/lysisreset_timeseries','-dpng');
print(fig2,'results/exploratory/lysisreset_debris','-dpng');
print(fig3,'results/exploratory/lysisreset_error','-dpng');

