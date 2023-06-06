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


S_reconstructed1 = reshape(S_recon(:,1,:),length(tvec),length_chain_to_be_used);
S_reconstructed2 = reshape(S_recon(:,2,:),length(tvec),length_chain_to_be_used);
S_reconstructed3 = reshape(S_recon(:,3,:),length(tvec),length_chain_to_be_used);
S_reconstructed4 = reshape(S_recon(:,4,:),length(tvec),length_chain_to_be_used);
S_reconstructed5 = reshape(S_recon(:,5,:),length(tvec),length_chain_to_be_used);

V_reconstructed1 = reshape(V_recon(:,1,:),length(tvec),length_chain_to_be_used);
V_reconstructed2 = reshape(V_recon(:,2,:),length(tvec),length_chain_to_be_used);
V_reconstructed3 = reshape(V_recon(:,3,:),length(tvec),length_chain_to_be_used);
V_reconstructed4 = reshape(V_recon(:,4,:),length(tvec),length_chain_to_be_used);
V_reconstructed5 = reshape(V_recon(:,5,:),length(tvec),length_chain_to_be_used);


S_min(:,1) = quantile(S_reconstructed1',(1-confidence_limit)/2);
S_max(:,1) = quantile(S_reconstructed1',1-(1-confidence_limit)/2);
S_min(:,2) = quantile(S_reconstructed2',(1-confidence_limit)/2);
S_max(:,2) = quantile(S_reconstructed2',1-(1-confidence_limit)/2);
S_min(:,3) = quantile(S_reconstructed3',(1-confidence_limit)/2);
S_max(:,3) = quantile(S_reconstructed3',1-(1-confidence_limit)/2);
S_min(:,4) = quantile(S_reconstructed4',(1-confidence_limit)/2);
S_max(:,4) = quantile(S_reconstructed4',1-(1-confidence_limit)/2);
S_min(:,5) = quantile(S_reconstructed5',(1-confidence_limit)/2);
S_max(:,5) = quantile(S_reconstructed5',1-(1-confidence_limit)/2);


V_min(:,1) = quantile(V_reconstructed1',(1-confidence_limit)/2);
V_max(:,1) = quantile(V_reconstructed1',1-(1-confidence_limit)/2);
V_min(:,2) = quantile(V_reconstructed2',(1-confidence_limit)/2);
V_max(:,2) = quantile(V_reconstructed2',1-(1-confidence_limit)/2);
V_min(:,3) = quantile(V_reconstructed3',(1-confidence_limit)/2);
V_max(:,3) = quantile(V_reconstructed3',1-(1-confidence_limit)/2);
V_min(:,4) = quantile(V_reconstructed4',(1-confidence_limit)/2);
V_max(:,4) = quantile(V_reconstructed4',1-(1-confidence_limit)/2);
V_min(:,5) = quantile(V_reconstructed5',(1-confidence_limit)/2);
V_max(:,5) = quantile(V_reconstructed5',1-(1-confidence_limit)/2);








% for j = 1:length(tvec)
%     for k = 1:model.NH
%         S_min(j,k) = quantile(S_recon(j,k,i),(1-confidence_limit)/2);
%         S_max(j,k) = quantile(S_recon(j,k,i), 1-(1-confidence_limit)/2);
%     end
% 
%     for k=1:model.NV
%         V_min(j,k) = quantile(V_recon(j,k,i),(1-confidence_limit)/2);
%         V_max(j,k) = quantile(V_recon(j,k,i),1-(1-confidence_limit)/2);
%     end
% 
% end

end





