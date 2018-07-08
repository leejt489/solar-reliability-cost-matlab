function insolation = fetchAndSaveDailySolarData(lat,lon,startYear)
insolation = fetchSolarData(lat,lon,startYear);
meanInsolation = mean(insolation);
folderName = getFolderName(lat,lon);
if ~exist(folderName, 'dir')
    % Folder does not exist so create it.
    mkdir(folderName);
end
fileName = sprintf('%s/dailySolarData',folderName);
save(fileName,'insolation','lat','lon','meanInsolation');
end