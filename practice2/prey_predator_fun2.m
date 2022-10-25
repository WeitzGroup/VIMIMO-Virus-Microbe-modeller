
    function y = prey_predator_fun2(tvec,theta,y0)
            % integrate ode for a given model
            reltol = 1e-8;
            opts = odeset('RelTol',reltol);
            ode = @(t,y) obj.ode(t,y);
            y = ode45(@prey_predator_sys,tvec,y0,opts,theta);
end