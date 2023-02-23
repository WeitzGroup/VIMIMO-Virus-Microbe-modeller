function area_transient(transient_id)
% add gray shading to the transient

tmphold = ishold(gca);
if ~tmphold
    hold on;
end

tmpy = ylim;
tmph = area([1 transient_id],[tmpy(2) tmpy(2)],tmpy(1),...
    'FaceColor',[.7 .7 .7],'LineStyle','none','HandleVisibility','off');
uistack(tmph,'bottom');
ylim(tmpy);

if ~tmphold
    hold off;
end

end