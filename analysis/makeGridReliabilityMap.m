res = 0.25;
region = 'africa';

folderName = sprintf('Figures');
if ~exist(folderName, 'dir')
    % Folder does not exist so create it.
    mkdir(folderName);
end

points = getLonLatPoints(res,region); %Africa lat lon samples at resolution
gridReliability = getGridReliability(points);

points2 = [];
gridReliability2 = [];
for i = 1:length(gridReliability)
    if (gridReliability(i) >= 0.8)
        points2 = [points2;points(i,:)];
        gridReliability2 = [gridReliability2;gridReliability(i)];
    end
end

figure;
titleText = sprintf('National grid reliability');
fname = sprintf('%s/map_%s_gridreliability',folderName,region);
colorLegend = 'Average Service Availability Index (ASAI)';
makeAndSaveMap(res,region,points(:,2),points(:,1),gridReliability,titleText,colorLegend,fname);

figure;
fname = sprintf('%s/map_%s_gridreliability_excluding',folderName,region);
makeAndSaveMap(res,region,points2(:,2),points2(:,1),gridReliability2,titleText,colorLegend,fname);