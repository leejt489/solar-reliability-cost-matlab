function [gridPrice,reliability] = getGridDataForPoints(points)

[gridData,countryNames] = xlsread('countryCostReliability.xlsx');
countryNamesData = countryNames(2:end,1);
countryNamesPoints = getCountryNames(points);

gridPrice = zeros(size(points,1),1);
reliability = zeros(size(points,1),1);
for i = 1:length(countryNamesPoints)
    if isempty(countryNamesPoints{i}) || any(strcmpi(countryNamesPoints{i},{'spain','western sahara','morocco','algeria','tunisia','libya','egypt'}))
        continue;
    end
    found = false;
    for k = 1:length(countryNamesData)
        if (strcmpi(countryNamesData{k},countryNamesPoints{i}))
            gridPrice(i) = gridData(k,2);
            reliability(i) = gridData(k,10);
            found = true;
            break
        end
    end
    if (~found)
        disp(sprintf('Could not find %s',countryNamesPoints{i}));
    end
end