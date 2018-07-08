function [irradiance,time,clearnessIndex] = getDayIrradiance(lat,lon,date,resolution,tOffset,flag,flagVal)
% flag:
%   'clearsky': calculate clear sky irradiance
%   'clearness': provide a clearness index through 'flagVal'
%   'mean': provide a mean irradiance (kW/m^2) through 'flagVal'
%   'insolation': provide a total insolation (kWh/m^2) for the day through
%       'flagVal'

if (resolution > 60*12)
    error('Cannot have a resolution greater than 12 hours');
end

dvec = datevec(datenum(date));
dvec(5:6) = [0 0];
dayOfYear = datenum(dvec)-datenum(dvec(1),0,0);
dvec(4:6) = -tOffset; %coerce hours to timezone offset, minutes, and seconds to zero.
coercedDate = datenum(dvec);

% Get the average insolation of a time period with midpoint 't_utc'
% over 'resolution' number of hour.
decl = 23.45*sind(360*(284+dayOfYear)/365); %declination
Gon = 1.367*(1+0.033*cosd(360*dayOfYear/365)); %extraterrestrial normal radiation kW/m^2
getClearSkyMeanIrradianceFromInterval = @(w1,w2) Gon*(cosd(lat)*cosd(decl)*(sind(w2)-sind(w1))*180/pi/mod(w2-w1,360)+sind(lat)*sind(decl)); % Average irradiance from integration kW/m^2.  Interval must be during light!
getClearSkyInsolationFromInterval = @(w1,w2) getClearSkyMeanIrradianceFromInterval(w1,w2)*mod(w2-w1,360)/15; % Cumulative irradiance from integration kWh/m^2

sunset = acosd(-tand(lat)*tand(decl));
sunrise = 360-sunset;
%sunset = sunset+360;

if (nargin == 5 || strcmpi(flag,'clearsky'))
    clearnessIndex = 1;
elseif (strcmpi(flag,'clearness'))
    clearnessIndex = flagVal;
elseif (strcmpi(flag,'mean'))
    meanIrradiance = flagVal;

    % Expression for clear sky insolation from integration. Requires that w2,
    % w1 are between sunrise and sunset.
    clearnessIndex = meanIrradiance/(getClearSkyInsolationFromInterval(sunrise,sunset)/24);
elseif (strcmpi(flag,'insolation'))
    meanIrradiance = flagVal/24;
    clearnessIndex = meanIrradiance/(getClearSkyInsolationFromInterval(sunrise,sunset)/24);
else
    error('Invalid arguments')
end

% Parameters for calculating solar hour given obliquity of orbit
B = 360*(dayOfYear-1)/365;
E = 3.82*(0.000075+0.001868*cosd(B)-0.032077*sind(B)-0.014615*cosd(2*B)-0.04089*sind(2*B)); %Equation of time for obliquity

N = 24/resolution;
irradiance = zeros(N,1);
time = zeros(N,1);

for k = 1:N
    t_utc = addtodate(coercedDate,(k-1)*round(resolution*60),'minute');    
    irradiance(k) = getClearSkyIrradianceFromMidpoint(t_utc)*clearnessIndex;
    time(k) = t_utc;
end

    function irradiance = getClearSkyIrradianceFromMidpoint(t_utc)
        
        t_utc_vec = datevec(t_utc);
        solarHour = t_utc_vec(4)+t_utc_vec(5)/60+lon/15 + E;
        
        % Calculate the beginning and end of the integration period
        w1 = mod((solarHour-resolution/2-12)*15,360);
        w2 = mod((solarHour+resolution/2-12)*15,360);

        % Adjust the bounds of integration if period includes nighttime.
        w1dark = ((w1>=sunset && w1<=sunrise));
        w2dark = ((w2>=sunset && w2<=sunrise));
        if (w1dark && w2dark) % The entire period is dark, so irradiance = 0;
            irradiance = 0;
            return;
        end
        if (w1dark)
            w1 = 360-sunset;
        end
        if (w2dark)
            w2 = sunset;
        end
        
        irradiance = getClearSkyMeanIrradianceFromInterval(w1,w2)*mod((w2-w1),360)/(resolution*15); %scaling term is to compensate for when w2-w1 is not the even interval and weight accordingly
    end

end