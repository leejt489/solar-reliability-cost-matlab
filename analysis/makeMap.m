function [f,ax] = makeMap(res,region,lat,lon,val,titleText,colorLegend,lineWidth)

if (numel(lat) ~= numel(lon))
    error('Lat and lon must have the same number of elements');
end
if (numel(lat) ~= numel(val))
    error('val must have the same number of elements as lat and lon');
end

if (res < 10^-3)
    error('Min resolution is 10^-3');
end
%lon = round(lon*10^3)*10^-3;
%lat = round(lat*10^3)*10^-3;

lonVec = min(lon):res:max(lon);
latVec = max(lat):-res:min(lat);
latMat = repmat(latVec',1,length(lonVec));
lonMat = repmat(lonVec,length(latVec),1);
Z = NaN(length(latVec),length(lonVec));
c = 0;
for i=1:length(latVec)
    for j=1:length(lonVec)
        t = val(abs(lon-lonVec(j)) < 10^-6 & abs(lat-latVec(i)) < 10^-6 );
        if (length(t) > 1)
            error('Something is wrong');
        end
        if (length(t) == 1)
            c = c+1;
            Z(i,j) = t;
        end
    end
end

s = getLocationShapes(region);
[s.Lat] = s.Y;
s = rmfield(s,'Y');
[s.Lon] = s.X;
s = rmfield(s,'X');

d = 10^-1;
%ax = worldmap([min(lat)-d,max(lat)+d],[min(lon)-d,max(lon)+d]); %Include a padding around boundary to make sure all patches shown
ax = axesm('MapProjection','sinusoid','MapLatLimit',[min(lat)-d,max(lat)+d],'MapLonLimit',[min(lon)-d,max(lon)+d]);

if (nargin > 4)
    title(titleText,'Interpreter','LaTex');
end
pcolorm(latMat,lonMat,Z);
if (nargin < 8)
    lineWidth = 2;
end
geoshow(s,'FaceAlpha',0,'LineWidth',lineWidth);
c = colorbar();
if (nargin > 6 && ~any(isnan(colorLegend)))
    ylabel(c,colorLegend,'Interpreter','LaTex');
end

axis off;
tightmap;
framem;
f = gcf;
end