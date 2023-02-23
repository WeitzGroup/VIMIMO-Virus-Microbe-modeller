clear;
addpath(genpath(pwd)); % add current directory to path (mcmcstat is included)
%mcmcoptions.waitbar = 0; % turn off mcmc status bar


load('results/local/SEIV10_00001_Dbeepr_1001/seed64L0_datasheet.mat'); % qpcr data

stored_error=[];
count = 1;
for i=1:100:mcmcoptions.nsimu
    stored_error(count) = loglikefun(chain(i,:), data, pars, mcmcpars, model, lambda);
    count = count+1;
end

figure(1)
plot(1:100:mcmcoptions.nsimu,stored_error);xlabel('chain position');ylim([50 150])
ylabel('log likelihood error');