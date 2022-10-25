
function ss = ssfun(theta,data)
% algae sum-of-squares function
y0 = data.y (1,:); 
tvec=data.tvec;
[~,y_model] = prey_predator_fun(tvec,theta,y0);
H=data.y(:,1);
V=data.y(:,2);
Hmodel=y_model(:,1);
Vmodel=y_model(:,2);


ss = sum((Hmodel - H).^2+(Vmodel - V).^2);