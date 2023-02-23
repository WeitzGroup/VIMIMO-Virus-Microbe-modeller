% show dynamics using original parameter set

clear;
load('data/qpcr','data'); % qpcr data
load('data/parameters_example','pars'); % parameters without nans
pars1 = pars;
load('data/parameters'); % true parameter set with nans

pars1.tau = pars1.tau*2;
pars1.eta = pars1.eta/2;

model = SEIVW(5,5,50);
model.lysis_inhib = 1;
tvec = 0:0.05:15.75; % for better viz
[t,S,V] = simulate_ode(model,pars1,tvec,pars1.S0,pars1.V0); % initial parameter set

fig = plot_timeseries2(model,t,S,V);
print('results/examples/nofit','-dpng');
