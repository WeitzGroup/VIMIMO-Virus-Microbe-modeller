function [theta_store, cost] = theta_search_ball(theta_initial,data,model,pars,mcmcpars)
%THETA_SEARCH Summary of this function goes here
%   Detailed explanation goes here

max_iter = 100;

for i = 1:max_iter 
theta = theta_initial + 0.0001* theta_initial .* randn(1,37); 

theta_store(i,:) = theta;
cost(i) = loglikefun(theta,data,pars,mcmcpars,model,0);
end



end

