function [reliabilityFrontiers,points] = saveReliabilityFrontiers(res,region,loadType)

if (nargin < 3)
    loadType = 'constant';
end

if (~any(strcmp(loadType,{'constant','nightHeavy','dayHeavy','kitobo'})))
    error('Unrecognized load type %s',loadType);
end

points = getLonLatPoints(res,region);
reliabilities = getSampleReliabilities;
gridReliability = getGridReliability(points);

reliabilityFrontiers = containers.Map;
fprintf('\nStarting processing...\n');
s = '';
tic
for i = 1:size(points,1)
    if (toc > 0.5 || i == size(points,1))
        tic;
        fprintf(repmat('\b',1,length(s)));
        s = sprintf('Processing location %g of %g ...\r',i,size(points,1));
        fprintf(s);
    end
    
    lat = points(i,2);
    lon = points(i,1);
    keyString = getLatLonString(lat,lon);
    
    if (reliabilityFrontiers.isKey(keyString))
        if (~isnan(gridReliability(i)) && ~reliabilityFrontiers(keyString).isKey(gridReliability(i)))
            r = reliabilityFrontiers(keyString).keys;
            reliabilityFrontiers(keyString) = generateAndSaveHourReliabilityFrontier(lat,lon,[[r{:}]';gridReliability(i)],'m',loadType);
        end
        continue;
    end
    if (isnan(gridReliability(i)))
        r = reliabilities;
    else
        %r = [reliabilities;gridReliability(i)];
        r = reliabilities;
    end
    reliabilityFrontiers(keyString) = generateAndSaveHourReliabilityFrontier(lat,lon,r,'m',loadType);
end

save(sprintf('../data/reliabilityFrontiers_%s_%s_%s',loadType,lower(region),strrep(num2str(res),'.','_')),'points','reliabilityFrontiers');