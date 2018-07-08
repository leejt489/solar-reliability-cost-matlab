res = 1;
region = 'africa';
scenario = 'ssatier5';

folderName = sprintf('Figures/%s',scenario);
if ~exist(folderName, 'dir')
    % Folder does not exist so create it.
    mkdir(folderName);
end
points = getLonLatPoints(res,region); %Africa lat lon samples at resolution
reliabilities = getSampleReliabilities;
unmetLoad = 1-reliabilities;
[solarCost, storageCost, boSCost, oandMCost, term, discountRate, dailyLoad] = getBaselineEconomics(scenario);

LCOE = zeros(length(reliabilities),size(points,1));
storageSolarRatio = zeros(length(reliabilities),size(points,1));
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
    lat = points(i,2);
    lon = points(i,1);
    [LCOE(:,i),storageSolarRatio(:,i),meanInsolation(i)] = calcLCOE(lat,lon,reliabilities,storageCost,solarCost,dailyLoad,boSCost,oandMCost,term,discountRate);
    %[~,storageSolarRatio(:,i),meanInsolation(i),LCOE(:,i)] = calcLCOE(lat,lon,reliabilities,storageCost,solarCost,dailyLoad,boSCost,oandMCost,term,discountRate);
end
nBins = min(100,round(size(points,1)/5));
fprintf('...done\n')

%%
