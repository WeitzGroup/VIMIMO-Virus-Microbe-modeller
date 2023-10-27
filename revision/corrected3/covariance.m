clear all;
clc;

load('revised1001.mat');
close all;

chain_1 = chain(1:5:10000,:);
chain_2 = chain(10001:5:end,:);

num_var = 18;

figure(1)
for i = 1:num_var

    for j = 1:num_var

subplot(num_var,num_var,j+num_var*(i-1))
if i == j
    histogram(chain_1(:,j))
else
plot(chain_1(:,i),chain_1(:,j),'.'); 

end

    end

end
