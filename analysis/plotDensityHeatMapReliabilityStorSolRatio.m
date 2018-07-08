function plotDensityHeatMapReliabilityStorSolRatio(solStorRatio,reliabilities,bins)

unmetLoad = 1-reliabilities;

[z, y] = hist(solStorRatio,bins);
z = z/size(solStorRatio,1);

pcolor(unmetLoad,y,z);

set(gca,'XLim',[1-max(reliabilities),1-min(reliabilities)])
set(gca,'XDir','reverse')
set(gca,'XScale','log')
set(gca,'XTick',[0.0001,0.001,0.01,0.1])
set(gca,'XTickLabel',1-get(gca,'XTick'))

xlabel('$FDS$','Interpreter','LaTex');
ylabel('Hours of storage','Interpreter','LaTex');
c = colorbar();
ylabel(c,'Density for reliability');

colormap(flipud(gray))
shading interp
shading flat