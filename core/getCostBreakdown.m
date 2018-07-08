function [capitalCost, capitalCostPerWattDC, oAndMCost, solarCost, storageCost, boSCost, storageCapacity, solarCapacity, dailyLoad] = getCostBreakdown(lat,lon,reliabilities,scenario)

reliabilityFrontier = generateAndSaveHourReliabilityFrontier(lat,lon,reliabilities);
[solarUnitCost, storageUnitCost, boSCost, oAndMCost, term, discountRate, dailyLoad] = getBaselineEconomics(scenario);

[capitalCost, storageCapacity, solarCapacity] = calcMinCost(storageUnitCost,solarUnitCost,dailyLoad,reliabilities,reliabilityFrontier);

storageCost = storageCapacity*storageUnitCost;
solarCost = solarCapacity*solarUnitCost;
capitalCostPerWattDC = capitalCost./solarCapacity/1000;
end