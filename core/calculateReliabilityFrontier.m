function [solCap,storCap,solCapD] = calculateReliabilityFrontier(reliability,insolation,load,stepSizeConst,maxTolConst,recursDepth)
if (reliability >= 1 || reliability < 0)
    error('Invalid reliability. Reliability must be > 0 and <= 1');
end

if (nargin < 4)
    stepSizeConst = 0.01;
end
if (nargin < 5)
    maxTolConst = 100;
end
if (nargin < 6)
    recursDepth = 0;
end

tolX = min(stepSizeConst,(1-reliability))/maxTolConst;
options = optimset('FunValCheck','on','TolX',tolX);

startSolar = 2*mean(load)/mean(insolation);

try
    startStorage = fzero(@(storCap) reliability - calcReliabilityGeneral(insolation,load,startSolar,storCap),0,options);
    if (startStorage <= 0)
        startStorage = 0.001;
        startSolar = fzero(@(solCap) reliability - calcReliabilityGeneral(insolation,load,solCap,startStorage),startSolar,options);
    end
catch
    error('Could not calculate start storage');
end

maxDer = -0.05; %Bounds of dSolCap/dStorCap for stopping.  The stopping criterion is to be negative and close to zero
minDer = -2; %Lower bound for stopping.  Based on an upper bound of storage prices ($/kWh) being twice solar prices ($/kW).
minStorage = max(0,fzero(@(storCap) reliability - calcReliabilityGeneral(insolation,load,100*mean(load)/mean(insolation),storCap),0));
r = stepSizeConst/startStorage; %Step size for storage capacity iteration so that the step size is 0.01 around startStorage, storCap(i) = storCap(i-1)*(1+r) in forward sweep and storCap(i) = storCap(i-1)*(1-r) in backward sweep

i = 1;
storCap = startStorage;
solCap = startSolar;
solCapD = maxDer;
%Do forward sweep until reaching the max derivative.  We start somewhere in
%the middle so as not to bother calculating values for solar capacity close
%to the minStorage level (which will likely be cost prohibitive).
while(solCapD(i) <= maxDer)
    deltaStor = r*storCap(i);
    i = i+1;
    storCap(i) = storCap(i-1)+deltaStor;
    f = @(solCap) reliability - calcReliabilityGeneral(insolation,load,solCap,storCap(i));
    [solCap(i),~,exitFlag] = fzero(f,solCap(i-1)+deltaStor*solCapD(i-1),options); %use taylor estimate for guess of zero
    if (exitFlag ~=1)
        error('Fzero did not converge. Exit flag was %g',exitFlag);
    end
    solCapD(i) = (solCap(i)-solCap(i-1))/deltaStor;
end
%Trim the first element where derivative was not defined
solCap = solCap(2:end);
solCapD = solCapD(2:end);
storCap = storCap(2:end);

%Do backward sweep until reaching the min derivative or min storage
while(solCapD(1) >= minDer && storCap(1) > minStorage)
    if (storCap(1)-minStorage > 0.001)
        storCap = [max(storCap(1)*(1-r),minStorage), storCap]; %Going backwards, so add new point to front of array
    else
        storCap = [minStorage, storCap];
    end
    deltaStor = storCap(2)-storCap(1);
    f = @(solCap) reliability - calcReliabilityGeneral(insolation,load,solCap,storCap(1));
    [solCapVal,~,exitFlag] = fzero(f,solCap(1)-deltaStor*solCapD(1),options);
    if (exitFlag ~=1)
        error('Fzero did not converge. Exit flag was %g',exitFlag);
    end
    solCap = [solCapVal solCap];
    solCapD = [(solCap(2)-solCap(1))/deltaStor solCapD];
end

%Only return elements within the derivative range (filters out cases where
%the forward sweep started with a very negative derivative, or backward
%sweep started with a very flat derivative.
%Also transpose into column vectors
t = solCapD >= minDer & solCapD <= maxDer;
solCap = solCap(t)';
storCap = storCap(t)';
solCapD = solCapD(t)';

if (any(solCapD > 0))
    error('Calculated dSol/dStor > 0');
end
solCapD2 = diff(solCapD);
if (any(solCapD2./diff(storCap) < -0.1 & solCapD2 < -0.05))
    if (recursDepth < 10)
        maxTolConst = maxTolConst*10;
        [solCap,storCap,solCapD] = calculateReliabilityFrontier(reliability,insolation,load,stepSizeConst,maxTolConst,recursDepth+1); %Recurse with a tighter tolerance to smooth numerical oscillations
    else
        error('Calculated d^2Sol/dStor^2 < 0; i.e. significantly non-convex and recurse limit of 10 exceeded');
    end
end
if (length(solCap) < 10)
    if (recursDepth < 10)
        [solCap,storCap,solCapD] = calculateReliabilityFrontier(reliability,insolation,load,stepSizeConst/10,maxTolConst,recursDepth+1);
    else
        error('Too few (less than 10) points returned in frontier and recurse limit of 10 exceeded');
    end
end