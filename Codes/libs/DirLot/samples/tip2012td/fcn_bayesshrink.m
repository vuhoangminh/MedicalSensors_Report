function [valueNC, valueT] = fcn_bayesshrink(valueC,valueS)

% Estimation of standard deviation
numfinec=prod(valueS(end-1,:));
hh1 = valueC(numfinec+1:2*numfinec); % finest wavelet coefs
esigma = median(abs(hh1))/.6745;
ve = esigma^2;

% Subband dependent thresholding
numc = prod(valueS(1,:));
valueNC(1:numc) = valueC(1:numc);
pos = numc;
iSub = 1;
valueT(iSub,1) = 0;
for iLevel=2:size(valueS,1)-1
    numc = prod(valueS(iLevel,:));
     for ihvd = 1:3
         iSub = iSub + 1;
         c = valueC(pos+1:pos+numc);
         vy = var(c);
         sigmax = sqrt(max(vy-ve,0));
         T = min(ve/sigmax,max(abs(c(:))));
         nc = (abs(c)-T);
         nc(nc<0) = 0;
         valueNC(pos+1:pos+numc) = sign(c).*nc;
         valueT(iSub,1) = T;
         pos = pos+numc;
     end
end
