function [solarCost, storageCost, boSCost, oandMCost, term, discountRate, dailyLoad] = getBaselineEconomics(scenario)

if (nargin < 1)
    scenario = 'ssaTier5';
end

loadFactor = 0.2;

%Costs directly related to solar system
solarDerate = 0.85;
chargeControllerCost = 200; % $/kW (gets added to solarCost)

%Economic factors
term = 20; %years
discountRate = .1; %per unit/year
batteryLifetime = 10; %years

switch(lower(scenario))
    case ('hawaii1')
        dailyLoad = 17; %page 4 of report https://energy.hawaii.gov/wp-content/uploads/2011/08/FF_Nov2016.pdf
        peakLoad = dailyLoad/24/loadFactor;
        storageCost = 400; % $/kWh
        solarCost = 700; % $/kW
        inverterCost = 400*peakLoad; % $ (dependent on load)
        boSCost = 100 + peakLoad*400 + inverterCost; % $ (soft and hardware costs fixed for this sized system plus inverter). BoS cost is everything that is dependent on load, rather than directly on solar and battery capacity
    case ('hawaii2')
        dailyLoad = 17;
        peakLoad = dailyLoad/24/loadFactor;
        storageCost = 100; % $/kWh
        solarCost = 400; % $/kW
        inverterCost = 400*peakLoad; % $ (dependent on load)
        boSCost = 100 + peakLoad*400 + inverterCost; % $ (soft and hardware costs fixed for this sized system plus inverter). BoS cost is everything that is dependent on load, rather than directly on solar and battery capacity
    case ('ssatier4')
        dailyLoad = 3.4;
        peakLoad = 0.8;
        storageCost = 400;
        solarCost = 1000;
        %boSCost = (500+750+1500)*peakLoad;
        boSCost = 1.3*1000*peakLoad; % $; 300 $/kW inverter; 1000 $/kW rest
    case ('ssatier5') %Sub-saharan Africa Tier 5
        dailyLoad = 8.2; % kWh
        peakLoad = 2;
        storageCost = 400; % $/kWh
        solarCost = 1000; % $/kW
        boSCost = 1.3*1000*peakLoad; % $; 300 $/kW inverter; 1000 $/kW rest
    case('ssatier4future')
        dailyLoad = 3.4; % kWh
        peakLoad = 0.8;
        storageCost = 100; % $/kWh
        solarCost = 500; % $/kW
        chargeControllerCost = 100; %$/kW
        boSCost = 0.65*1000*peakLoad; % $; 150 $/kW inverter; 500 $/kW rest
    case('ssatier5future')
        dailyLoad = 8.2; % kWh
        peakLoad = 2;
        storageCost = 100; % $/kWh
        solarCost = 500; % $/kW
        chargeControllerCost = 100; %$/kW
        boSCost = 0.65*1000*peakLoad; % $; 150 $/kW inverter; 500 $/kW rest
    case('ssatier5future2')
        dailyLoad = 8.2; % kWh
        peakLoad = 2;
        storageCost = 200; % $/kWh
        solarCost = 250; % $/kW
        chargeControllerCost = 100; %$/kW
        boSCost = 0.65*1000*peakLoad; % $; 150 $/kW inverter; 500 $/kW rest
    otherwise
        error('Unrecognized scenario');
end

solarCost = solarCost/solarDerate+chargeControllerCost; %Solar lifetime assumed to be term
storageCost = storageCost*(1-(1-discountRate)^term)/(1-(1-discountRate)^batteryLifetime); %Includes replacement cost of storage
oandMCost = 0.05; %per unit of capital cost/yr;

%oandMCost = 50 + 50*peakLoad; % $/year assume $50 per year minimum + $50 / kW of demand.  Yields $100/yr for 1kw or $550/yr for 10kW

end