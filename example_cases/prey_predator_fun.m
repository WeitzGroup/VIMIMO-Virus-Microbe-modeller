
    function [t, y] = prey_predator_fun(tvec,theta,y0)
            % integrate ode for a given model
            reltol = 1e-8;
            opts = odeset('RelTol',reltol);
            ode = @(t,y) obj.ode(t,y);
            [t, y] = ode45(@prey_predator_sys,tvec,y0,opts,theta);

end