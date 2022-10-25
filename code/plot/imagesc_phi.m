function fig = imagesc_phi(mcmcpars,pars2)
% plot phi matrix before and after mcmc

load('data/labels','labels','NH','NV');

X1 = log10(reshape(mcmcpars.phi.startval,size(pars2.phi))); % use starting values from mcmcpars struct
X2 = log10(pars2.phi);
X1(isinf(X1)) = 0;
X2(isinf(X2)) = 0;
Xlims = [min([X1(X1~=0); X2(X2~=0)]) max([X1(X1~=0); X2(X2~=0)])];

fig = figure();

subplot(1,4,1);
im = imagesc(X1,Xlims);
im.AlphaData = X1~=0;
set(gca,'YTick',1:NH,'YTickLabels',labels.host);
set(gca,'XTick',1:NV,'XTickLabels',labels.phage,'XTickLabelRotation',90);
ylabel('hosts');
xlabel('virses');
title('original');
%set(gca,'FontSize',12);
colorbar();

subplot(1,4,2);
im = imagesc(X2,Xlims);
im.AlphaData = X2~=0;
set(gca,'YTick',1:NH,'YTickLabels',labels.host);
set(gca,'XTick',1:NV,'XTickLabels',labels.phage,'XTickLabelRotation',90);
ylabel('hosts');
xlabel('virses');
title('after mcmc');
%set(gca,'FontSize',12);
colorbar();

tmpX = (X2-X1)/norm(X2,2);
tmpXlims = max(abs(tmpX(:)))*[-1 +1];
subplot(1,4,3);
im = imagesc(tmpX,tmpXlims);
im.AlphaData = tmpX~=0;
set(gca,'YTick',1:NH,'YTickLabels',labels.host);
set(gca,'XTick',1:NV,'XTickLabels',labels.phage,'XTickLabelRotation',90);
ylabel('hosts');
xlabel('virses');
title('percent change');
%set(gca,'FontSize',12);
colorbar();
colormap(gca,flip(redblue()));

subplot(1,4,4);
plot(X1(:),X2(:),'o');
tmpx = xlim;
tmpy = ylim;
tmpz = [min(tmpx(1),tmpy(1)) max(tmpx(2),tmpy(2))];
hold on;
plot(tmpz,tmpz,'k');
xlim(tmpz);
ylim(tmpz);
xlabel('original');
ylabel('after mcmc');

fig.Position(3:4) = fig.Position(3:4).*[2.7 .6];

end