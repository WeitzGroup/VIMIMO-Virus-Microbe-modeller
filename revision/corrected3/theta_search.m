function [theta_optimized, cost_minimized] = theta_search(theta_initial,data,model,pars,mcmcpars)
%THETA_SEARCH Summary of this function goes here
%   Detailed explanation goes here



loglikefun(theta_initial,data,pars,mcmcpars,model,0)


% Set up optimization options
options = optimset('fminunc');
options.Display = 'iter'; % Display optimization progress
options.MaxIter = 10;  % Limit the number of iterations
options.TolFun = 1e-3;   % Tolerance for cost improvement


% Perform the optimization
[theta_optimized, cost_minimized] = fminunc(@(theta) loglikefun(theta,data,pars,mcmcpars,model,0), theta_initial, options);


end

