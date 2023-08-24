%% Choice of the mcmc settings

if flags.ssfun_normalized==0
	ssfun = @loglikefun;
elseif flags.ssfun_normalized==1
	ssfun = @loglikefun_normalized;
end

% which mcmc algorithm to use
% default value is 1 ('dram');
mcmcmethods = {'dram','am','dr', 'ram','mh'};
mcmcoptions.method = mcmcmethods{flags.mcmc_algorithm};
clear mcmcmethods;


%% Running the mcmc protocol locally
if isfield(flags,'broader_priors') == 0
    mcmcpars = mcmcpars_setup(pars,pars1,include_pars,flags,model);
else
    if flags.broader_priors == 0
        mcmcpars = mcmcpars_setup(pars,pars1,include_pars,flags,model);
    elseif flags.broader_priors == 1
        mcmcpars = mcmcpars_setup_broader(pars,pars1,include_pars,flags,model);
    end
end



mcmcparam = mcmcpars2param(mcmcpars);
mcmcmodel.ssfun = @(theta,data) ssfun(theta,data,pars1,mcmcpars,model,lambda); 
[mcmcresults, chain, s2chain]= mcmcrun(mcmcmodel,data,mcmcparam,mcmcoptions);


%% simulate timeseries for resulting parameter set
fprintf('simulating timeseries...\n');
%pars_from_dist = @(chain) mean(chain);
pars_from_dist = @(chain) median(chain);
pars2 = update_pars(pars1,pars_from_dist(chain(transient_id:end,:)),mcmcpars);
tvec = 0:0.05:15.75; % for better viz
[t2,S2,V2,D2] = simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set
clear tvec;

%% display all the mcmc stats and figures
chainstats(chain);

%% Plot the mcmc dynamics

figure(3)
for i=1:5
plot(data.xdata,data.ydata(:,i),'*');hold on;plot(t2,S2(:,i),'-',LineWidth=2); %microbes
xlabel('Time (hours)');ylabel('Host (cells/ml)');set(gca,'Yscale','log'); ylim([1e5 1e8])
title(['Points are from averaged experimental datasets, line is from simulated SEIV model' ...
    ' (N_E=10)'])
end

figure(4)
for i=1:5
plot(data.xdata,data.ydata(:,i+5),'*');hold on;plot(t2,V2(:,i),'-',LineWidth=2); %virus
xlabel('Time (hours)');ylabel('Phage (cells/ml)');set(gca,'Yscale','log');
title('Points are from averaged experimental datasets, line is from simulated SEIV model (N_E=10)')
end

