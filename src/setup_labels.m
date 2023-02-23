%% master labels
% all other parameters will be re-ordered to match these

clear;

labels.phage = string(["CBA 18:2","CBA 18:3","CBA 38:1","PSA HP1","PSA HS6"]);
labels.host = string(["CBA 4","CBA 18","CBA 38","PSA H100","PSA 13-15"]);
labels.phage_short = replace(labels.phage,{'CBA ','PSA '},'');
labels.host_short = replace(labels.host,{'CBA ','PSA '},'');
NV = length(labels.phage);
NH = length(labels.host);

save('data/labels','labels','NV','NH');