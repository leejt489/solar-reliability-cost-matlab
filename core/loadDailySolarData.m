function [insolation, meanInsolation, startDate] = loadDailySolarData(lat,lon)
folderName = getFolderName(lat,lon);
% startYear = 1995;
startYear = 2006;
startDate = datenum(startYear,1,1);
filePath = sprintf('%s/dailySolarData.mat',folderName);
if (exist(filePath,'file'))
    load(filePath);
else
    fetchAndSaveDailySolarData(lat,lon,startYear);
    load(filePath);
end