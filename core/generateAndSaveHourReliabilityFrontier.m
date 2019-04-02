function [reliabilityFrontierMapReturn,meanInsolation] = generateAndSaveHourReliabilityFrontier(lat,lon,reliabilities,overwrite,loadType)

lat = floor(lat); %Rounding reflects NASA data, round to ones
lon = floor(lon);

%'overwrite' can be:
%   m: merge with saved frontier, keeping previously calculated
%   o: merge with saved frontier, overwriting previously calculated
%   c: clear saved frontier
if (nargin < 4)
    overwrite = 'm';    
end
if (nargin < 5)
    loadType = 'constant';
end

%Load existing frontiers
fileName = sprintf('%s/hourReliabilityFrontier_%sLoad.mat',getFolderName(lat,lon),loadType);
if (exist(fileName,'file') && overwrite ~= 'c') %If clearing saved or there are no saved, no point in loading previous
    s = load(fileName,'reliabilityFrontierMap'); %file must contain 'frontierMap' variable
    reliabilityFrontierMap = s.reliabilityFrontierMap;
    if (~exist('reliabilityFrontierMap','var'))
        error('File %s does not contain variable reliability reliabilityFrontierMap',fileName);
    end
else
    reliabilityFrontierMap = containers.Map('KeyType','double','ValueType','any');
end

changed = false; %flag if the data has been changed. If it hasn't by the end, we don't need to save.
insolation = [];
meanInsolation = [];
electricLoad = [];

for reliability = reliabilities'
    if (reliabilityFrontierMap.isKey(reliability) && overwrite == 'm') %There is already a value, and 'overwrite' says to keep previously calculated, so don't generate a new one
        continue
    end
    try
        if (isempty(insolation)) 
            %Load the solar data, gets variables: insolation, meanInsolation
            insolation = loadHourlySolarData(lat,lon);
        end
        if (isempty(electricLoad))
            %Create the electric load vector. Only needs to be done once.
            electricLoad = createHourlyLoadProfile(loadType,length(insolation)/24);
        end
        
        %Calculate the reliability frontier
        [solCap, storCap, solCapD] = calculateReliabilityFrontier(reliability,insolation,electricLoad);
    catch e
        newException = MException('SolarReliabilityCost:generateAndSaveHourReliabilityFrontier:calculationFailed', ...
            'Could not calculate reliability for lat: %g, lon: %g, reliability: %g',lat,lon,reliability);
        newException = addCause(newException, e);
        throw(newException);
    end
    reliabilityFrontierMap(reliability) = [storCap, solCap, solCapD];
    changed = true;
end
if (changed)
    save(fileName,'reliabilityFrontierMap','meanInsolation');
end

%Only return the reliabilities that were requested
reliabilityFrontierMapReturn = containers.Map('KeyType','double','ValueType','any');
for reliability = reliabilities'
    reliabilityFrontierMapReturn(reliability) = reliabilityFrontierMap(reliability);
end
end