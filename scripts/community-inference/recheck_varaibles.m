clear;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
%load('/Users/rdey33/Downloads/seed307L0_datasheet.mat');
load('/Users/rdey33/Downloads/VIMIMO/results/local/SEIV70_00000_Dbeprt_1001/seed324L0_datasheet.mat')



%% 
% 
% pars2.beta = [0  330.2800         0         0         0;
%   273.4183  404.5599  284.5947         0         0;
%          0         0   96.1372         0         0;
%          0         0         0  180.5798  147.4428;
%          0         0         0  407.5273   34.5967];
% 
% 
% pars2.Dc =  4.5147e+06;
% pars2.phi =    1.0e-07 * [0    0.2843         0         0         0;
%     0.5049    0.4686    0.1740         0         0;
%          0         0    0.6169         0         0;
%          0         0         0    0.0207    0.2966;
%          0         0         0    0.1239    0.0097];
% 
% 
% pars2.r = [0.0861;
%     0.0808;
%     0.0109;
%     0.4073;
%     0.5793];
% 
% pars2.epsilon = [1.3955    0.5999    1.4714    1.0639    0.7578    1.2479    0.9227    1.3500    1.4742    1.0041];
% pars2.tau = [1.3955    0.5999    1.4714    1.0639    0.7578    1.2479    0.9227    1.3500    1.4742    1.0041];
% round(pars2.NE/3)


 tvec = 0:0.05:15.75;

%% plotting

% figure(1)
% for i=1:5
%     subplot(2,5,i)
%     plot(t2,S2(:,i));hold on;plot(data.xdata,data.ydata(:,i),'ko'); ylim([1e4 1e8]);
%    set(gca, 'YScale', 'log')
% end
% for j=1:5
%     subplot(2,5,j+5)
%     plot(t2,V2(:,j)); hold on; plot(data.xdata,data.ydata(:,j+5),'ko'); ylim([1e4 1e11]);
%     set(gca, 'YScale', 'log')
% end



%% inference again

mcmcoptions.nsimu = 1000;

for i=1:1
    transient_id = mcmcoptions.nsimu *0.9;



pars2.NE = 10*(pars.M == 1);
% % these are the old ones.
% pars2.NE(1,2) = 78;
% pars2.NE(2,1) = 76;
% pars2.NE(2,2) = 73;
% pars2.NE(2,3) = 77;
% pars2.NE(3,3) = 72;
% pars2.NE(4,4) = 85;
% pars2.NE(4,5) = 104;
% pars2.NE(5,4) = 93;
% pars2.NE(5,5) = 101;

%     pars2.NE =[ 0    62     0     0     0;
%     75    69    70     0     0;
%      0     0    68     0     0;
%      0     0     0    75    98;
%      0     0     0    87   109];

% the new ones after one step
pars2.NE(1,2) = 77;
pars2.NE(2,1) = 74;
pars2.NE(2,2) = 85;
pars2.NE(2,3) = 71;
pars2.NE(3,3) = 55;
pars2.NE(4,4) = 83;
pars2.NE(4,5) = 98;
pars2.NE(5,4) = 87;
pars2.NE(5,5) = 109;

pars.NE = pars2.NE;
pars1.NE = pars2.NE;

max_NE = round(max(max(pars2.NE)));
model = SEIV_diff_NE(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;


mcmcpars = mcmcpars_setup(pars2,pars2,include_pars,flags,model);
mcmcparam = mcmcpars2param(mcmcpars);
mcmcmodel.ssfun = @(theta,data) ssfun(theta,data,pars2,mcmcpars,model,lambda); 


[mcmcresults, chain, s2chain]= mcmcrun(mcmcmodel,data,mcmcparam,mcmcoptions);
pars_from_dist = @(chain) median(chain);
pars2 = update_pars(pars2,pars_from_dist(chain(transient_id:end,:)),mcmcpars);



tvec = 0:0.05:15.75; % for better viz
[t2,S2,V2,D2] = simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % mcmc parameter set



filestr = sprintf('%s/seed%dL%.2g',dirstr,seed+22,max(log10(lambda),0));
figure_mcmc2

save(strcat(filestr,'_datasheet'));

end


