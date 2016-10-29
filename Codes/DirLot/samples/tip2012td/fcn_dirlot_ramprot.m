function [dirlotNorm0woScl,dctNorm0woScl,phixd,arrayCard] = ...
    fcn_dirlot_ramprot(params)
% FCN_DIRLOT_RAMPROT
%
% SVN identifier:
% $Id: fcn_dirlot_ramprot.m 377 2013-02-01 07:39:58Z sho $
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
eps = params.eps;
dim = params.dim;
location = params.location;

%%
dec   = params.dec;% Decimation factor
ord   = params.ord;
alpha = params.alpha;% Deformation parameter
dir   = params.dir;
border = ceil(ord/2);

arrayCard = (dim(1)-2*dec*border)*(dim(2)-2*dec*border)*(1-1/dec^2);

if dir == Direction.VERTICAL
    phi = mod(atan(alpha)*180/pi,180);
else
    phi = mod(atan(1/alpha)*180/pi,180);
end
offset = round(mod(phi,1)*100)/100;
filterName = sprintf(...
    '%s/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVmd%06.2fh.mat', ...
    location, dec, dec, ord, ord, alpha, dir, phi);
display(filterName)

tmp = load(filterName,'lppufb');
lppufb = tmp.lppufb;
dct = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);

%%
phixd = -45:135;
phixdoff = phixd+offset;
phixd = reshape([phixd(:) phixdoff(:)].',2*length(phixd),1);
dirlotNorm0woScl = zeros(1,length(phixd));
dctNorm0woScl = zeros(1,length(phixd));
parfor iPhixd = 1:length(phixd)
    
    srcImg = DirLotUtility.trendSurface(phixd(iPhixd),dim);
    
    % DirLot
    fdirlot = ForwardDirLot(lppufb,'circular');
    fdirlot = forwardTransform(fdirlot,srcImg);
    coefsLot = getSubbandCoefs(fdirlot);
            
    for iSubband = 2:length(coefsLot)
        coef = coefsLot{iSubband};
        % ignore the boundary coefs.
        coef = coef(border+1:end-border,border+1:end-border);
        subCoef = abs(coef);
        dirlotNorm0woScl(iPhixd) = dirlotNorm0woScl(iPhixd)...
            + length(find(subCoef(:)>eps));
    end

    % Dct
    fdct = ForwardDirLot(dct,'circular');    
    fdct = forwardTransform(fdct,srcImg);
    coefsDct = getSubbandCoefs(fdct);

    for iSubband = 2:length(coefsDct)
        coef = coefsDct{iSubband};
        % ignore the boundary coefs.
        coef = coef(border+1:end-border,border+1:end-border); 
        subCoef = abs(coef);
        dctNorm0woScl(iPhixd) = dctNorm0woScl(iPhixd)...
            + length(find(subCoef(:)>eps));
    end
    
end
