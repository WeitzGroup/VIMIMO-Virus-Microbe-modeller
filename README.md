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

Tutorials to use this can be found in the example folder.

## Datasets and modelling

* The dataset included (for now) is from the [Sullivan lab](https://u.osu.edu/viruslab/) at The Ohio State University. 
* The models build for this project are primarily build by the members of the [Weitz group](https://weitzgroup.biosci.gatech.edu) at Georgia Institute of Technology. 

## Features

### On Modelling side

* Succeptible, Exposed and Infected compartmental model for viruses and microbes
* Additional lysis inhibition mechanism -- effective change in adsoption due to debris, virus attaching to debris with certain probability, lysis reset due to multiple infections.

### On inference
 
* DRAM - MCMC based pipeline for parameter inference
* AIC based model testing 
* Robustness and sensitivity of parameter testing


