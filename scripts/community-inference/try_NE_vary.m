clear all;
clc

addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
load("/Users/rdey33/Downloads/cluster/results/results/local/SEIV50_00002_Dbeprt_1001/seed106L0_datasheet.mat")
%% vary NE

%this file already contains good posteriors for 10 NE classes.
% So we vary NE to test how error changes without changing the rest of the
% parameters. In the next stage we will change the parameters with
% ellipsoidal method. In the third stage we will use those point estimates
% as the mean of the priors.

tvec = 0:0.05:15.75; % for better viz

err = [];
for i = [5,10,15,20,30,50,75,100]
model.NE = i;
%[t3,S3,V3,D3] = simulate_ode(model,pars2,tvec,pars2.S0,pars2.V0); % initial parameter set
err(end+1) = loglikefun(median(chain), data, pars2, mcmcpars, model, lambda);
end

plot(err)

%% ellipsoidal method implementation

% do not know if this will work 

for i = 1:43
mean(i,1)=median(chain(:,i));
standard_dev(i) = mcmcparam{1,i}{1,5}; 
end

% for i=15:23
% mean(i,1)=10^(median(chain(:,i)));
% standard_dev(i) =10^mcmcparam{1,i}{1,5}; 
% 
% end
% 
% for i=24:42
%     mean(i,1)=median(chain(:,i));
% standard_dev(i) = mcmcparam{1,i}{1,5}; 
% end
% 
% mean(43,1)=10^(median(chain(:,i)));
% standard_dev(43) = 10^mcmcparam{1,43}{1,5}; 

steps = 100;
epochs = 50;
model.NE = 50;
%%
value=[];
for kkk = 1:epochs
for j = 1:steps
error(j) =  loglikefun((mean(:,j))', data, pars2, mcmcpars, model, lambda)
mean(:,j+1) = mean(:,1) + 0.1*standard_dev'.*(rand(43,1)-0.5);
model.NE = model.NE+round(2*(rand-0.5));
num_comp(j) = model.NE ;
end

[value(end+1),index]=min(error)
model.NE = num_comp(index);
mean(:,1) = mean(:,index);
clear error;
end