addpath('../core/')
res = 1;
points = getLonLatPoints(res); %Africa lat lon samples at resolution
reliabilities = getSampleReliabilities();
fprintf('\nStarting processing\n');
for i = 1:size(points,1)
    if (i>1)
        fprintf(repmat('\b',1,length(s)));
    end
    s = sprintf('%g of %g locations processed\r',i-1,size(points,1));
    fprintf(s);
    lat = points(i,2);
    lon = points(i,1);
    generateAndSaveHourReliabilityFrontier(lat,lon,reliabilities);
end