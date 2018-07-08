function [minCost, optStorage, optSolar, minPoint] = calcMinCost(storageCost,solarCost,dailyLoad,reliabilities,reliabilityFrontier)
%solarCost in units of $/kW
%storageCost in units of $/kWh
%Reliability frontier is always in units of 1 kWh/day
minCost = zeros(length(reliabilities),1);
optSolar = zeros(length(reliabilities),1);
optStorage = zeros(length(reliabilities),1);
minPoint = zeros(length(reliabilities),2);
points = zeros(length(reliabilities),2);
for i = 1:length(reliabilities)
    reliability = reliabilities(i);
    x = reliabilityFrontier(reliability)*dailyLoad;
    componentCosts = [x(:,1)*storageCost x(:,2)*(solarCost)];
    totalCosts = sum(componentCosts,2);
    [minCost(i), ind] = min(totalCosts);
    optSolar(i) = x(ind,2);
    optStorage(i) = x(ind,1);
    minPoint(i,:) = componentCosts(ind,:)';
end