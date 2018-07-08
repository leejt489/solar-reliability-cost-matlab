function [LCOE,storageSolarRatio,capitalCost,storageCapacity,solarCapacity] = calcLCOE(lat,lon,reliabilities,storageCost,solarCost,dailyLoad,BoSCost,oandMCost,term,discountRate,reliabilityFrontier)
if (nargin < 11)
    reliabilityFrontier = generateAndSaveHourReliabilityFrontier(lat,lon,reliabilities,'m','constant');
end
[minCost] = calcMinCost(storageCost,solarCost,dailyLoad,reliabilities,reliabilityFrontier);
capitalCost = minCost+BoSCost;
r = discountRate;
crf = (r*(1+r)^term)/(((1+r)^term)-1);
LCOE = (crf*capitalCost + oandMCost*capitalCost)/365/dailyLoad./reliabilities;
t = calcStorageSolarRatio(storageCost,solarCost,dailyLoad,reliabilities,reliabilityFrontier);
storageSolarRatio = t(:,2);
storageCapacity = t(:,3);
solarCapacity = t(:,4);
end