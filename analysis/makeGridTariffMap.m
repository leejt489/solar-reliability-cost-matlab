res = 1;
region = 'africa';
scenario = 'ssatier5';

folderName = sprintf('Figures/%s',scenario);
if ~exist(folderName, 'dir')
    % Folder does not exist so create it.
    mkdir(folderName);
end

points = getLonLatPoints(res,region); %Africa lat lon samples at resolution
countryNames = getCountryNames(points);
tariffs = getGridTariff(points,scenario);

switch (lower(scenario))
    case ('ssatier5')
        x = 250;
    case ('ssatier4')
        x = 100;
end
titleText = sprintf('Grid tariff at %g kWh per month',x);
fname = sprintf('%s/map_%s_grid_%g',folderName,region,x);
colorLegend = 'Tariff \$/kWh';
makeAndSaveMap(res,region,points(:,2),points(:,1),tariffs,titleText,colorLegend,fname);

