function mcmcpars = mcmcpars_setup_new(pars, pars_example, include_pars, flags,model)
% default values - sub-index (which elements for each parameter), limits, priors, and starting values
% default values are calculated from values within pars and pars_example

% growth rate r
tmp_mcmcpars.r.log = 0;
tmp_mcmcpars.r.subid = 1:length(pars.r);
tmp_mcmcpars.r.lims = [0 1];
tmp_mcmcpars.r.startval = pars.r;
tmp_mcmcpars.r.priormu = pars.r;
tmp_mcmcpars.r.priorstd = [0.2 0.2 0.2 0.2 0.2];



% burst size beta
tmp_mcmcpars.beta.log = 0;
tmp_mcmcpars.beta.subid = find(pars.M);
tmp_mcmcpars.beta.lims = [0 1000];
tmp_mcmcpars.beta.startval = pars_example.beta(find(pars.M));
tmp_mcmcpars.beta.priormu = pars.beta(find(pars.M));
tmp_mcmcpars.beta.priorstd = 300*ones(1,length(find(pars.M)));

% adsorption rate phi
    tmp_mcmcpars.phi.log = 1;
    tmp_mcmcpars.phi.subid = find(pars.M);
    tmp_mcmcpars.phi.lims = [1e-12 1e-5];
    tmp_mcmcpars.phi.startval = pars_example.phi(find(pars.M));
    tmp_mcmcpars.phi.priormu = pars.phi(find(pars.M));
    tmp_mcmcpars.phi.priorstd = [4 4 4 4 4 4 4 4 4];


% inverse latent period eta
tmp_mcmcpars.eta.log = 0;
tmp_mcmcpars.eta.subid = find(pars.M);

if flags.tau_new == 0
tmp_mcmcpars.eta.lims = [0 10];
elseif flags.tau_new == 1
  tmp_mcmcpars.eta.lims = [0.4 10];
end

tmp_mcmcpars.eta.startval = pars_example.eta(find(pars.M));
tmp_mcmcpars.eta.priormu = pars.eta(find(pars.M));
tmp_mcmcpars.eta.priorstd = std(pars.eta(find(pars.M)),'omitnan')*ones(1,length(find(pars.M)));



% latent period
tmp_mcmcpars.tau.log = 0;
tmp_mcmcpars.tau.subid = find(pars.M);
tmp_mcmcpars.tau.lims = [0.1 10];
tmp_mcmcpars.tau.startval = 1./pars_example.eta(find(pars.M));
tmp_mcmcpars.tau.priormu = tmp_mcmcpars.tau.startval;
tmp_mcmcpars.tau.priorstd = [10 10 10 10 10 10 10 10 10];

% number of compartments
% will do later


if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    tmp_mcmcpars.Dc.log = 1;
    tmp_mcmcpars.Dc.subid = 1;
    tmp_mcmcpars.Dc.lims = [1e5 5e8];
    tmp_mcmcpars.Dc.startval = pars_example.Dc;
    tmp_mcmcpars.Dc.priormu = pars_example.Dc;
    tmp_mcmcpars.Dc.priorstd = 1e7;

end

if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    tmp_mcmcpars.Dc2.log = 1;
    tmp_mcmcpars.Dc2.subid = 1;
    tmp_mcmcpars.Dc2.lims = [1e5 5e8];
    tmp_mcmcpars.Dc2.startval = pars_example.Dc2;
    tmp_mcmcpars.Dc2.priormu = pars_example.Dc2;
    tmp_mcmcpars.Dc2.priorstd = 1e7;

end

if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    tmp_mcmcpars.Dc3.log = 1;
    tmp_mcmcpars.Dc3.subid = 1;
    tmp_mcmcpars.Dc3.lims = [1e5 5e8];
    tmp_mcmcpars.Dc3.startval = pars_example.Dc3;
    tmp_mcmcpars.Dc3.priormu = pars_example.Dc3;
    tmp_mcmcpars.Dc3.priorstd = 1e7;

end

if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    tmp_mcmcpars.Dc4.log = 1;
    tmp_mcmcpars.Dc4.subid = 1;
    tmp_mcmcpars.Dc4.lims = [1e5 5e8];
    tmp_mcmcpars.Dc4.startval = pars_example.Dc4;
    tmp_mcmcpars.Dc4.priormu = pars_example.Dc4;
    tmp_mcmcpars.Dc4.priorstd = 1e7;

end

if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    tmp_mcmcpars.Dc5.log = 1;
    tmp_mcmcpars.Dc5.subid = 1;
    tmp_mcmcpars.Dc5.lims = [1e5 5e8];
    tmp_mcmcpars.Dc5.startval = pars_example.Dc5;
    tmp_mcmcpars.Dc5.priormu = pars_example.Dc5;
    tmp_mcmcpars.Dc5.priorstd = 1e7;

end



% only include these parameters
if ~exist('include_pars','var') || isempty(include_pars) % everything by default
   include_pars = fieldnames(tmp_mcmcpars);
end
for i = 1:length(include_pars)
   mcmcpars.(include_pars{i}) = tmp_mcmcpars.(include_pars{i}); 
end

end

