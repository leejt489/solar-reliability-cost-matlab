res = 1;
region = 'Africa';
scenario = 'ssaTier5';
reliabilities = getSampleReliabilities();

[points,LCOE,solarStorageRatio] = getPointsLCOEForScenario(reliabilities,res,region,scenario);
meanInsolation = zeros(size(points,1));

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

%%
rsq = zeros(length(reliabilities),1);
a = zeros(size(rsq));
b = zeros(size(rsq));
A = [meanInsolation,ones(size(meanInsolation))];
LCOECalc = zeros(size(LCOE));
for c = 1:length(reliabilities)
    t = A\LCOE(:,c);
    LCOECalc(:,c) = A*t;
    a(c) = t(1);
    b(c) = t(2);
    rsq(c) = (1-sum((LCOE(:,c)-LCOECalc(:,c)).^2)./sum((LCOE(:,c)-ones(size(LCOE,1),1)*mean(LCOE(:,c))).^2))';
end

figure;
%set(gcf,'Position',get(gcf,'Position').*[1 1 2 1])
r = [3,6,10];
for i = 1:length(r)
    %subplot(2,3,i+(i>2));
    subplot(2,2,i);
    c = r(i);
    scatter(meanInsolation,LCOE(:,c),'.');
    hold on
    plot(meanInsolation,LCOECalc(:,c),'k','LineWidth',1.5)
    xlabel('Mean Insolation (kWh/m^2/day)')
    ylabel('LCOE (USD)')
    title(sprintf(['FDS=%0.' num2str(i) 'g, R^2=%0.2g'],reliabilities(c),rsq(c)))
end
%subplot(2,3,[3 6]);
subplot(2,2,4)
plot(1-reliabilities,rsq);
set(gca,'XLim',[1-max(reliabilities),1-min(reliabilities)])
set(gca,'XDir','reverse')
set(gca,'XScale','log')
set(gca,'XTick',[0.0001,0.001,0.01,0.1])
set(gca,'XTickLabel',1-get(gca,'XTick'))
set(gca,'YTick',linspace(0,1,5))
xlabel('FDS')
ylabel('R^2')
title('Performance of linear model')
saveas(gcf,'Figures/Paper/insolation_predicts_LCOE.png');