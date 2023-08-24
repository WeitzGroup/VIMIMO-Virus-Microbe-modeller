clear all;
close all;
clc;

%redirect to supplementary figures plotting.
addpath(genpath('./..'));

%% S1 
debris_plot;

%% S2
CV_NE;

%% S3
gelman2;

%% S4
trace_plots_compare_V2;

%% S5
AIC_plot
