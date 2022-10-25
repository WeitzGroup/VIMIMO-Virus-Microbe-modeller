% runtime examples for main.m on the cluster
% no difference in runtime for different ppn and pmem for non-parallelized code
% seems robust to changes in seed

steps = [1e2 5e2 1e3 5e3 1e4];

% model: LyticExposedMultiNoinfec_CarryDecay, NE=5
% latent period multiplier: x5
runtime = [27/60 4+1/60 7+48/60 24+24/60 46+27/60; % beta, log10(phi), p
    nan nan nan 16+27/60 33+50/60; % beta, log10(phi), p, epsilon(1)
    nan nan nan 45+30/60 1*60+32+17/60; % beta, log10(phi), p, epsilon(1), eta
    nan nan nan 25+35/60 43+39/60; % beta, log10(phi), p, epsilon(1,2)
];

legendstr = {'beta phi p','beta phi p epsilon(1)','beta phi p epsilon(1) eta','beta phi p epsilon(1,2)'};
titlestr = 'model: SEIVW with NE=5';

% model: LyticExposedMulti_CarryDecay, NE=5
% latent period multiplier: x5
runtime2 = [nan nan nan nan 3*60+53+51/60; % beta, log10(phi)
]; 

plot(steps,runtime,'o-','LineWidth',1.5);
hold on;
plot(steps,runtime2,'r*','MarkerSize',10,'LineWidth',1.5);
hold off;
lgd = legend(legendstr,'Location','NorthWest');
lgd.Title.String = 'parameters included';
title(titlestr);
xlabel('steps');
ylabel('runtime (minutes)');
set(gca,'FontSize',14);
grid on;


print('results/examples/runtime','-dpng');