function error_summed = error_from_pars(pars,data,model)
%COmputed errors from input parameters


% grab qpcr data
tvec = data.xdata;
ydata = data.ydata;


S0 = pars.S0;
V0 = pars.V0;
[~,S,V] = simulate_ode(model,pars,tvec,S0,V0);

ymodel = [S V];
ymodel(ymodel<0) = 0; % get rid of negative densities

% compute error for each timepoint
log_error_square = (log(ymodel)-log(ydata)).^2;

% total error, not normalized
error_summed = sum(log_error_square(~isnan(log_error_square)));
end

