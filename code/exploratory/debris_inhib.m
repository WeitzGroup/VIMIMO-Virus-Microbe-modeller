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
model1.debris_inhib = 0;
model2 = model1;
model2.debris_inhib = 1;
%Dc = logspace(5,7,3);
Dc = logspace(5,8,10); % for nice colorbar tick spacing, choose n such that n-1 is not a prime
Dc = flip(Dc); % so that gradations are colored in correct order

% simulate baseline model
tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model1,pars1,tvec,pars1.S0,pars1.V0);
[err(1),errlog(1)] = compute_rmse(data,t1,[S1 V1]);

% modified model runs
for i = 1:length(Dc)
	pars2.Dc = Dc(i);
	[t2{i},S2{i},V2{i},D2{i}] = simulate_ode(model2,pars2,tvec,pars2.S0,pars2.V0); % model 2
    [err(i+1),errlog(i+1)] = compute_rmse(data,t2{i},[S2{i} V2{i}]);
end

%%
% envelope version
fig1 = plot_timeseries2_gradations(t1,S1,V1,t2,S2,V2,Dc);

%%
% plot host/phage timeseries
fig2 = plot_timeseries2(model1,t1,S1,V1,'',2); % model 1 (grey)
for i = 1:length(Dc)
    overlay_timeseries2(fig2,t2{i},S2{i},V2{i},i+2);
end
tmpax = gca;
tmppos = tmpax.Position;
tmpstr = strcat('Dc=1e',string(log10(Dc)));
tmpstr = ['qPCR data','baseline model',tmpstr];
legend(tmpstr,'Location','eastoutside');
tmpax.Position = tmppos;

%%
% plot debris timeseries
fig3 = plot_debris(t1,D1,t2,D2,log10(Dc),'Dc');

% plot error
fig4 = plot_rmse_bar(errlog,strcat('Dc=1e',string(log10(Dc))));

print(fig1,'results/exploratory/debrisinhib_timeseriesgrad','-dpng');
print(fig2,'results/exploratory/debrisinhib_timeseries','-dpng');
print(fig3,'results/exploratory/debrisinhib_debris','-dpng');
print(fig4,'results/exploratory/debrisinhib_error','-dpng');

