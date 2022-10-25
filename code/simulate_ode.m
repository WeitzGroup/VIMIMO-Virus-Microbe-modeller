function [t, S, V, D] = simulate_ode(model, pars, tvec, S0, V0)

% set up initial conditions
y0 = model.zeros();
y0(model.id.S) = S0;
y0(model.id.V) = V0;

% integrate
reltol = 1e-8;
opts = odeset('RelTol',reltol);
ode = @(t,y) model.ode(t,y,pars);
[t, y] = ode45(ode,tvec,y0,opts);

% output timeseries + compute total host and virus density
S = model.sum_hosts(y);
V = model.sum_viruses(y);
D = y(:,model.id.D); % debris

% measurement bias
if ~all(isnan(pars.epsilon))
    S = S.*pars.epsilon(1:model.NH);
    V = V.*pars.epsilon(model.NH+(1:model.NV));
end

end