function [storCap,solCap] = getSystemFixedRatio(lat,lon,storSolRatio,reliabilities,loadType)

storCap = zeros(size(reliabilities));
solCap = zeros(size(reliabilities));

lat = floor(lat); %Rounding reflects NASA data, round to ones
lon = floor(lon);

if (nargin < 5)
    loadType = 'constant';
end

insolation = [];
electricLoad = [];

for i = 1:length(reliabilities)
    try
        if (isempty(insolation)) 
            %Load the solar data, gets variables: insolation, meanInsolation
            insolation = loadHourlySolarData(lat,lon);
        end
        if (isempty(electricLoad))
            %Create the electric load vector. Only needs to be done once.
            createLoad = @(x) repmat(x,length(insolation)/24,1);
            switch loadType
                case 'constant'
                    electricLoad = createLoad(ones(24,1)/24);
                case 'nightHeavy'
                    electricLoad = createLoad(createNightHeavyHourlyLoadProfile);
                case 'dayHeavy'
                    electricLoad = createLoad(createDayHeavyHourlyLoadProfile);
                case 'kitobo'
                    electricLoad = createLoad(getKitoboHourlyLoad);
                otherwise
                    error('Unrecognized load type');
            end
        end
        
        solCap(i) = fzero(@(solCap) reliabilities(i) - calcReliabilityGeneral(insolation,electricLoad,solCap,solCap*storSolRatio),0);
        storCap(i) = solCap(i)*storSolRatio;
    catch e
        disp(e);
        error('Could not calculate reliability for lat: %g, lon: %g, reliability: %g',lat,lon,reliabilities(i));
    end
end

end