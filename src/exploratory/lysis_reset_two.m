% lysis reset using different epsilon values for CBA and PSA hosts

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

% 2 epsilon values - 1 for CBA and 1 for PSA hosts
%epsilon_reset = [0.01 0.1 0.3 1];
%epsilon_CBA = [0.01 0.1];
%epsilon_PSA = [0.01 0.9];
epsilon_CBA = [0 logspace(-4,0,9)];
epsilon_PSA = [0 logspace(-4,0,9)];

% simulate baseline model
tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model1,pars1,tvec,pars1.S0,pars1.V0);
[err(1),errlog(1)] = compute_rmse(data,t1,[S1 V1]);

% modified model runs
for i = 1:length(epsilon_CBA)
    for j = 1:length(epsilon_PSA)
        pars2.epsilon_reset = [epsilon_CBA(i)*ones(3,5); epsilon_PSA(j)*ones(2,5)];
        [t2{i,j},S2{i,j},V2{i,j},D2{i,j}] = simulate_ode(model2,pars2,tvec,pars2.S0,pars2.V0); % model 2
        [err(i+1,j+1),errlog(i+1,j+1)] = compute_rmse(data,t2{i,j},[S2{i,j} V2{i,j}]);
    end
end


%%
% plot host/phage timeseries
fig = plot_timeseries2(model1,t1,S1,V1,'',2); % model 1 (grey)
tmpstr = strings(1);
k = 1;
for i = 1:length(epsilon_CBA)
    for j = 1:length(epsilon_PSA)
        overlay_timeseries2(fig,t2{i,j},S2{i,j},V2{i,j},k+2);
        tmpstr(k) = sprintf('C=%.1g, P=%.1g',epsilon_CBA(i),epsilon_PSA(j));
        k = k+1;
    end
end
tmpax = gca;
tmppos = tmpax.Position;
tmpstr = ['qPCR data','baseline model',tmpstr];
legend(tmpstr,'Location','eastoutside');
tmpax.Position = tmppos;
%%
% plot error
fig3 = imagesc_rmse(errlog,epsilon_CBA,'epsilon CBA',epsilon_PSA,'epsilon PSA');

print(fig,'results/exploratory/lysisreset2_timeseries','-dpng');
print(fig3,'results/exploratory/lysisreset2_error','-dpng');
