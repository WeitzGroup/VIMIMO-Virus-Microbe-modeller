classdef SIV < ode_funs
    % SIV requires NE=0 and lysis_reset=0 (code this in to prevent accidental changes??)
    
    properties
        name;
        statevars = ["S","I","V"];
        NH;
        NV;
        NE = 0;
        id;
    end
    
    methods
        
        function obj = SIV(NH,NV)
            obj.name = 'SIV';
            obj.NH = NH;
            obj.NV = NV;
            id.S = 1:NH;
            id.I = (1:NH*NV)+id.S(end);
            id.V = (1:NV)+id.I(end);
            id.D = 1+id.V(end); % debris
            id.Imat = reshape(id.I,[NH NV]);
            obj.id = id;
        end
        
        function vec = zeros(obj)
            %vec = zeros(obj.id.V(end),1);
            vec = zeros(obj.id.D,1);
        end
        
        function S = sum_hosts(obj,y) % all host cells including infected
            S = y(:,obj.id.S);
            for i = 1:obj.NH % could use bsxfun or arrayfun here?
               S(:,i) = S(:,i) + sum(y(:,obj.id.Imat(i,:)),2); 
            end
        end
        
        function V = sum_viruses(obj,y) % free phage only
           V = y(:,obj.id.V); 
        end
        
        function dydt = ode(obj,t,y,pars)
            
            OH = ones(obj.NH,1);
            OV = ones(obj.NV,1);
            S = y(obj.id.S);
            Imat = y(obj.id.Imat);
            V = y(obj.id.V);
            D = y(obj.id.D);  
            N = S+Imat*OV;
            
            host_growth_fun = obj.host_growth_fun;
            viral_decay_fun = obj.viral_decay_fun;
            viral_adsorb_fun = obj.viral_adsorb_fun; % only use in dV
            %lysis_reset_fun = obj.lysis_reset_fun; % no lysis reset for SIV model
            debris_inhib_fun = obj.debris_inhib_fun;
            
            Sdeb = S*debris_inhib_fun(pars,D); % debris

            dS = host_growth_fun(pars,S,N) - Sdeb.*((pars.M.*pars.phi)*V);
            dImat = (pars.M.*pars.phi).*(Sdeb*V') - pars.eta.*Imat;
            dV = (pars.beta.*pars.eta.*Imat)'*OH - V.*(viral_adsorb_fun(pars)'*N) - viral_decay_fun(pars,V);
            dD = sum(pars.eta(:).*Imat(:)); % sum across all pairs for net lysis rate
            
            dydt = [dS; dImat(:); dV; dD];
            
        end
    end
end

