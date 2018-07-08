deleteHourly = false;
deleteHourFrontier = false;

fnames = dir('Data/*');
for i = 3:length(fnames)
    fname = sprintf('%s/%s',fnames(i).folder,fnames(i).name);
    if (deleteHourly)
        delete(sprintf('%s/%s',fname,'hourlySolarData.mat'));
    end
    if (deleteHourFrontier)
        fnames2 = dir(sprintf('%s/hourReliabilityFrontier_*',fname));
        for j = 1:length(fnames2)
            delete(sprintf('%s/%s',fnames2(j).folder,fnames2(j).name));
        end
    end
        
end