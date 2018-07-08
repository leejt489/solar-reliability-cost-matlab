function [points,LCOESolar,gridTariff,gridReliability] = calcLCOEGridReliability(res,region,scenario)

[reliabilityFrontiers,points] = loadReliabilityFrontiers(res,region);
%countryNames = getCountryNames(points);

[solarCost, storageCost, boSCost, oandMCost, term, discountRate, dailyLoad] = getBaselineEconomics(scenario);

gridTariff = getGridTariff(points,scenario);
gridReliability = getGridReliability(points);

LCOESolar = zeros(size(points,1),1);
solarStorageRatio = zeros(size(LCOESolar));

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
    if (isnan(gridReliability(i)))
        LCOESolar(i,:) = NaN;
        solarStorageRatio(i,:) = NaN;
        continue;
    end
    lat = points(i,2);
    lon = points(i,1);
    try
        reliabilityFrontier = reliabilityFrontiers(getLatLonString(lat,lon));
        [LCOESolar(i,:),solarStorageRatio(i,:)] = calcLCOE(lat,lon,gridReliability(i),storageCost,solarCost,dailyLoad,boSCost,oandMCost,term,discountRate,reliabilityFrontier);
    catch e
        disp(e);
        error('Error in location %g',i);
    end
end

