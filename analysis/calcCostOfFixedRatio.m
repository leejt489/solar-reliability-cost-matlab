% Get the optimal system design for 95% reliability for each location.
% Given a cost scenario, for each location, for each reliability, calculate
% the difference in cost between the optimal system and the 95% system
% design.
clear all;close all;clc;
folderName = 'Data';
if ~exist(folderName, 'dir')
    % Folder does not exist so create it.
    mkdir(folderName);
end

recalc = false; couldNotLoad = false;
region = 'Africa';
scenario = 'ssaTier5';
loadType = 'constant';
resolution = 0.25;
fileName = sprintf('%s/%s_%s_costoffixedratio_%g.mat',folderName,region,scenario,resolution);
if (~recalc)
    try
        load(fileName);
    catch
        couldNotLoad = true;
    end
end

if (recalc || couldNotLoad)
    reliabilities = getSampleReliabilities();
    r_ind = find(reliabilities == 0.95);
    [solarCost, storageCost, boSCost, oandMCost, term, discountRate, dailyLoad] = getBaselineEconomics(scenario);
    crf = (discountRate*(1+discountRate)^term)/(((1+discountRate)^term)-1);

    [points,LCOE_opt,storSolRatio_opt,~,storageCapacity_opt,solarCapacity_opt] = getPointsLCOEForScenario(reliabilities,resolution,region,scenario,loadType);
    LCOE_f = zeros(size(points,1),length(reliabilities));
    storageCapacity_f = zeros(size(storageCapacity_opt));
    solarCapacity_f = zeros(size(solarCapacity_opt));
    capitalCost_f = zeros(size(LCOE_f));

    fprintf('\nStarting processing...\n');
    s = '';
    tic
    for i = 1:size(points,1)
        if (toc > 1 || i == size(points,1))
            tic;
            fprintf(repmat('\b',1,length(s)));
            s = sprintf('Processing location %g of %g ...\r',i,size(points,1));
            fprintf(s);
        end
        [storCapPU, solCapPU] = getSystemFixedRatio(points(i,2),points(i,1),storSolRatio_opt(i,r_ind),reliabilities);
        storageCapacity_f(i,:) = storCapPU*dailyLoad; solarCapacity_f(i,:) = solCapPU*dailyLoad;
        capitalCost_f(i,:) = storageCapacity_f(i,:)*storageCost + solarCapacity_f(i,:)*solarCost + boSCost;
        LCOE_f(i,:) = (crf*capitalCost_f(i,:) + oandMCost*capitalCost_f(i,:))/365/dailyLoad./reliabilities';
    end
end

costDiff = LCOE_f-LCOE_opt;

recalc = false;
save(fileName);

%%
r_ind = [3,6,10,13]; %Tier 4 and 5 reliabilities
% if (any(costDiff<=0))
%     costDiff = costDiff-min(min(costDiff))+0.0001;
% end
minC = min(min(costDiff(:,r_ind))); maxC = max(max(costDiff(:,r_ind)));

%Manually set axes position so as to make room for colorbar
figure; hold on; axis off;
ax = []; axm = [];
ax(1)=axes('position',[0.05 0.55 0.35 0.40]);
ax(3)=axes('position',[0.05 0.05 0.35 0.40]);
ax(2)=axes('position',[0.45 0.55 0.35 0.40]);
ax(4)=axes('position',[0.45 0.05 0.35 0.40]);

for i = 1:length(r_ind)
    axes(ax(i)); %#ok<LAXES>
    
    titleText = sprintf(['Penalty at FDS = %0.' num2str(i) 'g'],reliabilities(r_ind(i)));
    [~,axm(i)] = makeMap(resolution,region,points(:,2),points(:,1),(costDiff(:,r_ind(i))),titleText,NaN,1);
    setm(axm(i),'MeridianLabel','off');
    setm(axm(i),'ParallelLabel','off');
    colorbar('off');
end


colorLegend = '$LCOE_{fixed}-LCOE_{opt}$ \$/kWh';
%clim = log([minC,maxC]);
clim = [minC,maxC];
caxis(clim);
set(ax,'CLim',clim);
c = colorbar;
ylabel(c,colorLegend,'Interpreter','LaTex');
% set(c,'YTick',log(linspace(minC,maxC,11)))
% set(c,'YTickLabel',num2str(exp(get(c,'YTick'))','%0.2g'));
set(c,'position',[0.85 0.05 0.05 0.90])

folderName = 'Figures/Paper';
fname = sprintf('%s/fixedRatio_costDiff',folderName);
f = gcf;
saveas(f,fname);
saveas(f,fname,'png');