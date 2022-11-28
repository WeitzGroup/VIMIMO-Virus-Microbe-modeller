function [S_min,S_max,V_min,V_max] = find_confidence_intervals(chain,transient_id_new,mcmcpars,confidence_limit,model, pars_without_nan)
%FIND_CONFIDENCE_INTERVALS : by Raunak Dey: gives confidence limits, max + min; inputs:
%chain, %of intervals, 
%   Detailed explanation goes here

chain_to_be_used = chain(transient_id_new:end,:);
[length_chain_to_be_used,~]=size(chain_to_be_used);



tvec = 0:0.05:15.75; % for better viz


for i = 1:length_chain_to_be_used

    %pars_from_dist = @(chain_to_be_used) chain_to_be_used;
    pars_used = update_pars(pars_without_nan,chain_to_be_used(i,:),mcmcpars);
    [~,S_recon(:,:,i),V_recon(:,:,i),D_recon(:,:,i)] = simulate_ode(model,pars_used,tvec,pars_used.S0,pars_used.V0); % mcmc parameter set
    
end


for j = 1:length(tvec)
    for k = 1:model.NH
        S_min(j,k) = quantile(S_recon(j,k,i),(1-confidence_limit)/2);
        S_max(j,k) = quantile(S_recon(j,k,i), 1-(1-confidence_limit)/2);
    end

    for k=1:model.NV
        V_min(j,k) = quantile(V_recon(j,k,i),(1-confidence_limit)/2);
        V_max(j,k) = quantile(V_recon(j,k,i),1-(1-confidence_limit)/2);
    end

end

end





