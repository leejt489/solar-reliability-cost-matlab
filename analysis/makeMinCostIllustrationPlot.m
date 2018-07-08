function makeMinCostIllustrationPlot(lat,lon,reliabilities)

dailyLoad = 10;

if (nargin < 3)
     reliabilities = getSampleReliabilities;
end
reliabilities = reliabilities(1:floor(length(reliabilities)/3)+1:length(reliabilities)); %Show only 3 reliabilities to illustrate

frontier = generateAndSaveHourReliabilityFrontier(lat,lon,reliabilities,'o');

ratio1 = -0.5;
ratio2 = -0.25;

figure;
a1 = subplot(1,2,1);
hold all;
lines = zeros(length(reliabilities),1);
for i = 1:length(reliabilities)
    r = reliabilities(i);
    points = frontier(r);
    points(:,[1 2]) = 10*points(:,[1 2]);
    lines(i) = plot(points(:,1),points(:,3));
end


plot(get(gca,'xlim'),[ratio1 ratio1],'--k');
plot(get(gca,'xlim'),[ratio2 ratio2],'-.k');

a2 = subplot(1,2,2);
hold all;
for i = 1:length(reliabilities)
    r = reliabilities(i);
    points = frontier(r);
    points(:,[1 2]) = 10*points(:,[1 2]);
    
    [~,IA] = unique(points(:,3));
    points = points(IA,:);
    optStorage1 = interp1(points(:,3),points(:,1),ratio1);
    optSolar1 = interp1(points(:,1),points(:,2),optStorage1);
    optStorage2 = interp1(points(:,3),points(:,1),ratio2);
    optSolar2 = interp1(points(:,1),points(:,2),optStorage2);
    
    %tang1 = (points(:,1)-optStorage1)*ratio1+optSolar1;
    %tang2 = (points(:,1)-optStorage2)*ratio2+optSolar2;
    c = get(lines(i),'Color');
    h = plot(points(:,1),points(:,2),'Color',c);
    %plot(points(:,1),tang1,'--','Color',c);
    %plot(points(:,1),tang2,'-.','Color',c);
    scatter(optStorage1,optSolar1,'MarkerEdgeColor',c,'MarkerFaceColor',c);
    scatter(optStorage2,optSolar2,'^','MarkerEdgeColor',c,'MarkerFaceColor',c);
    axes(a1);
    scatter(optStorage1,ratio1,'MarkerEdgeColor',c,'MarkerFaceColor',c);
    scatter(optStorage2,ratio2,'^','MarkerEdgeColor',c,'MarkerFaceColor',c);
    axes(a2);
end
title('Solar, storage, reliability tradeoff');
xlabel(sprintf('kWh Storage for %g kWh/day load',dailyLoad));
ylabel(sprintf('kW Solar for %g kWh/day load',dailyLoad));

axes(a1);
legend(lines,cellfun(@num2str, num2cell(reliabilities), 'UniformOutput', false),'Location','southeast');
title('dSolar/dStorage at different reliabilities');
xlabel(sprintf('kWh Storage for %g kW/day load',dailyLoad));
ylabel(sprintf('dSolar/dStorage (1/h) for %g kWh/day load',dailyLoad));
set(gcf, 'Position', get(0, 'Screensize'));
suptitle('Graphical solution for optimal system capacity');
saveas(gcf,'Figures/optimalSolution.png');
%end