function countryNames = getCountryNames(points) %points are in format lon,lat or x,y
try 
    load('../data/pointToCountry','countries');
catch
    countries = savePointToCountry();
end

countryNames = cell(size(points,1),1);
for i = 1:size(points,1)
countryNames(i) = countries(points(i,2)*4+361,points(i,1)*4+721);
end