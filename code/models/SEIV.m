classdef SEIV < ode_funs
    
    properties
        name;
        statevars = ["S","E","I","V"];
        NH;
        NV;
        NE;
        id;
    end
    
    methods
        
        function obj = SEIV(NH,NV,NE)
            obj.name = sprintf('SEIV%d',NE);
            obj.NH = NH;
            obj.NV = NV;
            obj.NE = NE;
            id.S = 1:NH;
            id.E = (1:NH*NV*NE)+id.S(end);
            id.I = (1:NH*NV)+id.E(end);
            id.V = (1:NV)+id.I(end);
            id.D = 1+id.V(end); % debris
            id.Emat = reshape(id.E,[NH NV NE]);
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
               S(:,i) = S(:,i) + sum(y(:,obj.id.Emat(i,:)),2) + sum(y(:,obj.id.Imat(i,:)),2); 
            end
        end
        
        function V = sum_viruses(obj,y) % free phage only
           V = y(:,obj.id.V); 
        end
        
        function dydt = ode(obj,t,y,pars)
            
            OH = ones(obj.NH,1);
            OV = ones(obj.NV,1);
            S = y(obj.id.S);
            Emat = y(obj.id.Emat);
            Imat = y(obj.id.Imat);
            V = y(obj.id.V);
            D = y(obj.id.D);
            N = S+sum(Emat,3)*OV+Imat*OV;
            etaeff = pars.eta*(obj.NE+1);

            exposed_transition_fun = obj.exposed_transition_fun;
            host_growth_fun = obj.host_growth_fun;
            viral_decay_fun = obj.viral_decay_fun;
            viral_adsorb_fun = obj.viral_adsorb_fun; % only use in dV
            lysis_reset_fun = obj.lysis_reset_fun;
            debris_inhib_fun = obj.debris_inhib_fun;
                  
            Sdeb = S*debris_inhib_fun(pars,D); % debris
            
            dS = host_growth_fun(pars,S,N) - Sdeb.*((pars.M.*pars.phi)*V);
            dEmat = (pars.M.*pars.phi).*(Sdeb*V') - etaeff.*Emat(:,:,1) + lysis_reset_fun(pars,Imat,OH,V);
            dEmat2 = exposed_transition_fun(etaeff,Emat);
            dImat = etaeff.*Emat(:,:,end) - etaeff.*Imat - lysis_reset_fun(pars,Imat,OH,V);
            dV = (pars.beta.*etaeff.*Imat)'*OH - V.*(viral_adsorb_fun(pars)'*N) - viral_decay_fun(pars,V);
            dD = sum(etaeff(:).*Imat(:)); % sum across all pairs for net lysis rate
            
            dydt = [dS; dEmat(:); dEmat2(:); dImat(:); dV; dD];
            
        end
    end
end

