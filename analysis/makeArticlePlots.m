folderName = 'Figures/Paper';
if ~exist(folderName, 'dir')
    % Folder does not exist so create it.
    mkdir(folderName);
end

%region = 'Sub-Saharan Africa';
region = 'Africa';
loadType = 'constant';
%sampleLat = 6; sampleLon = 20;

%% Additional plots
% makeTradeoffPlots(sampleLat,sampleLon);
 %makeScenarioPlots(sampleLat,sampleLon,scenarios);
% makeLoadComparePlots(sampleLat,sampleLon);
% makeMinCostIllustrationPlot(sampleLat,sampleLon,reliabilities);
% close all;

%% Maps of LCOE (Fig 2)

scenarios = {'ssaTier5','ssaTier5Future'};
resolution = 0.25;
scenarioText = {'Current LCOE','Future Scenario LCOE'};
m = length(scenarios);
reliability = 0.95;
minC = Inf; maxC = -Inf;


%Manually set axes position so as to make room for colorbar
figure; hold on; axis off;
ax = []; axm = [];
set(gcf,'position',get(gcf,'position').*[1 1 1.1 0.6]);
ax(1)=axes('position',[0.04 0 0.37 1]);
ax(2)=axes('position',[0.45 0 0.37 1]);

for i = 1:length(scenarios)
    scenario = scenarios{i};
    axes(ax(i)); %#ok<LAXES>
    [points,LCOE] = getPointsLCOEForScenario(reliability,resolution,region,scenario,loadType);
    
    titleText = scenarioText{i};
    [~,axm(i)] = makeMap(resolution,region,points(:,2),points(:,1),log(LCOE),titleText,NaN,1);
    setm(axm(i),'MeridianLabel','off');
    setm(axm(i),'ParallelLabel','off');
    colorbar('off');
    
    minC = min(minC,min(LCOE));
    maxC = max(maxC,max(LCOE));
end


colorLegend = 'LCOE \$/kWh';
clim = log([minC,maxC]);
caxis(clim);
set(ax,'CLim',clim);
c = colorbar;
ylabel(c,colorLegend,'Interpreter','LaTex');
set(c,'position',[0.85 0.11 0.05 0.78]);
set(c,'YTick',log(linspace(minC,maxC,9)))
set(c,'YTickLabel',num2str(exp(get(c,'YTick'))','%0.2g'));

fname = sprintf('%s/ssa_scenario_comparison_map_%s',folderName,loadType);
f = gcf;
saveas(f,fname);
saveas(f,fname,'png');
%% Scatter plots (Fig 3)
scenarios = {'ssaTier5','ssaTier5Future'};
resolution = 1;

minY = Inf; maxY = -Inf;
defaultBins = 68;
for i = 1:length(scenarios)
    [points,LCOE,~,t1,rsq1,residuals1,t2,rsq2,residuals2] = fitReliabilityModel(resolution,region,scenarios{i},loadType);
    nBins = min(defaultBins,round(size(points,1)/5));
    [z, y] = hist(LCOE',nBins);
    minY = min(minY,min(y));
    maxY = max(maxY,max(y));
end
bins = linspace(minY,maxY,defaultBins);

minC = Inf; maxC = -Inf;
figure; hold on; axis off;
set(gcf,'position',get(gcf,'position').*[1 1 1.1 0.6]);
ax = [];
ax(1)=axes('position',[0.09 0.16 0.35 0.70]);
ax(2)=axes('position',[0.5 0.16 0.35 0.70]);
for i = 1:length(scenarios)
    [~,LCOE,reliabilities,t1,rsq1,residuals1,t2,rsq2,residuals2] = fitReliabilityModel(resolution,region,scenarios{i},loadType);
    disp(t2);
    axes(ax(i)); %#ok<LAXES>
    plotDensityHeatMapReliability(LCOE,reliabilities,bins,t2)
    
    minC = min(minC,min(get(colorbar(),'limits')));
    maxC = max(maxC,max(get(colorbar(),'limits')));
    %minY = min(minY,min(min(LCOE)));
    %maxY = max(maxY,max(max(LCOE)));
    colorbar('off');
end

ylabel(ax(2),'');
title(ax(1),'Current Costs of Reliability')
title(ax(2),'Possible Future Costs of Reliability')
%set(ax,'YLim',[minY,maxY]);
set(ax,'YLim',[0.15,1]);
clim = [minC,maxC];
caxis(clim);
set(ax,'CLim',clim);
c = colorbar;
ylabel(c,'Density','Interpreter','LaTex');
set(c,'position',[0.88 0.16 0.03 0.70])

fname = sprintf('%s/density_heatmap_reliability_%s',folderName,loadType);
saveas(gcf,fname);
saveas(gcf,fname,'png');

%% Make ai map (Fig 4)
scenarios = {'ssaTier5','ssaTier5Future'};
scenarioText = {'Current Reliability Premium','Future Reliability Premium'};
resolution = 0.25;
loadType = 'constant';

figure; hold on; axis off;
ax = []; axm = [];
set(gcf,'position',get(gcf,'position').*[1 1 1.1 0.6]);
ax(1)=axes('position',[0.04 0 0.37 1]);
ax(2)=axes('position',[0.45 0 0.37 1]);
minC = Inf; maxC = -Inf;

for i = 1:length(scenarios)
    scenario = scenarios{i};
    axes(ax(i)); %#ok<LAXES>
    [points,LCOE,~,t1,rsq1,residuals1,t2,rsq2,residuals2] = fitReliabilityModel(resolution,region,scenario,loadType);
    titleText = scenarioText{i};
    [~,axm(i)] = makeMap(resolution,region,points(:,2),points(:,1),-t1(1,:),titleText,NaN,1);
    setm(axm(i),'MeridianLabel','off');
    setm(axm(i),'ParallelLabel','off');
    colorbar('off');
    
    minC = min(minC,min(-t1(1,:)));
    maxC = max(maxC,max(-t1(1,:)));
end

%titleText = sprintf('Counts of $a_i: \\mathrm{LCOE}_i = -a_i\\frac{\\log_{10}(1-r)}{r}+b_i\\frac{1}{r}+c_i$');
colormap(flipud(colormap))
clim = [minC,maxC];
caxis(clim);
set(ax,'CLim',clim);
colorLegend = '$a_i: \$/kWh \textrm{ per 9 of FDS}$';
c = colorbar;
ylabel(c,colorLegend,'Interpreter','LaTex');
set(c,'position',[0.85 0.11 0.05 0.78]);

%ylabel(c,colorLegend,'Interpreter','LaTex');
%set(c,'position',[0.85 0.05 0.05 0.90]);

fname = sprintf('%s/ssa_map_ai',folderName);
f = gcf;
saveas(f,fname);
saveas(f,fname,'png');
colormap(flipud(colormap))

%% Compare demand types - LCOE
scenario = 'ssaTier5';
resolution = 1;
loadTypes = {'constant','dayHeavy','kitobo','nightHeavy'};

minY = Inf; maxY = -Inf;
defaultBins = 68;
for i = 1:length(loadTypes)
    [points,LCOE,~,t1,rsq1,residuals1,t2,rsq2,residuals2] = fitReliabilityModel(resolution,region,scenario,loadTypes{i});
    nBins = min(defaultBins,round(size(points,1)/5));
    [z, y] = hist(LCOE',nBins);
    minY = min(minY,min(y));
    maxY = max(maxY,max(y));
end

bins = linspace(minY,maxY,defaultBins);

minC = Inf; maxC = -Inf;

%Manually set axes position so as to make room for colorbar
figure; hold on; axis off;
ax = [];
ax(1)=axes('position',[0.09 0.60 0.33 0.35]);
ax(2)=axes('position',[0.09 0.10 0.33 0.35]);
ax(3)=axes('position',[0.48 0.60 0.33 0.35]);
ax(4)=axes('position',[0.48 0.10 0.33 0.35]);
for i = 1:length(loadTypes)
    [~,LCOE,reliabilities,t1,rsq1,residuals1,t2,rsq2,residuals2] = fitReliabilityModel(resolution,region,scenario,loadTypes{i});
    disp(t2);
    axes(ax(i)); %#ok<LAXES>
    plotDensityHeatMapReliability(LCOE,reliabilities,bins,t2)
    
    minC = min(minC,min(get(colorbar(),'limits')));
    maxC = max(maxC,max(get(colorbar(),'limits')));
    %minY = min(minY,min(min(LCOE)));
    %maxY = max(maxY,max(max(LCOE)));
    colorbar('off');
end

ylabel(ax(3),'');
ylabel(ax(4),'');
xlabel(ax(1),'');
xlabel(ax(3),'');
title(ax(1),'Constant Demand')
title(ax(2),'Day Heavy Demand')
title(ax(3),'Sample Measured Demand')
title(ax(4),'Night Heavy Demand')
set(ax,'YLim',[minY,1]);
clim = [minC,maxC];
caxis(clim);
set(ax,'CLim',clim);
c = colorbar;
ylabel(c,'Density','Interpreter','LaTex');
set(c,'position',[0.86 0.05 0.05 0.90]);

fname = sprintf('%s/density_heatmap_reliability_loadCompare',folderName);
saveas(gcf,fname);
saveas(gcf,fname,'png');
%%
%% Compare demand types - LCOE
scenario = 'ssaTier5';
resolution = 1;
loadTypes = {'constant','dayHeavy','kitobo','nightHeavy'};

minY = Inf; maxY = -Inf;
defaultBins = 68;
for i = 1:length(loadTypes)
    [points,~,storSolRatio,~] = getPointsLCOEForScenario(reliabilities,resolution,region,scenario,loadTypes{i});
    nBins = min(defaultBins,round(size(points,1)/5));
    [z, y] = hist(storSolRatio',nBins);
    minY = min(minY,min(y));
    maxY = max(maxY,max(y));
end

bins = linspace(minY,maxY,defaultBins);

minC = Inf; maxC = -Inf;

%Manually set axes position so as to make room for colorbar
figure; hold on; axis off;
ax = [];
ax(1)=axes('position',[0.09 0.60 0.33 0.35]);
ax(2)=axes('position',[0.09 0.10 0.33 0.35]);
ax(3)=axes('position',[0.48 0.60 0.33 0.35]);
ax(4)=axes('position',[0.48 0.10 0.33 0.35]);
for i = 1:length(loadTypes)
    [~,~,storSolRatio,~] = getPointsLCOEForScenario(reliabilities,resolution,region,scenario,loadTypes{i});
    axes(ax(i)); %#ok<LAXES>
    plotDensityHeatMapReliabilityStorSolRatio(storSolRatio,reliabilities,bins)
    ylabel('Hours of Storage')
    minC = min(minC,min(get(colorbar(),'limits')));
    maxC = max(maxC,max(get(colorbar(),'limits')));
    %minY = min(minY,min(min(LCOE)));
    %maxY = max(maxY,max(max(LCOE)));
    colorbar('off');
end

ylabel(ax(3),'');
ylabel(ax(4),'');
xlabel(ax(1),'');
xlabel(ax(3),'');
title(ax(1),'Constant Demand')
title(ax(2),'Day Heavy Demand')
title(ax(3),'Sample Measured Demand')
title(ax(4),'Night Heavy Demand')
set(ax,'YLim',[minY,7]);
clim = [minC,maxC];
caxis(clim);
set(ax,'CLim',clim);
c = colorbar;
ylabel(c,'Density','Interpreter','LaTex');
set(c,'position',[0.86 0.05 0.05 0.90]);

fname = sprintf('%s/density_heatmap_reliability_loadCompare_systemDesign',folderName);
saveas(gcf,fname);
saveas(gcf,fname,'png');

%% Grid compare
res = 0.25;
scenarios = {'ssaTier5','ssaTier5Future'};

minC = Inf; maxC = -Inf;

figure; hold on; axis off;
ax = []; axm = [];
set(gcf,'position',get(gcf,'position').*[1 1 1.1 0.6]);
ax(1)=axes('position',[0.04 0 0.37 1]);
ax(2)=axes('position',[0.45 0 0.37 1]);

for i = 1:length(scenarios)
    scenario = scenarios{i};
    axes(ax(i));
    [~,axm(i)] = makeLCOEAtGridReliabilityMap(res,region,scenario);
    setm(axm(i),'MeridianLabel','off');
    setm(axm(i),'ParallelLabel','off');
    minC = min(minC,min(get(colorbar(),'limits')));
    maxC = max(maxC,max(get(colorbar(),'limits')));
    colorbar('off');
end

title(ax(1),'Current cost difference')
%set(get(ax(1),'title'),'position',get(get(ax(1),'title'),'position')-[.1 .25 0]);
title(ax(2),'Possible future cost difference')
%set(get(ax(2),'title'),'position',get(get(ax(2),'title'),'position')-[.1 .25 0]);
clim = [-max(abs([minC,maxC])),max(abs([minC,maxC]))];
caxis(clim);
set(ax,'CLim',clim);
c = colorbar;
ylabel(c,'Difference: (Solar - Grid) \$/kWh','Interpreter','LaTex');
%set(c,'position',[0.87 0.12 0.03 0.8]);
set(c,'position',[0.85 0.11 0.03 0.78]);

fname = sprintf('%s/map_gridcomparereliability_%s',folderName);
saveas(gcf,fname);
saveas(gcf,fname,'png');

%% System design
scenario = 'ssaTier5';
reliabilities = getSampleReliabilities();
resolution = 1;

bins = defaultBins;

minC = Inf; maxC = -Inf;
figure; hold on; axis off;
set(gcf,'position',get(gcf,'position').*[1 1 1.1 0.4]);
ax = [];
ax(1)=axes('position',[0.07 0.23 0.23 0.6]);
ax(2)=axes('position',[0.37 0.23 0.23 0.6]);
ax(3)=axes('position',[0.67 0.23 0.23 0.6]);

[points,~,storSolRatio,~,storageCapacity,solarCapacity] = getPointsLCOEForScenario(reliabilities,resolution,region,scenario,loadType);

axes(ax(1));
plotDensityHeatMapReliabilityStorSolRatio(solarCapacity,reliabilities,bins)
ylabel('kW Solar')
title('Solar Capacity','Interpreter','LaTex')

axes(ax(2));
plotDensityHeatMapReliabilityStorSolRatio(storageCapacity,reliabilities,bins)
title('Storage Capacity','Interpreter','LaTex')
ylabel('kWh Storage')

axes(ax(3));
plotDensityHeatMapReliabilityStorSolRatio(storSolRatio,reliabilities,bins)
ylabel('Hours of Storage')
title('Storage to Solar Ratio','Interpreter','LaTex')

for i = 1:3
    axes(ax(i)); %#ok<LAXES>
    minC = min(minC,min(get(colorbar(),'limits')));
    maxC = max(maxC,max(get(colorbar(),'limits')));
    colorbar('off');
end
clim = [minC,maxC];
caxis(clim);
set(ax,'CLim',clim);
c = colorbar;
ylabel(c,'Density','Interpreter','LaTex');
set(c,'position',[0.91 0.23 0.02 0.6])
ylim(ax(1),[0 6]);
ylim(ax(2),[0 15]);
ylim(ax(3),[0 6]);

fname = sprintf('%s/density_heatmap_reliability_capacities_%s',folderName,loadType);
saveas(gcf,fname);
saveas(gcf,fname,'png');
