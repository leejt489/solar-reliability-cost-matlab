function d = fetchSolarData(lat,lon,startYear)
%Start year could be 1983
endpoint = sprintf('https://eosweb.larc.nasa.gov/cgi-bin/sse/homer.cgi?&ye=2005&lat=%1$g&submit=GetDailyDataasplaintext&me=12&daily=swv_dwn&email=skip@larc.nasa.gov&step=1&p=&ms=1&ys=%3$g&de=31&lon=%2$g&ds=1',lat,lon,startYear);
textData = urlread(endpoint);
try
    d = cellfun(@str2num,strsplit(textData,' '))';
catch
    error('Could not fetch data at lat: %s, lon: %s',lat,lon);
end