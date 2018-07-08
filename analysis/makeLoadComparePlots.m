function makeLoadComparePlots(lat,lon,reliabilities)

dailyLoad = 10;

if (nargin < 3)
    reliabilities = getSampleReliabilities;
end
reliabilities = reliabilities(1:floor(length(reliabilities)/4)+1:length(reliabilities)); %Show only 4 reliabilities to illustrate

loadTypes = {'constant','kitobo','nightHeavy','dayHeavy'};
loadTypesTitles = {'Constant Load','Measured representative load','Load all at night','Load all during the day'};

ax = zeros(length(loadTypes),1);

figure;
for i = 1:length(loadTypes)
    ax(i) = subplot(2,2,i);
    hold all;
    loadType = loadTypes{i};
    frontier = generateAndSaveHourReliabilityFrontier(lat,lon,reliabilities,'m',loadType);
    for j = 1:length(reliabilities)
        r = reliabilities(j);
        points = frontier(r)*dailyLoad;
        plot(points(:,1),points(:,2));
    end
    title(loadTypesTitles{i});
    xlabel(sprintf('kWh Storage for %g kWh/day load',dailyLoad));
    ylabel(sprintf('kW Solar for %g kWh/day load',dailyLoad));
    if (i == 1)
        legend(cellfun(@num2str, num2cell(reliabilities), 'UniformOutput', false));
    end
end
linkaxes(ax);
set(gcf, 'Position', get(0, 'Screensize'));
saveas(gcf,sprintf('Figures/sol_stor_tradeoff_loadCompare_lat_%g_lon_%g.png',lat,lon));

figure;
for i = 1:length(loadTypes)
    ax(i) = subplot(2,2,i);
    hold all;
    loadType = loadTypes{i};
    frontier = generateAndSaveHourReliabilityFrontier(lat,lon,reliabilities,'m',loadType);
    for j = 1:length(reliabilities)
        r = reliabilities(j);
        points = frontier(r);
        plot(points(:,1)*dailyLoad,points(:,3));
    end
    title(sprintf('dSolar/dStorage, %s',loadTypesTitles{i}));
    xlabel(sprintf('kWh Storage for %g kWh/day load',dailyLoad));
    ylabel(sprintf('dSolar/dStorage (1/h) for %g kWh/day load',dailyLoad));
    if (i == 1)
        legend(cellfun(@num2str, num2cell(reliabilities), 'UniformOutput', false));
    end
end
linkaxes(ax);
set(gcf, 'Position', get(0, 'Screensize'));
saveas(gcf,sprintf('Figures/sol_stor_der_loadCompare_lat_%g_lon_%g.png',lat,lon));