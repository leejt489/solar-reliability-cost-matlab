function reliabilities = getGridReliability(points)
    [n,t] = xlsread('../data/countryCostReliability');
    t = t(:,1);
    t = t(2:end);
    countryNames = getCountryNames(points);
    reliabilities = zeros(size(points,1),1);
    for i = 1:length(countryNames)
        idx = strcmpi(countryNames(i),t);
        if ~any(idx)
            reliabilities(i) = NaN;
        else
            reliabilities(i) = n(idx,7);
        end
    end
end