function writeJSON(res,region,loadType)
    [reliabilityFrontiers,points] = loadReliabilityFrontiers(res,region,loadType);
    %struct('type','feature','geometry',struct('type','polygon','coordinates',{{[lon,lat],[lon+1,lat],[lon+1,lat+1],[lon,lat+1],[lon,lat]}}))
    %s = struct('type',{},'geometry',{},'properties',{});
    fId = fopen(sprintf('../data/reliabilityFrontiers_%s_%s_%s.json',loadType,lower(region),strrep(num2str(res),'.','_')),'w');
    fprintf(fId,'[');
    
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
        %f.type = 'feature';
        %f.geometry = struct('type','Polygon','coordinates',{{[lon,lat],[lon+res,lat],[lon+res,lat+res],[lon,lat+res],[lon,lat]}});
        %rfStr = containers.Map();
        rfNum = reliabilityFrontiers(keyString);
        numKeys = rfNum.keys;
        %for j = 1:rfNum.Count
        %    rfStr(sprintf('%f',numKeys{j})) = rfNum(numKeys{j});
        %end
        %f.properties = struct('rf',rfStr,'test','blah');
        %s(end+1) = f;
        fprintf(fId,'{"lat":%g,"lon":%g,"rf":{',lat,lon);
            %jsonencode({{[lon,lat],[lon+res,lat],[lon+res,lat+res],[lon,lat+res],[lon,lat]}}));
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
    %fc = struct('type','FeatureCollection','features',s);
    %gj = jsonencode(fc);
    
    %fprintf(fId,gj);
end