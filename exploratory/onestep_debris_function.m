
function dydt = onestep_debris_function(t,y,theta,NE)
%ONESTEP_FUNCTION Summary of this function goes here


S = y(1);
E_mat(1:NE) = y(2:NE+1);
I = y(NE+2);
V = y(NE+3);
D = y(NE+4);

r = theta(1);
phi = theta(2);
tau = theta(3);
beta = theta(4);
Dc = theta(5);

inhibition = 1./(1+(D/Dc).^2);
etaeff = ((NE+1)/tau);

dotS = r*S - phi*V*S*inhibition;
dotE1 = phi*S*inhibition*V - etaeff * E_mat(1);
dotE_mat = etaeff.*E_mat(1:end-1) - etaeff.*E_mat(2:end);
dotI = etaeff * (E_mat(end) - I);
dotV = beta * etaeff * I - V*phi*(S+I+sum(E_mat));
dotD = etaeff*I;

dydt = [dotS,dotE1,dotE_mat,dotI,dotV,dotD]';

end
