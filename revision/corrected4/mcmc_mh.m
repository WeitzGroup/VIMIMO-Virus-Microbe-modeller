function [ratio,chain]=mcmc_mh(mcmcmodel,data,mcmcparam,proposal_sig,options)
%MCMC_MH Summary of this function goes here
%  Produces a mcmc run for given likelihood function and prior distribution
%  for symmetric gaussian proposal.

%the variance of the gaussian likelihood
sigma_gl = options.sigma;

% the sum of square errors (log transformed differences)
ss  = mcmcmodel.ssfun;     % sum of squares function

% loglikelihood function, assuming gaussian likelihood function
ll = @(theta, data, sigma_gl) ss(theta, data) / (-2*sigma_gl)  ;% ---create the prior function multivariate gaussian (independent) from params----

% prior functions, assuming they are independent, there is no covariance
priorfun = @(th,mu,sig)sum(((th-mu)./sig).^2);

% use feval function

% not putting covariance of priors now.
for i=1:options.num_param
mu_prior(i) = mcmcparam{1,i}{1,5};
sig_prior(i,i) = mcmcparam{1,i}{1,6};
chain_start(i) = mcmcparam{1,i}{1,2};
end

% proposal doesn't have covariance now



for i = 1:options.nsimu
chain_old = chain_start;
chain_propose = mvnrnd(chain_old, proposal_sig, 1);

loglike_new = feval(ll,chain_propose,data,sigma_gl);
loglike_old = feval(ll,chain_old,data,sigma_gl);
prior_log_new = feval(priorfun,chain_propose,mu_prior,sig_prior);
prior_log_old = feval(priorfun,chain_old,mu_prior,sig_prior);

% these transition ratios will be same so will disappear (cancel out)
%transition_log_new = %no need
%transition_log_old = %no need

ratio(i) = loglike_new + prior_log_new - loglike_old - prior_log_old;

chain(i,:) = chain_propose;

% later need to check if ratio is great that or less than 0 and keep
% updating.

end



end

