%% Example of running the cost of reliabiltity model
% This is structured to be run from the 'analysis' directory of the
% software
addpath('../core');
%% Generate reliability frontiers
% Pick your location and the reliabilities you want
lat = 27;
lon = 77;
reliabilities = [0.9;.95;.99];
loadType = 'saGrid';
overwrite = 'm';
reliabilityFrontiers = generateAndSaveHourReliabilityFrontier(lat,lon,reliabilities,overwrite,loadType);

%% Plot ISO reliability curves
for i = 1:length(reliabilities)
    r = reliabilities(i);
    rf = reliabilityFrontiers(r);
    storCap = rf(:,1);
    solCap = rf(:,2);
    plot(storCap,solCap,'color',rand(1,3))
    hold on
end
legend('0.9','0.95','0.99')

%% Calculate LCOE
% Economic parameters. See 'calculateBaselineEconomics' or the Nature
% Energy paper for examples of how these should be developed and how to
% incorporate technical parameters like solar derating, peak demand, and
% battery lifetime into the costs
storageCost = 450; % $/kWh
solarCost = 1200; % $/kW
dailyLoad = 8.2; % kWh per day
BoSCost = 2600; % $/W,
oandMCost = 0.05; % per unit capital cost
term = 20; % years
discountRate = 0.05; % per unit per year

[LCOE,storageSolarRatio,capitalCost,storageCapacity,solarCapacity] = calcLCOE(lat,lon,reliabilities,storageCost,solarCost,dailyLoad,BoSCost,oandMCost,term,discountRate,reliabilityFrontiers);

%% Solar Data
solarData = loadDailySolarData(lat,lon);
figure;
plot(solarData);
title('Daily solar data');