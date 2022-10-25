classdef prey_predator
    %MODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        alpha;
        beta;
        gamma;
        delta;
    end
    
    methods
        function obj = prey_predator(alpha,beta,gamma,delta)
            %MODEL Construct an instance of this class
            %  naming the 4 parameters of the model
            obj.alpha = alpha;
            obj.beta = beta;
            obj.gamma = gamma;
            obj.delta = delta;
        end
        

        function dydt = ode(obj,t,y)
            H = y(1);
            V = y(2);

            dH = H.*(obj.alpha)-obj.beta.*H.*V;
            dV = obj.delta*H.*V - obj.gamma.*V;
            dydt = [dH; dV];
        end



        function [t, H, V] = simulate(obj,tvec,H0,V0)
            % integrate ode for a given model
            y0 = [H0; V0];
            reltol = 1e-8;
            opts = odeset('RelTol',reltol);
            ode = @(t,y) obj.ode(t,y);
            [t, y] = ode45(ode,tvec,y0,opts);
            H = y(:,1);
            V = y(:,2); 
        end


        %function ss = ssfun


    end
end

