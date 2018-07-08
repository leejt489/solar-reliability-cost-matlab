function deleted = clearReliabilityFrontier(lat,lon,loadType)

if (nargin < 3)
    loadType = 'constant';
end

lat = floor(lat); %Rounding reflects NASA data, round to ones
lon = floor(lon);

fileName = sprintf('%s/hourReliabilityFrontier_%sLoad.mat',getFolderName(lat,lon),loadType);
deleted = false;
if (exist(fileName,'file'))
    delete(fileName);
    deleted = true;
end