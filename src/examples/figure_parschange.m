% show original vs new parameter set

clear;
load('data/labels');
load('data/parameters');
pars2 = pars;
load('data/parameters_old');

lims.phi = [min([pars.phi(pars.phi>0); pars2.phi(pars2.phi>0)]) max([pars.phi(:); pars2.phi(:)])];
lims.beta = [min([pars.beta(pars.beta>0); pars2.beta(pars2.beta>0)]) max([pars.beta(:); pars2.beta(:)])];

fig = figure();
nrow = 2;
ncol = 3;

subplot(nrow,ncol,1);
imagesc_parmat(pars.M,'M');
subplot(nrow,ncol,2);
imagesc_parmat(pars.phi,'phi',lims.phi);
subplot(nrow,ncol,3);
imagesc_parmat(pars.beta,'beta',lims.beta);

subplot(nrow,ncol,4);
imagesc_parmat(pars2.M,'M');
subplot(nrow,ncol,5);
imagesc_parmat(pars2.phi,'phi',lims.phi);
subplot(nrow,ncol,6);
imagesc_parmat(pars2.beta,'beta',lims.beta);

fig.Position(3:4) = fig.Position(3:4).*[2.25 1.5];
fig.Position(2) = fig.Position(2)-fig.Position(4)/2;

print('results/examples/parschange','-dpng');