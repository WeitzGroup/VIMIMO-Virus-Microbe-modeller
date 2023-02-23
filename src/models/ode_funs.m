classdef ode_funs
    % every model is a subclass of ode_funs
    
    % ode_funs contains variations on particular parts of the core
    % virus-host differential equations (see properties)
    
	% to use a function handle inside an ode function of an ode_funs subclass, do:
	%   fun = obj.fun               %(this "unpacking" line is necessary)
	%   dX = fun(inputs) + ...
    
    properties
        host_growth = 0; % 0 = exponetial growth; 1 = global carrying capacity w/ niche competition
        viral_decay = 0; % 0 = no decay; 1 = exponential decay
        viral_adsorb = 0; % 0 = viruses only adsorb to their hosts; 1 = viruses may adsorb to any host
        lysis_reset = 0; % 0 = no lysis reset; 1 = adsorption by new virsues resets lytic cycle from I to first E class
        debris_inhib = 0; % 0 = no debris inhibition; 1 = build-up of dead cells inhibits infection (requires defining pars.Dc)
    end
    
    methods
        
        function mystr = odestr(obj)
            
            mystr = sprintf('%d%d%d%d%d',obj.host_growth,obj.viral_decay,obj.viral_adsorb,obj.lysis_reset,obj.debris_inhib);
        end
        
        function handle = exposed_transition_fun(obj)
            % output = dEmat2 (NH x NV x NE-1)
            % use depends on model structure, user does not interact with this ftn
            if obj.NE==1 % NE exists for every model subclass (if this throws an error, check subclass constructor)
               handle = @(etaeff,Emat) [];
           else
               handle = @(etaeff,Emat) etaeff.*Emat(:,:,1:end-1) - etaeff.*Emat(:,:,2:end);
           end
        end

        function handle = host_growth_fun(obj)
            % output = component of dS (NH x 1)
            if obj.host_growth==0
                handle = @(pars,S,N) pars.r.*S;
            else
                handle = @(pars,S,N) pars.r.*S.*(1-pars.a*N/pars.K);
            end
        end
        
        function handle = viral_decay_fun(obj)
            % output = component of dV (NV x 1)
            % also compatible with W state variable, then output = component of dW (NV x 1)
            if obj.viral_decay==0
                handle = @(pars,V) 0;
            else
                handle = @(pars,V) pars.m.*V;
            end
        end
         
        function handle = viral_adsorb_fun(obj)
            % output = adsorption matrix (NH x NV)
            % viral_adsorb_fun is only used in dV equation; assuming adsorption by non-specific viruses have no affect on hosts
            if obj.viral_adsorb==0
                handle = @(pars) pars.M.*pars.phi;
            else
                handle = @(pars) pars.phi;
            end
        end       

        function handle = lysis_reset_fun(obj)
            % output = component of dImat (to be subtracted) and dEmat (to be added) (NH x NV)
            if obj.lysis_reset==0
                handle = @(pars,Imat,OH,V) 0;
            else 
                viral_adsorb_fun = obj.viral_adsorb_fun;
                handle = @(pars,Imat,OH,V) pars.epsilon_reset.*viral_adsorb_fun(pars).*Imat.*(OH*V');
            end
        end
        
        function handle = debris_inhib_fun(obj)
            % output = scalar to be multiplied with state variable S
            if obj.debris_inhib==0
                handle = @(pars,D) 1;
            elseif obj.debris_inhib == 1
                handle = @(pars,D) 1/(1+D/pars.Dc)^2;
            elseif obj.debris_inhib == 2
                handle = @(pars,D) 1/(1+(D/pars.Dc)^2); %exponent corrected
            elseif obj.debris_inhib == 3
                handle = @(pars,D) 1/(1+(pars.Dc/D)^2); %exponent corrected and reciprocal

            end
        end
        
    end
    
end