function hourlyInsolation = createHourlySolarData(lat,lon)

[dailyInsolation,~,startDate] = loadDailySolarData(lat,lon); %dailyInsolation = kWh/m^2/day, meanInsolation = kWh/m^2/day

Ndays = length(dailyInsolation);
Nhours = Ndays*24;
hourlyInsolation = zeros(Nhours,1);
for i = 1:Ndays
    day = addtodate(startDate,i-1,'day');
    hourlyInsolation((i-1)*24+1:i*24) = getDayIrradiance(lat,lon,day,1,lon/15,'insolation',dailyInsolation(i));
end