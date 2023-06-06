
![alt text]([https://github.com/RaunakDey/VIMIMO-Virus-Microbe-modeller/](https://github.com/RaunakDey/VIMIMO-Virus-Microbe-modeller/tree/main/res/logo.png)


# Community model for virus microbe interactions

 Please note that our project is in beta phase and constantly updating. In our final version we aim to include a dictionary of mechanistic non-linear models to perform both predictive analysis as well as inference on population time series of viruses and microbes.

 test


 ## Welcome to VIMIMO: a <u>VI</u>rus <u>MI</u>crobe <u>MO</u>deller package

 * VIMIMO detects the interaction between viruses and microbes from the time series sampled from the same ecosystem. [NB: This approach may not be accurate, so if interaction matrix is known use that a prior]
 * It provides standard models of Biological interactions following a top-down approach from example cases of interactions, collected from years of research.
 * You can manually turn on/off parts of models which is applicable to your system. If you have no idea you can tell the package to look for feasible models. If you already have some idea use that to turn on/off different features.
 * Given your model you can create Bayesian inference schemees to extract parameters out of your model.
 * In a multimodel inference scheme you can compare between models using a model validation pipeline

 ## Tutorials

 Tutorials to use this can be found in the example folder. To run this pipeline you have to use the mcmcstat code, for which a package has not been published. So we are just going to clone it in our repository. 
 ```
 git clone git@github.com:mjlaine/mcmcstat.git
 ```
 Here is a minimalistic example. First specify the model used in the inference protocol. Here we show a SEIV model with 5 host, 5 phages and 70 latent compartments for each combinations. (Note, these numbers can be varied for each interaction). 

 ```matlab
 model = SEIV_diff_NE(5,5,70);

include_pars = {'r','beta','phi','epsilon','tau'};
if model.debris_inhib == 1 || 2 || 3
    include_pars{end+1} = 'Dc';
end

if model.lysis_reset == 1
    include_pars{end+1} = 'epsilon_reset';
end
```
 Load the data and parameter values,
 ```matlab
load('data/qpcr','data'); % qpcr data
load('data/parameters_example','pars'); % parameters without nans
pars1 = pars;
load('data/parameters'); % true parameter set with nans
 ```
 
 If different number of latent compartments are needed to model the data, the parameter can be changed, such as 
 ```matlab
 pars.NE = 10*(pars.M == 1);
pars.NE(i,j) = ##input list here
 ```
Before the inference protocol include the settings of the model and inference parameters 
```matlab
flags.phi_entire_matrix = 0;
flags.ssfun_normalized = 0;
flags.tau_mult = 1;
flags.mcmc_algorithm = 1; % default is 1 ('dram')
flags.inference_script = 1;
flags.confidence_interval = 0;
flags.tau_new = 0;

mcmcoptions.nsimu = 10000;
transient_id = 1;
lambda = 0;

max_NE = round(max(max(pars.NE)));
model = SEIV_diff_NE(5,5,max_NE);
model.host_growth = 0;
model.viral_decay = 0;
model.viral_adsorb = 0;
model.lysis_reset = 0;
model.debris_inhib = 2;
```
To include the the inhibition of lysis, use the following settings.
```matlab
% controlling settings for debris inhibition
if model.debris_inhib == 1 || 2 || 3
    %pars1.Dc = 1e8;
    %pars1.Dc = 4389100;
    pars1.Dc = 3.9e6;
    pars_labels.Dc = "";
    pars_units.Dc = "1/ml";
end


% controlling lysis 
if model.lysis_reset == 1
    pars1.epsilon_reset = 0.01;
    pars_labels.epsilon_reset = "";
    pars_units.epsilon_reset = "";
end
```

To run the forward model and inference scheme, use
```matlab
pars1.tau(pars1.tau>0) = 1./pars1.eta(pars1.tau>0);
tvec = 0:0.05:15.75; % for better viz
[t1,S1,V1,D1] = simulate_ode(model,pars1,tvec,pars1.S0,pars1.V0); % initial parameter set

%% inference

if flags.inference_script == 1
    inference_script;
end

```



 ## Contributors

 * The dataset included (for now) is from the [Sullivan lab](https://u.osu.edu/viruslab/) at The Ohio State University. 
 * The models build for this project are primarily build by the members of the [Weitz group](https://weitzgroup.biosci.gatech.edu) at Georgia Institute of Technology.
 * Additionally, we are working on creating a library of VIrus MIcrobe interaction MOdels, if you want to contribute, contact Raunak Dey at rdey33@gatech.edu 

 ## Features

 ### On Modelling side

 * Succeptible, Exposed and Infected compartmental model for viruses and microbes
 * Additional lysis inhibition mechanism -- effective change in adsoption due to debris, virus attaching to debris with certain probability, lysis reset due to multiple infections.

 ### On inference

 * DRAM - MCMC based pipeline for parameter inference
 * AIC based model testing 
 * Robustness and sensitivity of parameter testing
 

