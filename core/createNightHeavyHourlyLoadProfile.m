function load = createNightHeavyHourlyLoadProfile
load = ones(24,1);
load(7:18) = 0; %Set day = 0;
load = load/sum(load); %Normalize to 1.
end