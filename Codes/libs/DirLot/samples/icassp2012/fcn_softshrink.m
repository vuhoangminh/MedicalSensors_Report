function [valueNC,valueT] = fcn_softshrink(valueC,valueT,valueS)

if isscalar(valueT)
    % Subband independent thresholding
    numc = prod(valueS(1,:));
    valueNC(1:numc) = valueC(1:numc);
    pos = numc;
    %pos = 0;
    T = valueT;
    c = valueC(pos+1:end);
    nc = (abs(c)-T);
    nc(nc<0) = 0;
    valueNC(pos+1:pos+length(nc)) = sign(c).*nc;
else
    % Subband dependent thresholding
    numc = prod(valueS(1,:));
    valueNC(1:numc) = valueC(1:numc);
    pos = numc;
    iSub = 1;
    for iLevel=2:size(valueS,1)-1
        numc = prod(valueS(iLevel,:));
        for ihvd = 1:3
            iSub = iSub + 1;
            T = valueT(iSub);
            c = valueC(pos+1:pos+numc);
            nc = (abs(c)-T);
            nc(nc<0) = 0;
            valueNC(pos+1:pos+numc) = sign(c).*nc;
            pos = pos+numc;
        end
    end
end