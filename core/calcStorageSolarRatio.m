function points = calcStorageSolarRatio(storageCost,solarCost,dailyLoad,reliabilities,reliabilityFrontier)
N = length(reliabilities);
points = zeros(N,4);
for i = 1:N
    [~, optStorage, optSolar] = calcMinCost(storageCost,solarCost,dailyLoad,reliabilities(i),reliabilityFrontier);
    points(i,:) = [reliabilities(i) optStorage/optSolar optStorage optSolar];
end