
loadTypes = {'constant','kitobo','nightHeavy','dayHeavy'};
figure;
hold all;
x = 0:23;
plot(x,ones(size(x))/24);
plot(x,getKitoboHourlyLoad);
plot(x,createNightHeavyHourlyLoadProfile);
plot(x,createDayHeavyHourlyLoadProfile);
xlim([0 24]);
xlabel('Hour of day');
ylabel('Power (kW, normalized to 1 kWh/day)');
title('Load profiles');
legend({'constant','measured representative','nightHeavy','dayHeavy'},'Location','south');
saveas(gcf,'Figures/loadProfiles.png');