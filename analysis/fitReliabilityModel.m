function [points,LCOE,reliabilities,t1,rsq1,residuals1,t2,rsq2,residuals2] = fitReliabilityModel(res,region,scenario,loadType)

if (nargin < 4)
    loadType = 'constant';
end

reliabilities = getSampleReliabilities;
[points,LCOE] = getPointsLCOEForScenario(reliabilities,res,region,scenario,loadType);

LCOE = LCOE';
unmetLoad = 1-reliabilities;

A = [log10(unmetLoad)./reliabilities,ones(size(unmetLoad))./reliabilities,ones(size(unmetLoad))];
t1 = A\LCOE;
LCOECalc = A*t1;
rsq1 = (1-sum((LCOE-LCOECalc).^2)./sum((LCOE-ones(size(LCOE,1),1)*mean(LCOE)).^2))';

residuals1 = LCOECalc-LCOE;

A2 = repmat(A,size(LCOE,2),1);
LCOE2 = LCOE(:);
t2 = A2\LCOE2;
LCOECalc2 = reshape(A2*t2,size(LCOE2));
rsq2 = (1-sum((LCOE2-LCOECalc2).^2)./sum((LCOE2-ones(size(LCOE2,1),1)*mean(LCOE2)).^2))';

residuals2 = LCOECalc2-LCOE2;