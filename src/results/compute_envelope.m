function tsenv = compute_envelope(model,mcmcpars,pars,chain,err,transient_id,p)

% 10 smallest errors and 10 largest errors and some in the middle
%{
[~,tmpid] = sort(err.vals(:,1));
tmpn = size(err.vals,1);
if tmpn>=30
    tmpr = randperm(tmpn-20,10)+10;
else % for local runs
    tmpr = 11:tmpn-10;
end
tmpid2 = [tmpid(1:10); tmpid(tmpr); tmpid(end-9:end)];
%}


n = size(chain,1)-transient_id;
%n = 100;
tmpid2 = randperm(size(chain,1)-transient_id,n)+transient_id;


% grab specified parameter sets and simulate timeseries
tvec = 0:0.05:15.75; % for better viz
tmpS = zeros(length(tvec),model.NH,length(tmpid2));
tmpV = zeros(length(tvec),model.NV,length(tmpid2));
for i = 1:length(tmpid2)
   tmppars = update_pars(pars,chain(tmpid2(i),:),mcmcpars); 
   [~,tmpS(:,:,i),tmpV(:,:,i)] = simulate_ode(model,tmppars,tvec,tmppars.S0,tmppars.V0);
   if rem(i,100)==0
       fprintf('%d of %d\n',i,n);
   end
end

% compute envelope
tsenv.t = tvec';
%{
tsenv.Smin = min(tmpS,[],3);
tsenv.Smax = max(tmpS,[],3);
tsenv.Vmin = min(tmpV,[],3);
tsenv.Vmax = max(tmpV,[],3);
%}

% which percentile to calculate
if ~exist('p','var')
    p = [5 95];
end

tsenv.Smin = quantile(tmpS,p(1),3);
tsenv.Smax = quantile(tmpS,p(2),3);
tsenv.Vmin = quantile(tmpV,p(1),3);
tsenv.Vmax = quantile(tmpV,p(2),3);

end