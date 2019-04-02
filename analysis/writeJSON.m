function writeJSON(res,region,loadType)
    [reliabilityFrontiers,points] = loadReliabilityFrontiers(res,region,loadType);
    
    fId = fopen(sprintf('../data/reliabilityFrontiers_%s_%s_%s.json',loadType,lower(region),strrep(num2str(res),'.','_')),'w');
    fprintf(fId,'[');
    
    s = '';
    tic
    for i = 1:size(points,1)
        if (toc > 0.5 || i == size(points,1))
            tic;
            fprintf(repmat('\b',1,length(s)));
            s = sprintf('Writing JSON for location %g of %g ...\r',i,size(points,1));
            fprintf(s);
        end
        lat = points(i,2);
        lon = points(i,1);
        keyString = getLatLonString(lat,lon);
        rfNum = reliabilityFrontiers(keyString);
        numKeys = rfNum.keys;
        fprintf(fId,'{"lat":%g,"lon":%g,"rf":{',lat,lon);
        for j = 1:rfNum.Count
            vals = rfNum(numKeys{j});
            fprintf(fId,'"%f":{"stor":%s,"sol":%s}',numKeys{j},jsonencode(round(vals(:,1)*10^6)/10^6),jsonencode(round(vals(:,2)*10^6)/10^6));
            if (j < rfNum.Count)
                fprintf(fId,',');
            end
        end
        fprintf(fId,'}}');
        if (i < size(points,1))
            fprintf(fId,',');
        end
        
    end
    fprintf(fId,']');
end