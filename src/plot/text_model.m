function text_model(model)
% add model information to an existing figure
% todo - adds to current axes, make independent

tmpstr = sprintf('%s-%s',model.name,model.odestr());
text(-.3,0,tmpstr,'Units','normalized','Rotation',90,'HorizontalAlignment','center','Color','red');

end