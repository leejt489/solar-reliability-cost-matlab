function makeLCOEMapReliability(reliabilities,res,region,scenario)

[points,LCOE,solarStorageRatio] = getPointsLCOEForScenario(reliabilities,res,region,scenario);

% titleText = sprintf('%s Mean Insolation',region);
% fname = sprintf('Figures/map_%s_insolation.png',region);
% colorLegend = 'kWh/day';
% makeAndSaveMap(res,region,points(:,2),points(:,1),meanInsolation*24,titleText,colorLegend,fname);

folderName = sprintf('Figures/%s',scenario);
if ~exist(folderName, 'dir')
    % Folder does not exist so create it.
    mkdir(folderName);
end

for i = 1:length(reliabilities)
    figure;
    titleText = sprintf('%s LCOE at %g\\%% reliability',region,reliabilities(i)*100);
    rtext = sprintf('%g',reliabilities(i));
    fname = sprintf('%s/map_%s_LCOE_r_%s',folderName,region,rtext(3:end));
    colorLegend = 'LCOE \$/kWh';
    makeAndSaveMap(res,region,points(:,2),points(:,1),LCOE(:,i),titleText,colorLegend,fname);

    figure;
    titleText = sprintf('%s Storage/Solar ratio at %g\\%% reliability',region,reliabilities(i)*100);
    fname = sprintf('%s/map_%s_stor_sol_ratio_r_%s',folderName,region,rtext(3:end));
    colorLegend = 'Hours of storage';
    makeAndSaveMap(res,region,points(:,2),points(:,1),solarStorageRatio(:,i),titleText,colorLegend,fname);

    % titleText = sprintf('Scaled LCOE by mean insolation at %g%% reliability',reliability*100);
    % rtext = sprintf('%g',reliability);
    % fname = sprintf('Figures/map_LCOE_scaled_r_%s.png',rtext(3:end));
    % colorLegend = 'LCOE $';
    % makeAndSaveMap(res,region,points(:,2),points(:,1),LCOE.*meanInsolation*24,titleText,colorLegend,fname);
    % 
    % titleText = sprintf('Diff LCOE and mean insolation at %g%% reliability',reliability*100);
    % rtext = sprintf('%g',reliability);
    % fname = sprintf('Figures/map_LCOE_diff_r_%s.png',rtext(3:end));
    % colorLegend = '';
    % makeAndSaveMap(res,region,points(:,2),points(:,1),(1./LCOE)/mean(1./LCOE)-meanInsolation/mean(meanInsolation),titleText,colorLegend,fname);
end
end