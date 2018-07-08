function [insolation, meanInsolation] = loadHourlySolarData(lat,lon)
folderName = getFolderName(lat,lon);
filePath = sprintf('%s/hourlySolarData.mat',folderName);

if (exist(filePath,'file'))
    load(filePath);
else
    createAndSaveHourlySolarData(lat,lon);
    load(filePath);
end