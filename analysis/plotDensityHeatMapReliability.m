function plotDensityHeatMapReliability(LCOE,reliabilities,bins,t2)

unmetLoad = 1-reliabilities;

[z, y] = hist(LCOE',bins);
z = z/size(LCOE,2);

pcolor(unmetLoad,y,z);

%Make it the log scale
set(gca,'XLim',[1-max(reliabilities),1-min(reliabilities)])
set(gca,'XDir','reverse')
set(gca,'XScale','log')
set(gca,'XTick',[0.0001,0.001,0.01,0.1])
set(gca,'XTickLabel',1-get(gca,'XTick'))

xlabel('$FDS$','Interpreter','LaTex');
ylabel('LCOE \$/kWh','Interpreter','LaTex');
title('Cost of reliability density','Interpreter','LaTex');
c = colorbar();
ylabel(c,'Density for reliability');

colormap(flipud(bone))
shading interp
shading flat

hold on;
plot(unmetLoad,(t2(1)*log10(unmetLoad)+t2(2))./reliabilities+t2(3),'--k','LineWidth',2)