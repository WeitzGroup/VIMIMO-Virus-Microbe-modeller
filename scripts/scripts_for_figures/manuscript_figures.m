clc;
clear all;

%add all the paths
addpath(genpath('./..'))

% %here is figure 1
% cd('./figure1/')
% figure1;
% cd ..

%Here is Figure 3
cd('./figure3');
fig3_condifence;

cd('./..');

%Here is Figure 4
cd('./figure4')
fig4_condifence;

cd('./..');

%here is figure 5
cd('./figure5');
life_history_compare_new;
cd('./..');

cd('./figure1/')
fig1_parameters;
cd ..

cd('./figure2/');
figure3;

