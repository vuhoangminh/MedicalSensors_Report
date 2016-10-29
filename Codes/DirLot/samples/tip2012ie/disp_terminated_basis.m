%
% SVN identifier:
% $Id: disp_terminated_basis.m 272 2011-12-19 03:16:01Z sho $
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
clear all
close all
%% Load a design example
transition = 0.25;
dec = 2;
ord = 4;
alpha = -2.0;
dir = 2;

vm = 180 + atan(-1/2)*180/pi;
filterName = sprintf(...
    './filters/data128x128i%.2f/ga/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVmd%.2fh.mat', ...
    transition, dec, dec, ord, ord, alpha, dir, vm);
load(filterName);
paramMtx = getParameterMatrices(lppufb);
idirlot = InverseDirLot([dec dec],paramMtx);

%% Preparation
nDecs = dec*dec;
blkNumY = ord+1;
blkNumX = ord+1;
ctrlPoint = ... % Control center block only
    [ round(blkNumY/2) round(blkNumX/2) ];
coefs = cell(1,nDecs);
for iSubband = 1:nDecs
    coefs{iSubband} = zeros(blkNumY,blkNumX);
end

%% Display terminated basis images
modes = {'C', 'N','NW', 'W', 'SW', 'S', 'SE', 'E', 'NE' };

for iMode = 1:length(modes)
    f = figure(iMode);
    set(f,'Name',modes{iMode})
    for iSubband = 1:nDecs
        % Set impluse
        coefs{iSubband}(ctrlPoint(1),ctrlPoint(2)) = 1;
        % Inverse transform
        idirlot = setTerminationCheckMode(idirlot,modes{iMode});
        idirlot = inverseTransform(idirlot,coefs);
        dispImg = getImage(idirlot);
        dispImg = sign(dispImg).*sqrt(abs(dispImg))+0.5;
        subplot(dec,dec,iSubband)
        imshow(dispImg)
        imwrite(imresize(dispImg,2,'nearest'),...
            sprintf('images/basisImg%s%d.tif',modes{iMode},iSubband))
        %imshow(dispImg+0.5)
        % Clear coefficients
        coefs{iSubband}(ctrlPoint(1),ctrlPoint(2)) = 0;
    end
end