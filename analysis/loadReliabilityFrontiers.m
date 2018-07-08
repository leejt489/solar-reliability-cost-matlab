function [reliabilityFrontiers,points] = loadReliabilityFrontiers(res,region,loadType)

if (nargin < 3)
    loadType = 'constant';
end

if (~any(strcmp(loadType,{'constant','nightHeavy','dayHeavy','kitobo'})))
    error('Unrecognized load type %s',loadType);
end

try
    load(sprintf('../data/reliabilityFrontiers_%s_%s_%s',loadType,lower(region),strrep(num2str(res),'.','_')),'points','reliabilityFrontiers');
catch
    [reliabilityFrontiers,points] = saveReliabilityFrontiers(res,region,loadType);
end