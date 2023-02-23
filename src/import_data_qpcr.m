%% qpcr data

clear;
load('data/labels');

filestr = 'experiments/Final qPCR data.xlsx';
qpcr_protocol = ["qEXT phage infected","qINT phage infected","qINT host infected","qINT host control"];
qpcr_phageorhost = ["phage","phage","host","host"];
qpcr_units = 'genome copies/ml'; % original units are per microliter
NREP = 3; % number of replicates

% import sample times
tmpt = readmatrix(filestr,'Range','A4:A31');
t = tmpt/60;
t_units = 'hours';
NT = length(t);

% import qpcr data
qpcr_replicates = cell(1,4);
qpcr = cell(1,4);
for k = 1:4

    % match order to master label
    tmplabel = string(readcell(filestr,'Sheet',qpcr_protocol(k),'Range','B2:U2','MissingRule','omitvar'));
    tmplabelmaster = labels.(strcat(qpcr_phageorhost(k),'_short')); % grab the correct label!
    tmpmatch = zeros(1,length(tmplabelmaster));
    for i = 1:length(tmpmatch)
       tmpmatch(i) = find(contains(tmplabel,tmplabelmaster(i))); 
    end

    if strcmp(qpcr_phageorhost(k),'phage')
        tmpN = NV;
    elseif strcmp(qpcr_phageorhost(k),'host')
        tmpN = NH;
    end

    % reshape qpcr data
    tmpdata = readmatrix(filestr,'Sheet',qpcr_protocol(k),'DataRange','B4:U31'); % option 'DataRange' has different behavior than 'Range'
    tmpdata = tmpdata(:,setxor(1:20,(NREP+1):(NREP+1):20)); % skip every 4th col (averages)
    tmpdata = reshape(tmpdata,[NT NREP tmpN]);
    tmpdata = permute(tmpdata,[1 3 2]); % col=strain, row=time, 3rd dim=replicate
    tmpdata = tmpdata(:,tmpmatch,:); % reorder to match master label
    tmpdata = tmpdata*1000; % convert from uL to mL

    % clean up
    qpcr_replicates{k} = tmpdata;
    qpcr{k} = mean(tmpdata,3,'omitnan');

end

clear tmp* i k;
save('data/qpcr_raw','qpcr*','t*','labels','NH','NV','NT','NREP');


%% wrap qpcr data into struct compatible with downstream code for MCMC

clear;
load('data/qpcr_raw');

S = qpcr{3}; % 'qINT host infected' or number of host genomes per mL
V = qpcr{1}; % 'qEXT phage infected' or number of free phage per mL

% initial conditions for convenience
S0 = S(1,:)';
V0 = V(1,:)';

data.xdata = t;
data.ydata = [S V]; % response variables all go in 'ydata'
data.id.S = (1:NH);
data.id.V = (1:NV)+NH;
data.units.t = t_units;
data.units.S = 'cells/ml';
data.units.V = 'virions/ml';
data.labels = labels;

clearvars -except data NH NV NT NREP S0 V0
save('data/qpcr');


%% qpcr data for control experiment

clear;
load('data/qpcr_raw');

Srep = qpcr_replicates{4};
S = qpcr{4};
%S0 = S(1,:,:)';
data.xdata = t;
data.ydata = S;
data.units.t = t_units;
data.units.S = 'cells/ml';
data.labels = labels;

clearvars -except data NH NV NT NREP S0 S Srep;
save('data/qpcr_control');


