clc;
clear all;


alpha = 2/3;
beta = 4/3;
gamma = 1;
delta = 1;
theta_true = [alpha, beta, gamma, delta];

model = prey_predator(alpha,beta,gamma,delta);

H_star = alpha/beta;
V_star = gamma/delta;

delta_m = 0.1;

H0 = H_star*(1+delta_m);
V0 = V_star*(1+delta_m);

tvec = 0:(15/60/24):20; % days
[t,H,V] = model.simulate(tvec,H0,V0);
% t, H and V are the data.

%% MCMC starts here
% my first MCMC run.


%create the data field
data.tvec=tvec;
data.y=[H,V];


%parameters
params = {
    {'alpha', 0.5,  0, Inf, 0.5, 2}
    {'beta', 0.6,  0, Inf, NaN, 2}
    {'gamma', 0.5,  0, Inf, 0.5, 2}
    {'delta', 0.5,  0, Inf, 0.5, 2}
    };

%model
model_mcmc.ssfun = @ssfun;

model_mcmc.sigma2 = 0.01;
model_mcmc.N0 = [2 2]; % prior accuracy for sigma2
model_mcmc.S20 = [1 1]; % prior mean for sigma2

model_mcmc.N = length(data.y(:,1));  % total number of observations 
%options
options.nsimu = 4000;

[results, chain, s2chain]= mcmcrun(model_mcmc,data,params,options);

chainstats(chain,results)
%% displaying results
figure(2); clf
mcmcplot(chain,[],results,'chainpanel');

figure(3); clf
mcmcplot(chain,[],results,'pairs');

figure(4); clf
mcmcplot(sqrt(s2chain),[],[],'hist')
title('Error std posterior')

for i=1:options.nsimu
    error_stored(i) = ssfun(chain(i,:),data); 
end


figure(5)
plot((1:options.nsimu),error_stored); xlabel('# runs');ylabel('error');set(gca,'Yscale','log');
%%

% 
 modelfun = @(data,theta,y0) prey_predator_fun(data.tvec,mean(chain),[H0,V0]);
% %model_infunct= modelfun(data,chain,[H0,V0]);
% 
 nsample = 500;
% %very bad coding ;)
% 
% %problem is empty s2chain
% 
 out = mcmcpred(results,chain,s2chain,data,modelfun,nsample,[]);
% 
%out.data{1}.ydata(:,1) = out.data{1}.tvec';
out.data{1}.ydata(:,1) = out.data{1}.y(:,2);                            
% 
% 
raunak_mcmcpredplot(out);

% predicted
med_chain=median(chain);
a = med_chain(1);
b = med_chain(2);
c = med_chain(3);
d = med_chain(4);



model = prey_predator(a,b,c,d);
[t,H_predicted,V_predicted] = model.simulate(tvec,H0,V0);
figure(3)
plot(H,'-r');hold on;plot(V,'-b');plot(H_predicted,'-g');plot(V_predicted,'-k');
