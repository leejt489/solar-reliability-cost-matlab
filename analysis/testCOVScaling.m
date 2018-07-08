reliabilities = getSampleReliabilities();
res = 1;
region = 'africa';
loadType = 'constant';

scenario = 'ssaTier5';
[~,LCOE1] = getPointsLCOEForScenario(reliabilities,res,region,scenario,loadType);
scenario = 'ssaTier5Future';
[~,LCOE2] = getPointsLCOEForScenario(reliabilities,res,region,scenario,loadType);

%%

std1 = std(LCOE1);
mean1 = mean(LCOE1);
cov1 = std1./mean1;

std2 = std(LCOE2);
mean2 = mean(LCOE2);
cov2 = std2./mean2;

plot(1-reliabilities,cov1,1-reliabilities,cov2);legend('current costs','future costs','Location','northwest');
set(gca,'XLim',[min(1-reliabilities),max(1-reliabilities)]);
set(gca,'XDir','reverse')
set(gca,'XScale','log')
set(gca,'XTickLabel',1-get(gca,'XTick'))
ylabel('Coefficient of variation')
xlabel('FDS')
title('Effect of cost scenario on variance in LCOE')
saveas(gcf,'Figures/testCOVScaling','png');