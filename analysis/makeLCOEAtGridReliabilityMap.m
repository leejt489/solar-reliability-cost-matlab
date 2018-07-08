function [f,axm] = makeLCOEAtGridReliabilityMap(res,region,scenario)

folderName = sprintf('Figures/%s',scenario);
if ~exist(folderName, 'dir')
    % Folder does not exist so create it.
    mkdir(folderName);
end

[points,LCOESolar,gridTariff] = calcLCOEGridReliability(res,region,scenario);

switch (lower(scenario))
    case ('ssatier5')
        x = 250;
    case ('ssatier5future')
        x = 250;
    case ('ssatier4')
        x = 100;
    case ('ssatier4future')
        x = 100;
end

% figure;
% titleText = sprintf('Cost of solar at grid reliability'); %g kWh per month',x);
% fname = sprintf('%s/map_%s_lcoegridreliability_%g',folderName,region,x);
% colorLegend = 'LCOE \$/kWh';
% makeAndSaveMap(res,region,points(:,2),points(:,1),LCOESolar,titleText,colorLegend,fname);

titleText = sprintf('Extra cost of solar at grid reliability'); %g kWh per month',x);
fname = sprintf('%s/map_%s_lcoediffgridreliability_%g',folderName,region,x);
colorLegend = 'Difference: (Solar - Grid) \$/kWh';
fprintf('Percentage of locations where LCOE of decentralized is less than grid: %g\n',mean(LCOESolar<=gridTariff));
fprintf('Percentage of locations where LCOE of decentralized is less than grid plus 0.05: %g\n',mean(LCOESolar<=gridTariff+0.05));
[f,axm] = makeMap(res,region,points(:,2),points(:,1),LCOESolar-gridTariff,titleText,colorLegend,1);

% s = getLocationShapes(region);
% cntrpoints = zeros(length(s),2);
% for i = 1:length(s)
%     cntrpoints(i,:) = round(mean(s(i).BoundingBox)*4)/4;
% end
% electrificationRate = getElectrificationRate(cntrpoints);
% h = stem3m(cntrpoints(:,2),cntrpoints(:,1),0.25*(1-electrificationRate),'r-','LineWidth',1.5);
% view(-20,45)
% if (length(fname) > 4 && strcmpi(fname(end-3:end),'.png'))
%     fname = fname(1:end-4);
% end
saveas(f,fname);
saveas(f,fname,'png');
