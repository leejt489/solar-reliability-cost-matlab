function shapes = getLocationShapes(location)
switch (lower(location))
    case 'africa'
        shapes = shaperead('../data/shapes/AfricaShapes/AfricanCountires.shp');
        ind = false(length(shapes),1);
        for i = 1:length(shapes)
            ind(i) = strcmpi(shapes(i).Land_Type,'Primary land');
        end
        shapes = shapes(ind);
    case 'sub-saharan africa'
        shapes = shaperead('../data/shapes/AfricaShapes/AfricanCountires.shp');
        ind = false(length(shapes),1);
        for i = 1:length(shapes)
            ind(i) = strcmpi(shapes(i).Land_Type,'Primary land');
        end
        shapes = shapes(ind);
    case 'hawaii'
        states = shaperead('usastatehi');
        for i = 1:length(states)
            if (strcmpi(states(i).Name,'Hawaii'))
                shapes = states(i);
                break;
            end
        end
        if(~exist('shapes','var'))
            error('Could not find shape for Hawaii');
        end
    otherwise
        error('Unsupported location');
end
end