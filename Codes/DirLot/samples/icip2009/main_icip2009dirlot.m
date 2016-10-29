function main_icip2009dirlot(aveRate)
% MAIN_ICIP2009DIRLOT
%
% SVN identifier:
% $Id: main_icip2009dirlot.m 91 2011-03-02 04:06:12Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

if nargin < 1
    aveRate = 0.5;
end

I = im2double(...
    imread('brodatz_d15_x120y48_72x72.tif'));

%% Forward DirLOT
dec = [4 4];
% Variable lppufb is an instance of Class LpPuFb2d
load('lppufb_icip2009_dec44_ord22_alp-2.0_hor_vm1.mat')

paramMtx = getParameterMatrices(lppufb);
fdirlot = ForwardDirLot(dec,paramMtx);
fdirlot = forwardTransform(fdirlot,I);
coefs = getSubbandCoefs(fdirlot);

%% ECSQ
ecsQdq = EcsQuantizerDeQuantizer(coefs);
coefs = getDeQuantizedCoefs(ecsQdq,aveRate);

%% Inverse DirLOT
idirlot = InverseDirLot(dec,paramMtx);
idirlot = inverseTransform(idirlot,coefs);
X = getImage(idirlot);

%% Display
sI=im2uint8(I);
sX=im2uint8(X);

figure(1)
imshow(sI)
title('Original')

figure(2)
imshow(sX)
title('Result')

%% PSNR - corrected
psnr = 10*log10( (255^2)*numel(sI)/sum((int16(sI(:))-int16(sX(:))).^2));
fprintf('psnr = %5.2f [dB]\n',psnr);

