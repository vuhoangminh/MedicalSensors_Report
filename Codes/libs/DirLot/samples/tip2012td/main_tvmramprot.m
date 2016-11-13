% MAIN_TVMRAMPROT
%
% SVN identifier:
% $Id: main_tvmramprot.m 184 2011-08-17 14:13:14Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009-2011, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

%% Ramp Rotation
eps = 1e-15;
dim = [ 32 32 ];

arrayCard = ((dim(1)-4)*(dim(2)-4))*3/4;

%% DirLOT

phid  = -45:134;
phixd = -45:134;
arrayNorm0woScl = zeros(length(phid),length(phixd)); 
for iPhid = 1:length(phid)
    
    phi = phid(iPhid)*pi/180;
    if phi >=-pi/4 && phi < pi/4
        if phi <= 0
            ss = [1 0 1 0 1];
            theta = pi+phi;
        else
            ss = [0 0 1 0 1];
            theta = 0+phi;
        end
    elseif phi >=pi/4 && phi < 3*pi/4
        if phi <= pi/2
            ss = [1 0 0 0 0];
            theta = pi-phi;
        else
            ss = [0 0 0 0 0];
            theta = 0-phi;
        end
    else
        error('Unexped error occured.');
    end
    
    dirlot = fcn_ezdirlottvm(phi,ss,theta);
    
    subbandNorm0woScl = zeros(1,length(phixd));
    parfor iPhixd = 1:length(phixd)
        
        phix = phixd(iPhixd)*pi/180;
        srcImg = DirLotUtility.trendSurface(phixd(iPhixd),dim);
            
        % DirLot
        fdirlot = ForwardDirLot(dirlot,'circular');
        fdirlot = forwardTransform(fdirlot,srcImg);
        coefsLot = getSubbandCoefs(fdirlot);
            
        coef = coefsLot{1};
        subCoef = abs(coef);
        subbandNorm0(iPhixd) = length(find(subCoef(:)>eps));

        for iSubband = 2:length(coefsLot)
            coef = coefsLot{iSubband};
            coef = coef(2:end-1,2:end-1); % ignore the boundary coefs.
            subCoef = abs(coef);
            subbandNorm0woScl(iPhixd) = subbandNorm0woScl(iPhixd)...
                + length(find(subCoef(:)>eps));
        end
        input0(iPhixd) = length(find(srcImg(:)>eps));
    end
    arrayNorm0woScl(iPhid,:) = subbandNorm0woScl(:).';

    disp(phid(iPhid))
end

%%
save results/tvmramprot_results arrayNorm0woScl arrayCard
