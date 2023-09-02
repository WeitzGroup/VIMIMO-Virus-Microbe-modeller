%% clear everything
%%%%% This plan has failed -- do not add the error chains 

%%% why is this not working -- the new chain should have variances equal to
%%% the sum of the variances of the individual chains in the first place
%%% this happened as we actually averages them out
%%% I can very well increase the variance later.

%%% The ACF tests (probably need to do IAT) will fail for this one.


clc;
clear all;

%% load the data and the chains.

addpath(genpath('./..'));
begin_file = 20010;
end_file = 20021;
num_files = end_file - begin_file + 1;

chain_short = zeros(5000,44);
for i = begin_file:end_file

load('./../results/SEIVD-diff-all-seed'+string(i)+'.mat')
chain_short = chain_short + chain(5001:10000,:).^2;

end

chain_short = sqrt(chain_short/num_files);

plot(chain_short(:,1:5))

figure(2)
autocorr(chain(:,4),NumLags=4000)
% This does not work.