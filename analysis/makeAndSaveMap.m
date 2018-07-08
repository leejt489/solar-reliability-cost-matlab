function [f,axm] = makeAndSaveMap(res,region,lat,lon,val,titleText,colorLegend,fname)
[f,axm] = makeMap(res,region,lat,lon,val,titleText,colorLegend);
if (length(fname) > 4 && strcmpi(fname(end-3:end),'.png'))
    fname = fname(1:end-4);
end
saveas(f,fname);
saveas(f,fname,'png');
end