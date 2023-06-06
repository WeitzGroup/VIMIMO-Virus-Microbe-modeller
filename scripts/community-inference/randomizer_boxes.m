clear;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
load('/Users/rdey33/Downloads/seed307L0_datasheet.mat')
%load('results/local/SEIV70_00000_Dbeprt_1001/seed313L0_datasheet.mat');
%pars2.NE(2,3) = 100;
%pars2.NE(3,3) = 100;
transient_id = 19000;
ssfun(median(chain(transient_id:end,:)),data,pars2,mcmcpars,model)


%% error

tvec = 0:0.05:15.75; % for better viz

for i = 1:1000



pars2.NE = randi([65,110],5,5);
pars2.NE(1,1) = 0;
pars2.NE(1,3) = 0;
pars2.NE(1,4) = 0;
pars2.NE(1,5) = 0;
pars2.NE(2,4) = 0;
pars2.NE(2,5) = 0;
pars2.NE(3,1) = 0;
pars2.NE(3,2) = 0;
pars2.NE(3,4) = 0;
pars2.NE(3,5) = 0;
pars2.NE(4,1) = 0;
pars2.NE(4,2) = 0;
pars2.NE(4,3) = 0;
pars2.NE(5,1) = 0;
pars2.NE(5,2) = 0;
pars2.NE(5,3) = 0;



pars_from_dist = @(chain) median(chain);
pars2 = update_pars(pars2,pars_from_dist(chain(transient_id:end,:)),mcmcpars);


max_NE = round(max(max(pars2.NE)));
model = SEIV_diff_NE(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;


    [t2,S2,V2,D2] = simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set
    error(i) = ssfun(median(chain(transient_id:end,:)),data,pars2,mcmcpars,model);
    store(:,:,i) = pars2.NE;
    i

end

plot(error)

