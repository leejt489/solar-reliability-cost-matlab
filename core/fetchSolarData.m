function d = fetchSolarData(lat,lon,startYear)


% Old code with old NASA POWER API:
%Start year could be 1983
%endpoint = sprintf('https://eosweb.larc.nasa.gov/cgi-bin/sse/homer.cgi?&ye=2005&lat=%1$g&submit=GetDailyDataasplaintext&me=12&daily=swv_dwn&email=skip@larc.nasa.gov&step=1&p=&ms=1&ys=%3$g&de=31&lon=%2$g&ds=1',lat,lon,startYear);
% textData = urlread(endpoint);
% try
%     d = cellfun(@str2num,strsplit(textData,' '))';
% catch
%     error('Could not fetch data at lat: %s, lon: %s',lat,lon);
% end

% New API

% End hard coded to end of 2016
endDate = '20161231';

url = sprintf('https://power.larc.nasa.gov/cgi-bin/v1/DataAccess.py?request=execute&identifier=SinglePoint&parameters=T2M,PS,ALLSKY_SFC_SW_DWN&startDate=%3$g0101&endDate=%4$s&userCommunity=SSE&tempAverage=DAILY&outputList=JSON&lat=%1$g&lon=%2$g&user=anonymous',lat,lon,startYear,endDate);
disp(url);
options = weboptions('Timeout',600000);
data = webread(url,options);

% Dig down into the struct to get the info you want
allSky = data.features.properties.parameter.ALLSKY_SFC_SW_DWN;

% Unfortunately, it's in an inconvenient format: a struct where each field
% name is the date (with an 'x' in front of it), and the value is the
% number we are after. So we have to loop through all the fields and pull
% out the value
s = fieldnames(allSky);
vals = zeros(length(s),1);
for i = 1:length(s)
    fname = s{i};
    vals(i) = allSky.(fname); % This is MATLAB's funky syntax for 'dynamically' getting the field of a struct; called "dynamic field referencing"
end

% WARNING: To be robust, you should sort the fieldnames. Strictly speaking,
% there's no guarantee that they're going to be in the right order (sorted
% by time). Below is a way to do it that also gives you the date. Note that
% you could do it (more efficiently) in the same loop above.

d = zeros(length(s),1);
for i = 1:length(s)
    fname = s{i};
    d(i) = str2num(fname(2:end)); % The 2:end gets rid of the 'x'
end
% Now we have the data as a number

% And so now you can sort them
t = [d, vals];
sorted = sortrows(t,'asc');

% And this is your vector of daily values
d = sorted(:,2);

% It seems that there are missing values represented as -999, so we filter
% and fill:
d(d < 0) = NaN;
d = fillmissing(d,'linear');