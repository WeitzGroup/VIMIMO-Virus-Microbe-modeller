function error_chain(start,ending,chain,data,pars2,mcmcpars,model)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

err=[];
pos=[];
for i = start:10:ending
err(end+1) = ssfun(chain(i,:),data,pars2,mcmcpars,model);
pos(end+1) = i;

end

figure(1)
plot(pos,err);
xlabel('chain position');
ylabel('Normalized error');