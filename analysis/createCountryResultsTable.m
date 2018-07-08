res = 1;
reliabilities = getSampleReliabilities;
region = 'africa';
loadType = 'constant';

scenarios = {'ssaTier5','ssatier5future'};

for j = 1:length(scenarios)
    
    scenario = scenarios{j};

    [points,locationNames] = getLonLatPoints(res);
    [points2,LCOE,reliabilities,t1,rsq1,residuals1,t2,rsq2,residuals2] = fitReliabilityModel(res,region,scenario,loadType);
    [points3,LCOESolar,gridTariff] = calcLCOEGridReliability(res,region,scenario);
    [points4,LCOETier5] = getPointsLCOEForScenario(0.95,res,region,scenario,loadType);
    LCOEDiff = LCOESolar-gridTariff;
    if (sum(sum(points ~= points2)) > 0)
        error('The arrays of points are not equal');
    end
    if (sum(sum(points ~= points3)) > 0)
        error('The arrays of points are not equal');
    end
    if (sum(sum(points ~= points4)) > 0)
        error('The arrays of points are not equal');
    end

    countryNames = unique(locationNames);
    N = length(countryNames);
    meana_i = zeros(N,1);
    stda_i = zeros(N,1);
    meanCountryLCOE = zeros(N,1);
    stdCountryLCOE = zeros(N,1);
    meanDiff = zeros(N,1);
    stdDiff = zeros(N,1);
    for i = 1:length(countryNames)
        countryName = countryNames{i};
        ind = ismember(locationNames,countryName);
        countrya_i = t1(1,ind);
        meana_i(i) = mean(countrya_i);
        stda_i(i) = std(countrya_i);
        meanCountryLCOE(i) = mean(LCOETier5(ind));
        stdCountryLCOE(i) = std(LCOETier5(ind));
        meanDiff(i) = mean(LCOEDiff(ind));
        stdDiff(i) = std(LCOEDiff(ind));
    end
    
    if (j == 1)
        headers = {'Current LCOE_solar - grid tariff (mean)',...
            'Current LCOE_solar - grid tariff (std)',...
            'Current decentralized Tier 5 LCOE (mean)',...
            'Current decentralized Tier 5 LCOE (std)',...
            'Current reliability premium (mean)',...
            'Current reliability premium (std)'};
        dat = [{'Country'}; countryNames];
    elseif (j == 2)
        headers = {'Future LCOE_solar - grid tariff (mean)',...
            'Future LCOE_solar - grid tariff (std)',...
            'Future decentralized Tier 5 LCOE (mean)',...
            'Future decentralized Tier 5 LCOE (std)',...
            'Future reliability premium (mean)',...
            'Future reliability premium (std)'};
    end

    dat = [dat [headers;num2cell([meanDiff,stdDiff,meanCountryLCOE,...
        stdCountryLCOE,meana_i,stda_i])]];
end
xlswrite('Data/countryResultsTable.xlsx',dat)