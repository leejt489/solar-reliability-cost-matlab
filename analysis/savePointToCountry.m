function countries = savePointToCountry(location)
if (nargin < 1)
    location = 'africa';
end
s = getLocationShapes(location);

%Make the bounding box around Africa
xmin = 720; xmax = -720; ymin = 360; ymax = -360;
for i = 1:length(s)
    bb = s(i).BoundingBox*4; %blow up the bounding box x4 for 0.25 degree resolution
    xmin = min(xmin,bb(1,1));
    xmax = max(xmax,bb(2,1));
    ymin = min(ymin,bb(1,2));
    ymax = max(ymax,bb(2,2));
end
xmin = floor(xmin)-1;xmax = ceil(xmax)+1;ymin = floor(ymin)-1;ymax = ceil(ymax)+1;

try
    error('blah');
    load('Data/pointToCountry','countries');
catch
    countries = cell(721,1441);
end

for r = ymin:ymax
    for c = xmin:xmax
        foundCountry = false;
        for k = 1:length(s)
            if (strcmpi(location,'africa') && any(strcmpi(s(k).COUNTRY,{'spain','western sahara','morocco','algeria','tunisia','libya','egypt'})))
                continue;
            end
            if inpolygon(c/4,r/4,s(k).X,s(k).Y) %Divide be 4 as each index represents 0.25 degrees
                countries{r+361,c+721} = lower(s(k).COUNTRY);
                foundCountry = true;
                break;
            end
        end
        if (~foundCountry)
            minD = Inf;
            for k = 1:length(s)
                if (strcmpi(location,'africa') && any(strcmpi(s(k).COUNTRY,{'spain','western sahara','morocco','algeria','tunisia','libya','egypt'})))
                    continue;
                end
                d = min(sqrt((s(k).X*4-c).^2+(s(k).Y*4-r).^2));
                if d < minD
                    minD = d;
                    countries{r+361,c+721} = lower(s(k).COUNTRY);
                end
            end
        end
    end
end

save('../data/pointToCountry','countries');