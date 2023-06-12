function plot_confidence_interval(time_used,min,max,shade_density,colour)


time_2 = [time_used, fliplr(time_used)];
inBetween = [min, fliplr(max)];
fill(time_2, inBetween, colour,'FaceAlpha',shade_density,'LineStyle','none'); hold on;

end

