%% overwrite old parameters struct with new one-step data and qpcr data
% manually entered - TODO automate data import from xlsx sheet

clear;
load('data/parameters_old');

beta = zeros(5,5);
beta(pars_labels.beta=="PSA H100 - PSA HP1") = 58.7;
beta(pars_labels.beta=="PSA 13-15 - PSA HP1") = 54.2;
beta(pars_labels.beta=="PSA H100 - PSA HS6") = 238.3;
beta(pars_labels.beta=="PSA 13-15 - PSA HS6") = 318.8;
beta(pars_labels.beta=="CBA 18 - CBA 18:2") = 92.21;
beta(pars_labels.beta=="CBA 18 - CBA 18:3") = 27.29;
beta(pars_labels.beta=="CBA 4 - CBA 18:3") = 0.94;
beta(pars_labels.beta=="CBA 38 - CBA 38:1") = 10.5;
beta(pars_labels.beta=="CBA 18 - CBA 38:1") = nan;
pars.beta = beta;

phi = zeros(5,5);
phi(pars_labels.phi=="PSA H100 - PSA HP1") = 2.99e-9;
phi(pars_labels.phi=="PSA 13-15 - PSA HP1") = 3.13e-9;
phi(pars_labels.phi=="PSA H100 - PSA HS6") = 1.27e-9;
phi(pars_labels.phi=="PSA 13-15 - PSA HS6") = 1.67e-9;
phi(pars_labels.phi=="CBA 18 - CBA 18:2") = 3.14e-10;
phi(pars_labels.phi=="CBA 18 - CBA 18:3") = 2.22e-9;
phi(pars_labels.phi=="CBA 4 - CBA 18:3") = 3.05e-9;
phi(pars_labels.phi=="CBA 38 - CBA 38:1") = 1.65e-9;
phi(pars_labels.phi=="CBA 18 - CBA 38:1") = 2.75e-10;
phi = phi*60; % convert from ml/min to ml/hr
pars.phi = phi;

pars.M = pars.beta~=0;
pars.tau(pars_labels.tau=="PSA H100 - PSA HS6") = nan;
pars.eta(pars_labels.eta=="PSA H100 - PSA HS6") = nan;

load('data/qpcr','S0','V0');
pars.S0 = S0;
pars.V0 = V0;

clear beta phi S0 V0;
save('data/parameters');