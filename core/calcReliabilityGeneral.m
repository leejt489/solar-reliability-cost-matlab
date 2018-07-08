function [reliability, unmetLoad] = calcReliabilityGeneral(insolation, load, solarCapacity, storageCapacity)
% insolation and load have the same units P. storageCapacity has units of P
% * period.
N = length(insolation);

endPeriodSOC = zeros(N+1,1);
endPeriodSOC(1) = storageCapacity;
unmetLoad = zeros(N,1);
% unusedEnergy = zeros(Ndays,1);
for i = 1:N
    excessPower = solarCapacity*insolation(i)-load(i);
    %unconstrainedSOC = endPeriodSOC(i) + excessPower/storageCapacity;
    endPeriodSOC(i+1) = max(0,min(storageCapacity,endPeriodSOC(i) + excessPower));
    unmetLoad(i) = max(endPeriodSOC(i+1) - endPeriodSOC(i) - excessPower,0);
end

reliability = 1-mean(unmetLoad)/mean(load);
end