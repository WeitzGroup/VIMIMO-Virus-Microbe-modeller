function mcmcpars = mcmcpars_setup(pars, pars_example, include_pars, flags,model)
% default values - sub-index (which elements for each parameter), limits, priors, and starting values
% default values are calculated from values within pars and pars_example

% growth rate r
tmp_mcmcpars.r.log = 0;
tmp_mcmcpars.r.subid = 1:length(pars.r);
tmp_mcmcpars.r.lims = [0 10];
tmp_mcmcpars.r.startval = pars.r;
tmp_mcmcpars.r.priormu = pars.r;
%tmp_mcmcpars.r.priorstd = 1*ones(1,length(pars.r));
tmp_mcmcpars.r.priorstd = std(pars.r,'omitnan')*ones(1,length(pars.r));

% carry capacity K
tmp_mcmcpars.K.log = 1;
tmp_mcmcpars.K.subid = 1;
tmp_mcmcpars.K.lims = [1e4 1e10];
tmp_mcmcpars.K.startval = pars_example.K;
tmp_mcmcpars.K.priormu = 0;
tmp_mcmcpars.K.priorstd = +Inf;

% viral decay rate m 
% no prior information - try for 50% decay at 10-1 days
% -> 0.003-0.03 1/hr
tmp_mcmcpars.m.log = 1;
tmp_mcmcpars.m.subid = 1:length(pars.m);
tmp_mcmcpars.m.lims = [1e-5 1]; % 1000days - 1hr
tmp_mcmcpars.m.startval = 1e-3*ones(1,length(pars.m));
tmp_mcmcpars.m.priormu = 1e-3*ones(1,length(pars.m));
tmp_mcmcpars.m.priorstd = +Inf*ones(1,length(pars.m));

% burst size beta
tmp_mcmcpars.beta.log = 0;
tmp_mcmcpars.beta.subid = find(pars.M);
tmp_mcmcpars.beta.lims = [0 1000];
tmp_mcmcpars.beta.startval = pars_example.beta(find(pars.M));
tmp_mcmcpars.beta.priormu = pars.beta(find(pars.M));
%tmp_mcmcpars.beta.priorstd = std(pars.beta(find(pars.M)),'omitnan')*ones(1,length(find(pars.M)));

tmp_mcmcpars.beta.priorstd = std(pars.beta(find(pars.M)),'omitnan')*ones(1,length(find(pars.M)))*.7;

% adsorption rate phi
if ~exist('flags','var') || flags.phi_entire_matrix==0  % default = only nonzero values included
    tmp_mcmcpars.phi.log = 1;
    tmp_mcmcpars.phi.subid = find(pars.M);
    % previously was upto 1e-10
    tmp_mcmcpars.phi.lims = [1e-12 1e-5];
    tmp_mcmcpars.phi.startval = pars_example.phi(find(pars.M));
    tmp_mcmcpars.phi.priormu = pars.phi(find(pars.M));
    %tmp_mcmcpars.phi.priorstd = 10.^std(log10(pars.phi(find(pars.M))),'omitnan')*ones(1,length(find(pars.M)))*10;
    tmp_mcmcpars.phi.priorstd = 10.^std(log10(pars.phi(find(pars.M))),'omitnan')*ones(1,length(find(pars.M)));
else % entire matrix
    tmpphi = pars_example.phi(:);
    tmpphi(tmpphi==0) = 1e-14; % no zeros allowed
    tmp_mcmcpars.phi.log = 1;
    tmp_mcmcpars.phi.subid = 1:numel(pars.phi);
    tmp_mcmcpars.phi.lims = [1e-15 1e-5];
    tmp_mcmcpars.phi.startval = tmpphi;
    tmp_mcmcpars.phi.priormu = tmpphi;
    tmp_mcmcpars.phi.priorstd = 10*ones(numel(pars.phi),1);
end
%{
if exist('flags','var') && flags.phi_uniform==1 % identical start values and uniform priors
    tmp_mcmcpars.phi.startval = 1e-7*ones(size(tmp_mcmcpars.phi.startval));
    tmp_mcmcpars.phi.priormu = 1e-7*ones(size(tmp_mcmcpars.phi.priormu));
    tmp_mcmcpars.phi.priorstd = Inf*ones(size(tmp_mcmcpars.phi.priorstd));
end
%}

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

% non-infectious fraction q
%if ~exist('flags','var') || flags.q_single_val==0  % default = channel-specific
    tmp_mcmcpars.q.log = 0;
    tmp_mcmcpars.q.subid = 1:pars.NV;
    tmp_mcmcpars.q.lims = [0 1];
    tmp_mcmcpars.q.startval = zeros(pars.NV,1);
    tmp_mcmcpars.q.priormu = zeros(pars.NV,1);
    tmp_mcmcpars.q.priorstd = +Inf*ones(pars.NV,1);
    %{
else % uniform across all virus types
    tmp_mcmcpars.q.log = 0;
    tmp_mcmcpars.q.subid = 1;
    tmp_mcmcpars.q.lims = [0 1];
    tmp_mcmcpars.q.startval = 0;
    tmp_mcmcpars.q.priormu = 0;
    tmp_mcmcpars.q.priorstd = +Inf;
end
    %}

% measurement bias epsilon
tmp_mcmcpars.epsilon.log = 0;
tmp_mcmcpars.epsilon.subid = 1:(pars.NV+pars.NH);
tmp_mcmcpars.epsilon.lims = [0.5 1.5];
%tmp_mcmcpars.epsilon.startval = ones(1,pars.NV+pars.NH);
%tmp_mcmcpars.epsilon.priormu = ones(1,pars.NV+pars.NH);

tmp_mcmcpars.epsilon.startval = pars.epsilon;
tmp_mcmcpars.epsilon.priormu = pars.epsilon;

%tmp_mcmcpars.epsilon.priorstd = 0.1*ones(1,pars.NV+pars.NH);
tmp_mcmcpars.epsilon.priorstd = 0.2*ones(1,pars.NV+pars.NH);

% initial conditions
if any(strcmp(fieldnames(pars),'V0'))
    tmp_mcmcpars.V0.log = 1;
    tmp_mcmcpars.V0.subid = 1:pars.NV;
    tmp_mcmcpars.V0.lims = [1e4 1e9];
    tmp_mcmcpars.V0.startval = pars.V0;
    tmp_mcmcpars.V0.priormu = pars.V0;
    tmp_mcmcpars.V0.priorstd = 3*ones(1,pars.NV);
end

% initial conditions
if any(strcmp(fieldnames(pars),'S0'))
    tmp_mcmcpars.S0.log = 1;
    tmp_mcmcpars.S0.subid = 1:pars.NH;
    tmp_mcmcpars.S0.lims = [1e4 1e7];
    tmp_mcmcpars.S0.startval = pars.S0;
    tmp_mcmcpars.S0.priormu = pars.S0;
    tmp_mcmcpars.S0.priorstd = 3*ones(1,pars.NH);
end

% uniform priors
%{
if exist('flags','var') && flags.uniform_priors==1
   for tmpstr = fieldnames(tmp_mcmcpars)'
       tmp_mcmcpars.(tmpstr{1}).priorstd = Inf*tmp_mcmcpars.(tmpstr{1}).priorstd;
   end
end
%}



%tau

tmp_mcmcpars.tau.log = 0;
tmp_mcmcpars.tau.subid = find(pars.M);

if flags.tau_new == 0
    % was upto 20 previously
tmp_mcmcpars.tau.lims = [0.1 27];
elseif flags.tau_new == 1
  tmp_mcmcpars.eta.lims = [0.1 3];
end

tmp_mcmcpars.tau.startval = 1./pars_example.eta(find(pars.M));
tmp_mcmcpars.tau.priormu = tmp_mcmcpars.tau.startval;
tmp_mcmcpars.tau.priorstd = 5*ones(1,length(find(pars.M)));



















if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    tmp_mcmcpars.Dc.log = 1;
    tmp_mcmcpars.Dc.subid = 1;
    tmp_mcmcpars.Dc.lims = [1e4 1e9];
    tmp_mcmcpars.Dc.startval = pars_example.Dc;
    tmp_mcmcpars.Dc.priormu = pars_example.Dc;
    tmp_mcmcpars.Dc.priorstd = +Inf;

end

if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    tmp_mcmcpars.Dc2.log = 1;
    tmp_mcmcpars.Dc2.subid = 1;
    tmp_mcmcpars.Dc2.lims = [1e4 1e9];
    tmp_mcmcpars.Dc2.startval = pars_example.Dc;
    tmp_mcmcpars.Dc2.priormu = pars_example.Dc;
    tmp_mcmcpars.Dc2.priorstd = +Inf;

end


if model.lysis_reset == 1
    tmp_mcmcpars.epsilon_reset.log = 0;
    tmp_mcmcpars.epsilon_reset.subid = 1;
    tmp_mcmcpars.epsilon_reset.lims = [0 1];
    tmp_mcmcpars.epsilon_reset.startval = pars_example.epsilon_reset;
    tmp_mcmcpars.epsilon_reset.priormu = pars_example.epsilon_reset;
    tmp_mcmcpars.epsilon_reset.priorstd = +Inf;

end


% only include these parameters
if ~exist('include_pars','var') || isempty(include_pars) % everything by default
   include_pars = fieldnames(tmp_mcmcpars);
end
for i = 1:length(include_pars)
   mcmcpars.(include_pars{i}) = tmp_mcmcpars.(include_pars{i}); 
end

end

