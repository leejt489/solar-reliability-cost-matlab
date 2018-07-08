function [points,locationNames] = getLonLatPoints(res,location)

if (nargin<1)
    res = 1;
end
if (nargin<2)
    location = 'africa';
end
if (~isnumeric(res))
    error('res must be a number')
end

fName = sprintf('../data/lonlatpoints_%s_%s',location,strrep(num2str(res),'.','_'));
try 
    load(fName,'points','locationNames');
    return;
catch
end


shapes = getLocationShapes(location);
points = [];
locationNames = {};
for i = 1:length(shapes)
    if ((strcmpi(location,'africa') || strcmpi(location,'sub-saharan africa')) && any(strcmpi(shapes(i).COUNTRY,{'spain','western sahara','morocco','algeria','tunisia','libya','egypt'})))
        continue;
    end
    subShapeInd = [1 find(isnan(shapes(i).X)) length(shapes(i).X)];
    for j = 1:length(subShapeInd)-1
        if (subShapeInd(j) == subShapeInd(j+1))
            continue;
        end
        x = shapes(i).X(subShapeInd(j)+1:subShapeInd(j+1)-1);
        y = shapes(i).Y(subShapeInd(j)+1:subShapeInd(j+1)-1);
        longLineInd = find(sqrt(diff(x).^2+diff(y).^2)>2*res); %Need to find these because a line segement in the shape is longer than twice the resolution, so sampling at the endpoints could skip a midpoint (e.g. Namibia at res 1)
        while ~isempty(longLineInd) %not the most efficient but works
            midX = (x(longLineInd(1)+1)-x(longLineInd(1)))/2;
            midY = (y(longLineInd(1)+1)-y(longLineInd(1)))/2;
            x = [x(1:longLineInd(1)) x(longLineInd(1))+midX x(longLineInd(1)+1:end)];
            y = [y(1:longLineInd(1)) y(longLineInd(1))+midY y(longLineInd(1)+1:end)];
            longLineInd = find(sqrt(diff(x).^2+diff(y).^2)>2*res); %Need to find these because a line segement in the shape is longer than twice the resolution, so sampling at the endpoints could skip a midpoint (e.g. Namibia at res 1)
        end
        %Get the points for this subshape
        allx = zeros(4*length(x),1); ally = zeros(4*length(x),1);
        for k = 1:length(x)
            if ~any(allx == x(k) & ally == y(k))
                allx(4*k-3:4*k) = [ceil(x(k)/res)*res; ceil(x(k)/res)*res; floor(x(k)/res)*res; floor(x(k)/res)*res];
                ally(4*k-3:4*k) = [ceil(y(k)/res)*res; floor(y(k)/res)*res; ceil(y(k)/res)*res; floor(y(k)/res)*res];
            end
        end
        t = unique([allx,ally],'rows');
        newPoints = [];
        for p = min(t(:,1)):res:max(t(:,1))
            for q = min(t(:,2)):res:max(t(:,2))
                if any(t(:,1) > p & t(:,2) == q) && any(t(:,1) < p & t(:,2) == q) && any(t(:,1) == p & t(:,2) > q) && any(t(:,1) == p & t(:,2) < q)
                    newPoints = [newPoints;[p q]]; %#ok<AGROW>
                end
            end
        end
        newPoints = unique([t;newPoints],'rows');
        points = [points;newPoints]; %#ok<AGROW>
        if (isfield(shapes(i),'COUNTRY'))
            locationNames = [locationNames;repmat({lower(shapes(i).COUNTRY)},size(newPoints,1),1)]; %#ok<AGROW>
        end
    end
end
[points,indUnique] = unique(points,'rows');
locationNames = locationNames(indUnique);
save(fName,'points','locationNames');
%         if (strcmpi(location,'hawaii')) %special case to include small islands that are within this bounding box
%             bb = [-160.7 18.913;-154.81 22.3];
%         else
%             bb = shapes(i).BoundingBox;
%         end
%         minbb = floor(bb(1,:)/res)*res;
%         maxbb = ceil(bb(2,:)/res)*res;
%         pointsToAdd = zeros((maxbb(1)-minbb(1))*(maxbb(2)-minbb(2))/res^2+3,2);
%         j = 1;
%         for p = minbb(1):res:maxbb(1)
%             for q = minbb(2):res:maxbb(2)
%                 pointsToAdd(j,:) = [p q];
%                 j = j+1;
%             end
%         end
%         points = [points;pointsToAdd];
%     end
% else
%     minLon = 180;
%     maxLon = -180;
%     minLat = 90;
%     maxLat = -90;
%     for i = 1:length(shapes)
%         minLon = min(minLon,shapes(i).BoundingBox(1,1));
%         maxLon = max(maxLon,shapes(i).BoundingBox(2,1));
%         minLat = min(minLat,shapes(i).BoundingBox(1,2));
%         maxLat = max(maxLat,shapes(i).BoundingBox(2,2));
%     end
%     minLon = floor(minLon/res)*res-res;
%     maxLon = ceil(maxLon/res)*res+res;
%     minLat = floor(minLat/res)*res-res;
%     maxLat = ceil(maxLat/res)*res+res;
%     x = (minLon:res:maxLon)';
%     y = (minLat:res:maxLat)';
%     Xq = repmat(x',length(y),1);
%     Yq = repmat(y,1,length(x));
%     grid = false(length(y),length(x));
%     for i = 1:length(shapes)
%         if (~strcmpi(shapes(i).Geometry,'Polygon'))
%             continue
%         end
%         grid = grid | inpolygon(Xq,Yq,shapes(i).X,shapes(i).Y);
%     %     shape = shapes(i);
%     %     
%     %     if (strcmpi(shape.Land_Type,'Primary land') && ~any(strcmpi(shape.COUNTRY,{'spain','lesotho'}))) %Ignore Canary islands, and ignore Lesotho because it is encapsulated by S. Africa
%     %         points = [points; getSamplesInsideShape(shape,res)];
%     %     end
%     end
%     %points = unique(points,'rows');
%     % origGrid = grid;
%     % for i = 1:size(grid,1)
%     %     for j = 1:size(grid,2)
%     %         if (i == 1 && j ==1)
%     %             grid(i,j) = origGrid(i,j) || origGrid(i+1,j) || origGrid(i,j+1) || origGrid(i+1,j);
%     %         elseif (i == 1 && j > 1)
%     %             grid(i,j) = origGrid(i,j-1) || origGrid(i+1,j-1) || origGrid(i,j) || origGrid(i+1,j) || origGrid(i,j+1) || origGrid(i+1,j);
%     %         elseif (i > 1 && j == 1)
%     %             grid(i,j) = origGrid(i-1,j) || origGrid(i,j) || origGrid(i+1,j) || origGrid(i-1,j+1) || origGrid(i,j+1) || origGrid(i+1,j);
%     %         elseif (i == size(grid,2))
%     %         else
%     %             grid(i,j) = origGrid(i-1,j-1) || origGrid(i,j-1) || origGrid(i+1,j-1) || origGrid(i-1,j) || origGrid(i,j) || origGrid(i+1,j) || origGrid(i-1,j+1) || origGrid(i,j+1) || origGrid(i+1,j);
%     %         end
%     %     end
%     % end
%     grid = nlfilter(grid,[3 3],@(M) any(M(:)));
%     [yind,xind] = find(grid);
%     points = [x(xind) y(yind)];
% end
% points = unique(points,'rows');
% end
% 
% function points = getSamplesInsideShape(shape,res)
%     p = [shape.X', shape.Y'];
%     p(isnan(p(:,1)) | isnan(p(:,2)),:) = []; %Remove NaN elements
%     %Filter out points that are out of order, i.e. far apart.  This comes
%     %up for Madagascar.
%     a = diff(p);
%     d = find(sqrt(a(:,1).^2+a(:,2).^2)>=1,1);
%     filterIgnore = {'botswana','chad','congo drc','ethiopia','kenya','libya','mauritania','morocco','namibia','somalia','zambia'};
%     if (~isempty(d) && ~any(strcmpi(shape.COUNTRY,filterIgnore)))
%         if (strcmpi(shape.COUNTRY,'angola'))
%             d = 6817;
%         elseif (strcmpi(shape.COUNTRY,'egypt'))
%             d = 4002;
%         elseif (strcmpi(shape.COUNTRY,'south africa'))
%             d = 9702; %Keeps Swaziland inside.  Ignoring Lesotho above so as not to get duplicate points.
%         elseif (strcmpi(shape.COUNTRY,'tanzania'))
%             d = 7404;
%         elseif (strcmpi(shape.COUNTRY,'sudan'))
%             d = 4990;
%         else
%         end
%         %warning('Deleting %g of %g vectors from boundary of %s because they appear erroniously far apart. This is a known issue for many countries, and should work fine, but has not been rigorously tested.',size(p,1)-d,size(p,1),shape.COUNTRY);
%         p = p(1:d,:);
%     end
%     snap = @(t) res*floor(t/res);
%     xmin = snap(min(p(:,1))); xmax = snap(max(p(:,1)));
%     ymin = snap(min(p(:,2))); ymax = snap(max(p(:,2)));
%     xspan = xmax-xmin;
%     yspan = ymax-ymin;
%     k = 1;
%     samplePoints = zeros((xspan/res+1)*(yspan/res+1),2);
%     for i=xmin:res:xmax
%         for j=ymin:res:ymax
%             samplePoints(k,[1 2]) = [i j];
%             k = k+1;
%         end
%     end
%     in = inpolygon(samplePoints(:,1),samplePoints(:,2),p(:,1),p(:,2));
%     in = in & samplePoints(:,2) < 20;
%     points = samplePoints(in,:);
% end