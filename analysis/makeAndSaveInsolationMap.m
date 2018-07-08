function makeAndSaveInsolationMap(res,region)

points = getLonLatPoints(res,region);
meanInsolation = zeros(size(points,1),1);

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
    [~, meanInsolation(i)] = loadDailySolarData(points(i,2),points(i,1));
end

titleText = 'Mean Daily Insolation';
fname = sprintf('Figures/map_%s_insolation.png',lower(region));
colorLegend = '$kWh/m^2/day$';

makeAndSaveMap(res,region,points(:,2),points(:,1),meanInsolation,titleText,colorLegend,fname);