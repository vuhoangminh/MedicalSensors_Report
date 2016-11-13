function [I,S,J] = zonalcoding(lppufb,phix,dim)

slope = -4;
I = DirLotUtility.rampEdge(phix,slope,dim);

%% Forward DirLOT

fdirlot = ForwardDirLot(lppufb);
fdirlot = forwardTransform(fdirlot,I);
coefs = getSubbandCoefs(fdirlot);

%% Zonal Coding

S = abs([ coefs{1} 8*coefs{2} ; 8*coefs{3} 8*coefs{4} ]);

for iSubband =2:4
    coefs{iSubband} = 0*coefs{iSubband};
end

%% Inverse DirLOT
idirlot = InverseDirLot(lppufb);
idirlot = inverseTransform(idirlot,coefs);
J = getImage(idirlot);
