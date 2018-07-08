function folderName = getFolderName(lat,lon)
folderName = sprintf('../data/locations/%s',getLatLonString(lat,lon));
end