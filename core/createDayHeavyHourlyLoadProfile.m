function load = createDayHeavyHourlyLoadProfile
load = zeros(24,1);
load(7:18) = 1; %Set day = 1;
load = load/sum(load); %Normalize to 1.
end