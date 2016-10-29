function original_of_main_icip2009dct(aveRate)
% MAIN_ICIP2009DCT
%
% SVN identifier:
% $Id: original_of_main_icip2009dct.m 244 2011-11-22 14:18:13Z sho $
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

%% Forward 4x4 DCT
dec = [4 4];
ord = [0 0];
lppufb = LpPuFb2dFactory.createLpPuFb2d(0,dec,ord); % 4x4 DCT

paramMtx = getParameterMatrices(lppufb);
fdirlot = ForwardDirLot(dec,paramMtx);
fdirlot = forwardTransform(fdirlot,I);
coefs = getSubbandCoefs(fdirlot);

%% ECSQ
ecsQdq = EcsQuantizerDeQuantizer(coefs);
coefs = getDeQuantizedCoefs(ecsQdq,aveRate);

%% Inverse 4x4 DCT
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

%% PSNR 
psnr = 10*log10( (255^2)*numel(sI)/sum((sI(:)-sX(:)).^2)); 
fprintf('psnr = %5.2f [dB]\n',psnr);

