function ss = error_function(theta,data,model,pars,mcmcpars)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



% grab qpcr data
tvec = data.xdata;
ydata = data.ydata;

%paramters for an input theta (just conversion)
pars_temporary = update_pars(pars,theta,mcmcpars);


S0 = pars_temporary.S0;
V0 = pars_temporary.V0;
[~,S,V] = simulate_ode(model,pars,tvec,S0,V0);
ymodel = [S V];
ymodel(ymodel<0) = 0; % get rid of negative densities



ss = sum((sum((ymodel - ydata).^2)));
end

