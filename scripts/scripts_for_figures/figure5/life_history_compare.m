clear all;
clc;

%%
x=1:9;

load('./../SEIV70_00000_Dbeprt_1001/seed314L0_datasheet.mat');
beta(:,1) = median(chain(18000:end,6:14)) ;
r(:,1) = median(chain(18000:end,1:5)) ;
phi(:,1) = median(chain(18000:end,15:23)) ;
tau(:,1) = median(chain(18000:end,34:42)) ;


load('./../SEIV70_00000_Dbeprt_1001/seed1303L0_datasheet.mat');
beta(:,2) = median(chain(18000:end,6:14)) ;
r(:,2) = median(chain(18000:end,1:5)) ;
phi(:,2) = median(chain(18000:end,15:23)) ;
tau(:,2) = median(chain(18000:end,34:42)) ;



load('./../results/local/SEIV10_00002_Dbeprt_1001/seed106L0_datasheet.mat');
beta(:,3) = median(chain(8000:end,6:14)) ;
r(:,3) = median(chain(8000:end,1:5)) ;
phi(:,3) = median(chain(8000:end,15:23)) ;
tau(:,3) = median(chain(8000:end,34:42)) ;


% load('./../results/local/SEIV10_00000_bepr_1001/seed91L0_datasheet.mat');
% beta(:,4) = median(chain(8000:end,6:14)) ;
% r(:,4) = median(chain(8000:end,1:5)) ;
% phi(:,4) = median(chain(8000:end,15:23)) ;
% tau(:,4) = 0;%median(chain(8000:end,34:42)) ;

beta_onestep = [49, 75, 29.6, 0, 37.5, 102.4, 437, 93, 413.7];
r_onestep = [0.19, 0.23,0.24,0.28,0.26];
tau_onestep = [1.36,2.07,2.3,0,1.8, 1.5,2.1,1.42,2.0 ];
phi_onestep = [5.3,1.2,14,0,4.97,16,6.5,13,8];

beta(:,4) = beta_onestep;
r(:,4) = r_onestep;
tau(:,4) = tau_onestep;
phi(:,4) = log(phi_onestep .*1e-8)./log(10);

figure(1)
subplot(2,2,1)
bar(x,beta);
%legend('SEIVD','SEIVD \tau scaled by 1.414','SEIVD \tau scaled by 3', 'One-step','SEIV'  )
set(gca,'FontSize',20);
ylabel('beta (virions/cell)')


subplot(2,2,2)
bar(1:5,r);
%legend('SEIVD','SEIVD \tau scaled by 1.414','SEIVD \tau scaled by 3', 'SEIV', 'One-step' )
set(gca,'FontSize',20);
ylabel('r (cells/hr)')

subplot(2,2,3)
bar(x,tau);
%legend('SEIVD','SEIVD \tau scaled by 1.414','SEIVD \tau scaled by 3', 'SEIV', 'One-step' )
set(gca,'FontSize',20);
ylabel(' \tau (hr)')

subplot(2,2,4)
bar(x,phi);
legend('SEIVD','SEIVD \tau scaled by 1.414','SEIVD \tau scaled by 3', 'One-step' )
set(gca,'FontSize',20);
ylabel(' log_{10} \phi (ml/hr)')
