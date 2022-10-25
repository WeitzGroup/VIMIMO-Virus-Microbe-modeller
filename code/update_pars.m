function pars = update_pars(pars, theta, mcmcpars)
% update an existing pars struct with values from the theta vector
% the theta vector is internal to mcmcrun
% mcmcpars is a struct containing information about which parameters were
% included in the mcmc run

k = 0;
tmpvar = fieldnames(mcmcpars);
for i = 1:length(tmpvar)
    tmpid = mcmcpars.(tmpvar{i}).subid; % which elements of parameter i were included
    tmpvec = theta(k+(1:length(tmpid))); % grab the elements from the theta vector
    if mcmcpars.(tmpvar{i}).log == 1
        tmpvec = 10.^tmpvec; % transform back to linear space
    end
    pars.(tmpvar{i})(tmpid) = tmpvec; % overwrite existing value in par struct
    k = k+length(tmpid); % grab next values in theta vector
end

end
