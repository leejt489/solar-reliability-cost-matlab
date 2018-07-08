function plotDensityHeatMapReliabilityCostDiff(costDiff,reliabilities,bins)

unmetLoad = 1-reliabilities;

if (nargin < 3)
    [z,y] = hist(costDiff);
else
    [z, y] = hist(costDiff,bins);
end
z = z/size(costDiff,1);

pcolor(unmetLoad,y,z);
set(gca,'XScale','log');
xlabel('$ESP = 1-FDS$','Interpreter','LaTex');
ylabel('Cost penalty','Interpreter','LaTex');
c = colorbar();
ylabel(c,'Density for reliability');

colormap(flipud(gray))
shading interp
shading flat