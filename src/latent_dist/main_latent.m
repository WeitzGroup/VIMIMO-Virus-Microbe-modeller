NE = 10;
tau = 1.4;
tau_mul = 5;
tau = tau*tau_mul;

alpha = NE+1;
beta = alpha/tau;

time = 1:0.5:16;

pdf = erlang(time,alpha,beta);

plot(time,pdf);xlabel('time');ylabel('pdf');


function function_value = erlang(x,k,l)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
function_value = ((l^k).*x.^(k-1).*exp(-l*x))./(factorial(k-1));


end