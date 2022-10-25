function ydot = prey_predator_sys(t,y,theta)
% ode system function for MCMC algae example

H = y(1);
V = y(2);



alpha = theta(1);
beta = theta(2);
gamma  = theta(3);
delta = theta(4);


dH = H.*(alpha)-beta.*H.*V;
dV = delta*H.*V - gamma.*V;
ydot = [dH; dV];


