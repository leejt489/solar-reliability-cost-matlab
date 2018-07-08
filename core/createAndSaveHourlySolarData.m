function insolation = createAndSaveHourlySolarData(lat,lon)
insolation = createHourlySolarData(lat,lon);
meanInsolation = mean(insolation);
folderName = getFolderName(lat,lon);
if ~exist(folderName, 'dir')
    % Folder does not exist so create it.
    mkdir(folderName);
end
fileName = sprintf('%s/hourlySolarData',folderName);
save(fileName,'insolation','lat','lon','meanInsolation');
end