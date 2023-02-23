
%% doubling time experiments (growth rates with replicates)

clear;
load('data/labels');

% read experiment data from excel file
% (requires Matlab 2019; not compatible with Matlab 2020)
filestr = 'experiments/PC growth curve summary.xlsx';
tmplabelhost = string(readcell(filestr,'Range','A3:A8'))';
tmpdata = readmatrix(filestr,'Range','H3:Q8','NumHeaderLines',0);

% sort to match the master label
tmpkeep = ismember(tmplabelhost,labels.host_short); % there is an extra host included in this data
[~,~,tmpmatch] = intersect(labels.host_short,tmplabelhost(tmpkeep),'stable');
tmpdata = tmpdata(tmpkeep,:);
tmpdata = tmpdata(tmpmatch,:);

% convert doubling time to growth rate
r_replicates = (log(2)./tmpdata);
r = mean(r_replicates,2,'omitnan');
r_units = '1/hr';

clear tmp*;
save('data/parameters_raw','r*','-append');


%% one-step experiments (latent period, burst size, percent phage infecting, MOI)
% no data for non-interacting pairs
% a single pair does not have data because infection was so weak
% phage CBA 38:1 and host CBA 18
% long latent period and/or small burst size

clear;
load('data/labels');

% read experiment data from excel file
filestr = 'experiments/Summary of one-step data.xlsx';
tmplabelphage = string(readcell(filestr,'Range','A4:A11'))';
tmplabelhost = string(readcell(filestr,'Range','B4:B11'))';
tmpdata = readmatrix(filestr,'Range','D4:F11','NumHeaderLines',0);
tmpdata2 = string(readcell(filestr,'Range','C4:C11')); % latent periods

% extra parsing for the latent periods
tmpdata2 = replace(tmpdata2,' min','');
tmpdata3 = nan(size(tmpdata2));
for i = 1:length(tmpdata2) % if latent period is a range e.g. "70-80" take the average
    tmpdata3(i) = mean(str2double(split(tmpdata2(i),'-')));
end

% sort to match the master labels
tmphostid = zeros(1,length(tmplabelhost));
for i = 1:length(tmphostid)
   tmphostid(i) = find(strcmp(tmplabelhost(i),labels.host_short)); 
end
tmpphageid = zeros(1,length(tmplabelphage));
for i = 1:length(tmpphageid)
    tmpphageid(i) = find(strcmp(tmplabelphage(i),labels.phage_short));
end
tmpid = sub2ind([NH NV],tmphostid,tmpphageid);

% create matrices
beta = zeros(NH,NV);
beta(tmpid) = tmpdata(:,1);
beta_units = 'virions';
tau = zeros(NH,NV);
tau(tmpid) = tmpdata3/60; % latent period in hours
tau_units = 'hr';
fractionphageinfecting = zeros(NH,NV);
fractionphageinfecting(tmpid) = tmpdata(:,2);
fractionphageinfecting_units = '';
moi = zeros(NH,NV);
moi(tmpid) = tmpdata(:,3);
moi_units = 'virion:cell';

% boolean infection network
M = beta~=0;
M_units = '';

% inverse latent period
eta = 1./tau;
eta(isinf(eta)) = 0;
eta_units = '1/hr';

%clear tmp* i;
save('data/parameters_raw','beta*','tau*','fractionphageinfecting*','moi*','M*','eta*','-append');


%% partial adsorption data, communicated by sullivan team in emails
% phage PSA HP1 and host PSA 13-15 = 3.13*10^-9 mL/min
% phage PSA HS6 and host PSA 13-15 = 1.67*10^-9 mL/min

clear;
load('data/labels');

phi = nan(NH,NV);
phi(contains(labels.host,'13-15'),contains(labels.phage,'HP1')) = 3.13e-9*60;
phi(contains(labels.host,'13-15'),contains(labels.phage,'HS6')) = 1.67e-9*60;
phi_units = 'ml/hr';

% assume non-interacting pairs have zero adsorption
load('parameters_raw','beta');
phi(beta==0) = 0;

save('data/parameters_raw','phi*','-append');



%% wrap parameters into a struct, which is compatible with downstream code for simulating odes

clear;
load('data/parameters_raw');
load('data/qpcr','S0','V0');

pars.NH = NH;
pars.NV = NV;
pars.r = r;
pars.M = M;
pars.beta = beta;
pars.tau = tau;
pars.eta = eta;
pars.phi = phi;
pars.a = nan(NH,NH);
pars.K = nan();
pars.m = nan(NV,1);
pars.q = nan(NV,1); % percent non-infectious particles from new burst
pars.epsilon = nan(1,NH+NV); % measurement bias
pars.S0 = S0; % initial conditions
pars.V0 = V0; % initial conditions

pars_units.r = r_units;
pars_units.M = M_units;
pars_units.beta = beta_units;
pars_units.tau = tau_units;
pars_units.eta = eta_units;
pars_units.phi = phi_units;
pars_units.a = '';
pars_units.K = '1/ml';
pars_units.m = '1/hr';
pars_units.q = '';
pars_units.epsilon = '';
pars_units.S0 = '1/ml';
pars_units.V0 = '1/ml';

% any virus-host matrix
tmpstr = append(labels.host',' - ',labels.phage);
pars_labels.r = labels.host;
pars_labels.M = tmpstr;
pars_labels.beta = tmpstr;
pars_labels.tau = tmpstr;
pars_labels.eta = tmpstr;
pars_labels.phi = tmpstr;
pars_labels.a = append(labels.host',' - ',labels.host);
pars_labels.K = "";
pars_labels.m = labels.phage;
pars_labels.q = labels.phage;
pars_labels.epsilon = [labels.host labels.phage];
pars_labels.S0 = labels.host;
pars_labels.V0 = labels.phage;

clearvars -except pars pars_units pars_labels
save('data/parameters');

