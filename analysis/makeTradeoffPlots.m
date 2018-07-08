function makeTradeoffPlots(lat,lon,loadType,reliabilities,dailyLoad)
%lat = -4; lon = 28;
%lat = 36; lon = 4;
%lat = 21; lon = -157;
if (nargin < 3)
    loadType = 'constant';
end
if (nargin < 4)
    reliabilities = getSampleReliabilities;
end
if (nargin < 5)
    dailyLoad = 10;
end

frontier = generateAndSaveHourReliabilityFrontier(lat,lon,reliabilities,'m',loadType);

figure
hold all
s = {};
for i = 1:floor(length(reliabilities)/7)+1:length(reliabilities) %keep number of plots to lte 7
    r = reliabilities(i);
    points = frontier(r)*dailyLoad;
    plot(points(:,1),points(:,2));
    s = [s {num2str(r)}];
end
legend(s);
xlabel(sprintf('kWh Storage for %g kWh/day load',dailyLoad));
ylabel(sprintf('kW Solar for %g kWh/day load',dailyLoad));
title(sprintf('Solar, Storage, Reliability Tradeoff Lat=%g Lon=%g',lat,lon));
saveas(gcf,sprintf('Figures/sol_stor_tradeoff_%s_lat_%g_lon_%g.png',loadType,lat,lon));

figure
hold all
s = {};
for i = 1:floor(length(reliabilities)/7)+1:length(reliabilities) %keep number of plots to lte 7
    r = reliabilities(i);
    [fder, storageCapacity] = calcIsoreliabilityDSolDstor(lat,lon,r,loadType);
    plot(storageCapacity*dailyLoad,fder);
    s = [s {num2str(r)}];
end
legend(s);
xlabel(sprintf('kWh Storage for %g kW/day load',dailyLoad));
ylabel(sprintf('dSolar/dStorage (1/h) for %g kWh/day load',dailyLoad));
title(sprintf('dSolar/Storage for Reliability Tradeoff Lat=%g Lon=%g',lat,lon));
saveas(gcf,sprintf('Figures/sol_stor_der_%s_lat_%g_lon_%g.png',loadType,lat,lon));