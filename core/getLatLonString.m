function s = getLatLonString(lat,lon)
lat = floor(lat); %Rounding reflects NASA data, round to ones
lon = floor(lon);
s = sprintf('lat%s-lon%s',strrep(num2str(lat),'.','_'),strrep(num2str(lon),'.','_')); %Remove decimal place for files
end
