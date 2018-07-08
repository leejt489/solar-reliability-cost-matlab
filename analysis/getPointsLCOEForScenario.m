function [points,LCOE,solarStorageRatio,capitalCost,storageCapacity,solarCapacity] = getPointsLCOEForScenario(reliabilities,res,region,scenario,loadType)

[solarCost, storageCost, boSCost, oandMCost, term, discountRate, dailyLoad] = getBaselineEconomics(scenario);
[reliabilityFrontiers,points] = loadReliabilityFrontiers(res,region,loadType);

LCOE = zeros(size(points,1),length(reliabilities));
solarStorageRatio = zeros(size(LCOE));
capitalCost = zeros(size(LCOE));
storageCapacity = zeros(size(LCOE));
solarCapacity = zeros(size(LCOE));

% meanInsolation = zeros(size(points,1),1); %This will be in kWh/day

fprintf('\nStarting processing...\n');
s = '';
tic
for i = 1:size(points,1)
    if (toc > 1 || i == size(points,1))
        tic;
        fprintf(repmat('\b',1,length(s)));
        s = sprintf('Processing location %g of %g ...\r',i,size(points,1));
        fprintf(s);
    end
    lat = points(i,2);
    lon = points(i,1);
    try
        reliabilityFrontier = reliabilityFrontiers(getLatLonString(lat,lon));
    catch
        error('Error in location %g',i)
    end
    [LCOE(i,:),solarStorageRatio(i,:),capitalCost(i,:),storageCapacity(i,:),solarCapacity(i,:)] = calcLCOE(lat,lon,reliabilities,storageCost,solarCost,dailyLoad,boSCost,oandMCost,term,discountRate,reliabilityFrontier);
    %[~,meanInsolation(i)] = loadDailySolarData(lat,lon);
end