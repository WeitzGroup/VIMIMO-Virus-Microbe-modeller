clear all;
clc;


%just some settings for the inference process:
NH = 2;
NV = 1;

% do not change
flags.phi_entire_matrix = 0;
flags.ssfun_normalized = 0;
flags.tau_mult = 1;
flags.mcmc_algorithm = 1; % default is 1 ('dram')
flags.tau_new = 0;

% change to 1 if you want to see the scripts working,
% while running locally DO NOT turn ON the confidence_interval script --
% takes a long time.

flags.inference_script = 1;
flags.confidence_interval = 0;
flags.want_to_see_stats = 1;


%% add all files to path
addpath(genpath('./..'));

%% Settings for running the model

% 5 hosts 5 phages and 70ish number of boxes. Will change this later.
model = SEIVD_diff_NE(NH,NV,70);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;



% which of the variables to include in the inference process

include_pars = {'r','beta','phi','epsilon','tau'};


% if we want to include debris
if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3) 
    if ~exist('include_pars','var')
        include_pars = {};
    end
    include_pars{end+1} = 'Dc';
    %include_pars{end+1} = 'Dc2';
end

%if we want to include lysis reset -- for the paper not included
if model.lysis_reset == 1
    include_pars{end+1} = 'epsilon_reset';
end



% a seed is set just to check the code
seed = 30001;

% keeping it low so the code at least runs.
mcmcoptions.nsimu = 1000; 

% keeping the full chain, just for demo purposes of code review.
transient_id = 1;

%the regularizer in cost function was not used.
lambda = 0;

%% load the data, parameters etc.

%note: the datapath is already added, if it doesn't work (depending on your matlab version), just add the
%paths.


load('./HP1-multihost.mat','data'); % qpcr data

%parameters
pars1.NH = 2;
pars1.NV = 1;
pars1.r = [0.2;0.2];
pars1.beta = [44.3;54.2];
pars1.tau = [1.5,1.4];
pars1.eta = 1./pars.tau;
pars1.M = [1;
    1];
pars1.NE = [75;98];
pars1.phi = [16e-8;13e-8];
pars1.a = [1 1; 1 1];
pars1.K = 200000000;
pars1.epsilon = [1;1];
pars1.Dc = 6e6;
pars1.S0 = [];
pars1.V0 = data.ydata(1);

pars1.NE = pars.NE; %pars1 was historically created to deal with cases where there was missing values, 
% do not worry about this for code-review now pars and pars1 are the same


% controlling settings for debris inhibition
if (model.debris_inhib == 1 || model.debris_inhib == 2 || model.debris_inhib == 3)
    %pars1.Dc = 1e8;
    %pars1.Dc = 4389100;
    pars1.Dc = 3.9e6;
    pars_labels.Dc = "";
    pars_units.Dc = "1/ml";
    pars1.Dc2 = pars1.Dc;
    pars_labels.Dc2 = pars_labels.Dc;
    pars_units.Dc2 = pars_units.Dc;
end


% controlling settings for lysis reset (not used) 
if model.lysis_reset == 1
    pars1.epsilon_reset = 0.01;
    pars_labels.epsilon_reset = "";
    pars_units.epsilon_reset = "";
end

% finally fix the model with given number of boxes.
max_NE = round(max(max(pars.NE)));
model = SEIVD_diff_NE_diff_debris(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;


% this was used to modify latent periods to be longer, is not used, ignore
% for code review - the multiplication factor was set to 1 anyway.
pars1.tau = pars1.tau*flags.tau_mult;

% a change of variable was done to test inference priors, not needed for code review
pars1.eta(pars1.tau>0) = 1./pars1.tau(pars1.tau>0);



%% SEIVD -- load good priors

% I have better priors, i.e, some parameter values stored. Let us just load
% those parameters from the file -- which was obtained after approximate
% convergence.

% If I do not do this, you would not have good starting parameter values
% during the code review process.

% I am just giving you a posterior value from inference as a demo prior

load('./../res/inference_results/SEIVD_datasheet','pars2');

pars = pars2;
pars1 = pars2;
clear pars2;

%after loading I am just adding the Dc2 parameter.
pars1.Dc2 = pars1.Dc;
pars_labels.Dc2 = pars_labels.Dc;
pars_units.Dc2 = pars_units.Dc;

pars = pars1;

%% plotting an example fit.

tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model,pars1,tvec,pars1.S0,pars1.V0); % initial parameter set

figure(1)
for i=1:model.NH
plot(data.xdata,data.ydata(:,i),'*');hold on;plot(t1,S1(:,i),'-',LineWidth=2); %microbes
xlabel('Time (hours)');ylabel('Host (cells/ml)');set(gca,'Yscale','log'); ylim([1e5 1e8])
%title(['Points are from averaged experimental datasets, line is from simulated SEIV model' ...
    %' (N_E=10)'])
end

figure(2)
for i=1:model.NV
plot(data.xdata,data.ydata(:,i+5),'*');hold on;plot(t1,V1(:,i),'-',LineWidth=2); %virus
xlabel('Time (hours)');ylabel('Phage (cells/ml)');set(gca,'Yscale','log');
%title('Points are from averaged experimental datasets, line is from simulated SEIV model (N_E=10)')
end

%% now an example of inference
% do not run this locally if mcmcoptions.nsimu > 1000

if flags.inference_script == 1
inference_script;
end

%% plots, error

loglikefun(median(chain(:,:)),data,pars2,mcmcpars,model,0)
plot_timeseries2(model,t2,S2,V2); % mcmc result

%% playing and testing part
pars3 = pars2;
pars3.Dc = 1e15;
%pars3.Dc2 = 4e6;

[t3,S3,V3,D3] = simulate_ode(model,pars3,tvec,pars3.S0,pars3.V0); % initial parameter set
plot_timeseries2(model,t3,S3,V3); % mcmc result

figure(10)
subplot(2,2,1)
plot(t2,V2-V3);ylabel('V2-V3');xlabel('time');
subplot(2,2,2)
plot(t2,S2-S3);ylabel('S2-S3');xlabel('time');


%%


%[dirstr,flags] = get_dirstr('local',model,include_pars,flags);
dirstr = './../results';
filestr = sprintf('%s/SEIVD-diff-all-seed%d',dirstr,seed);
save(filestr);  


% at this point if you plot the chain you might just see straight lines
% with no variation -- that's okay -- as no samples were accepted.



%% finding confidence intervals

% WARNING -- DO NOT RUN THIS LOCALLY!! 
% IGNORE THIS FOR CODE REVIEW IF YOU LOVE YOUR TIME


% I have turned this off now, by flags.confidence_interval = 0


if flags.confidence_interval == 1
    load('./../res/inference_results/SEIVD_datasheet','chain'); %loading an actual chain
    transient_id_new = 1;
    confidence_interval = 0.95;
    [S_min,S_max,V_min,V_max] = find_confidence_interval_looped(chain,transient_id_new,mcmcpars,confidence_limit,model, pars2);
end

%% actual inference results after the pipeline.

% the inference process takes a long time, so we are just going to load the
% actual results after the inference.
%loading all the results.

load('./../res/inference_results/SEIVD_datasheet','S1','S2','S_max','S_median','S_min','V1','V2','V_max','V_median','V_min','chain','mcmcparam','mcmcpars','mcmcresults','t2');

%% some initial inference statistics 
% this part was hardly shown in the paper
% you may get an error if you run this as the folder does not exist.

if flags.want_to_see_stats == 1

% create save directory
[dirstr,flags] = get_dirstr('local',model,include_pars,flags);
filestr = sprintf('%s/seed%dL%.2g',dirstr,seed,max(log10(lambda),0));

if mcmcoptions.nsimu > 2
    figure_mcmc2
else
    sprintf("You have not run the chain, so can't plot the chain statistics.");
end

end

%% plots of the figure 4 -- the data, fit and confidence interval.
% load('triplicate_data.mat');
% time_2 = [t2', fliplr(t2')];
% linewidth = 2;
% 
% hf = figure(2)
% subplot(2,5,1)
% errorbar(time/60,mean(1e3*host1'),std(1e3*host1'),'o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
% set(gca, 'YScale', 'log');
% set(gca,'fontname','times')  % Set it to times
% ylim([1e5 1e8]);
%     xlim([0 16]);
%     xticks([0 2 4 6 8 10 12 14 16]);
%     set(gca,'FontSize',20);
%     axis('square');
%     yticks([1e5 1e6 1e7 1e8]);
% ylabel({'Host density';'(cells/ml)'});
% title('CBA 4','FontSize',18);
% inBetween = [S_min(:,1)', fliplr(S_max(:,1)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,S_median(:,1),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
% 
% 
% 
% 
% subplot(2,5,2)
% errorbar(time/60,mean(1e3*host2'),std(1e3*host2'),'o','MarkerSize',8,  'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255] );hold on;
% set(gca, 'YScale', 'log');
% set(gca,'fontname','times')  % Set it to times
% ylim([1e5 1e8]);
%     xlim([0 16]);
%    xticks([0 2 4 6 8 10 12 14 16]);
%     set(gca,'FontSize',20);
%     axis('square');
%     yticks([1e5 1e6 1e7 1e8]);
%     title('CBA 18','FontSize',18);
%     inBetween = [S_min(:,2)', fliplr(S_max(:,2)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,S_median(:,2),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
% 
% 
% 
% 
% subplot(2,5,3)
% errorbar(time/60,mean(1e3*host3'),std(1e3*host3'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
% set(gca, 'YScale', 'log');
% set(gca,'fontname','times')  % Set it to times
% ylim([1e5 1e8]);
%     xlim([0 16]);
%     xticks([0 2 4 6 8 10 12 14 16]);
%     set(gca,'FontSize',20);
%     axis('square');
%     yticks([1e5 1e6 1e7 1e8]);
% title('CBA 38','FontSize',18);
% inBetween = [S_min(:,3)', fliplr(S_max(:,3)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,S_median(:,3),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
% 
% 
% 
% subplot(2,5,4)
% errorbar(time/60,mean(1e3*host4'),std(1e3*host4'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
% set(gca, 'YScale', 'log');set(gca,'FontSize',20)
% set(gca,'fontname','times')  % Set it to times
% ylim([1e5 1e8]);
%     xlim([0 16]);
%   xticks([0 2 4 6 8 10 12 14 16]);
%   axis('square');
%     yticks([1e5 1e6 1e7 1e8]);
%     title('PSA H100','FontSize',18);
%     inBetween = [S_min(:,4)', fliplr(S_max(:,4)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,S_median(:,4),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
% 
% 
% 
% 
% subplot(2,5,5)
% errorbar(time/60,mean(1e3*host5'),std(1e3*host5'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
% set(gca, 'YScale', 'log');set(gca,'FontSize',20);
% set(gca,'fontname','times')  % Set it to times
% ylim([1e5 1e8]);
%     xlim([0 16]);
%     xticks([0 2 4 6 8 10 12 14 16]);
%     axis('square');
%     yticks([1e5 1e6 1e7 1e8]);
%     title('PSA 13-15','FontSize',18);
%     inBetween = [S_min(:,5)', fliplr(S_max(:,5)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,S_median(:,5),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
% 
% %xlabel("Time (hours)");
% %ylabel("Host density (cell/ml)");
% 
% 
% 
% 
% 
% 
% subplot(2,5,6)
% errorbar(time/60,mean(1e3*virus1'),std(1e3*virus1'),'o','MarkerSize',8,'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
% set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
% ylim([1e4 1e11]);
%     xlim([0 16]);
%    xticks([0 2 4 6 8 10 12 14 16]);
%     set(gca,'FontSize',20);
%     axis('square');
%     yticks([1e4 1e6 1e8 1e10]);
% ylabel({'Phage density';'(virions/ml)'});
% title('\phi 18:2','FontSize',18);
%     inBetween = [V_min(:,1)', fliplr(V_max(:,1)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,V_median(:,1),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
% 
% subplot(2,5,7)
% errorbar(time/60,mean(1e3*virus2'),std(1e3*virus2'),'o','MarkerSize',8,  'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255] );hold on;
% set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
% ylim([1e4 1e11]);
%     xlim([0 16]);
%   xticks([0 2 4 6 8 10 12 14 16]);
%     set(gca,'FontSize',20);
%     axis('square');
%     yticks([1e4 1e6 1e8 1e10]);
%     title('\phi 18:3','FontSize',18);
%     inBetween = [V_min(:,2)', fliplr(V_max(:,2)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,V_median(:,2),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
% 
% 
% 
% 
% subplot(2,5,8)
% errorbar(time/60,mean(1e3*virus3'),std(1e3*virus3'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
% set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
% ylim([1e4 1e11]);
%     xlim([0 16]);
%   xticks([0 2 4 6 8 10 12 14 16]);
%     set(gca,'FontSize',20);
%     axis('square');
%    yticks([1e4 1e6 1e8 1e10]);
%    title('\phi 38:1','FontSize',18);
%     inBetween = [V_min(:,3)', fliplr(V_max(:,3)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,V_median(:,3),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
% 
% subplot(2,5,9)
% errorbar(time/60,mean(1e3*virus4'),std(1e3*virus4'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
% set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
% ylim([1e4 1e11]);
%     xlim([0 16]);
%    xticks([0 2 4 6 8 10 12 14 16]);
%     set(gca,'FontSize',20);
%     axis('square');
%    yticks([1e4 1e6 1e8 1e10]);
%    title('PSA HP1','FontSize',18);
%     inBetween = [V_min(:,4)', fliplr(V_max(:,4)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,V_median(:,4),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
% 
% 
% 
% 
% subplot(2,5,10)
% errorbar(time/60,mean(1e3*virus5'),std(1e3*virus5'),'o','MarkerSize',8, 'MarkerEdgeColor','k','MarkerFaceColor',[70/255,130/255,180/255]);hold on;
% set(gca, 'YScale', 'log');set(gca,'fontname','times')  % Set it to times
% ylim([1e4 1e11]);
%     xlim([0 16]);
%  xticks([0 2 4 6 8 10 12 14 16]);
%     set(gca,'FontSize',20);
%     axis('square');
%   yticks([1e4 1e6 1e8 1e10]);
%   title('PSA HS6','FontSize',18);
%     inBetween = [V_min(:,5)', fliplr(V_max(:,5)')];
%     fill(time_2, inBetween, [0.8 0.8 0.8],'FaceAlpha',0.5,'LineStyle','none');
%     plot(t2,V_median(:,5),'--','Color',[1 1 1]*.5,'LineWidth',linewidth);
%  legend('Data','95% confidence interval','Bayesian fit');
%  legend('Box','off');
% 
% han=axes(hf,'visible','off'); 
% han.Title.Visible='on';
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% set(gca,'FontSize',20);
% set(gca,'fontname','times')  % Set it to times
% xlabel("Time (hours)");
% 
 
