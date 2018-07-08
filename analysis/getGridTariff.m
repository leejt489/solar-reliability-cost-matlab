function tariffs = getGridTariff(points,scenario)
    if (nargin < 2)
        scenario = 'ssatier5';
    end
    
    switch (scenario)
        case ('ssatier5')
            colIdx = 2;
        case ('ssatier4')
            colIdx = 1;
        otherwise
            colIdx = 2;
    end
    [n,t] = xlsread('countryCostReliability');
    t = t(:,1);
    t = t(2:end);
    countryNames = getCountryNames(points);
    tariffs = zeros(size(points,1),1);
    for i = 1:length(countryNames)
        idx = strcmpi(countryNames(i),t);
        if ~any(idx)
            tariffs(i) = NaN;
        else
            tariffs(i) = n(idx,colIdx);
        end
    end
end