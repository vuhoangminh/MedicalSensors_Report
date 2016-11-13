function main_icip2010coding(aveRate)
% MAIN_ICIP2010CODING
%
% SVN identifier:
% $Id: main_icip2009specs.m 8 2009-11-17 06:17:17Z shogo $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009-2010, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

%close all

if nargin < 1
    aveRate = 0.5;
end

orgImg = im2double(...
    imread('./brodatz_d15_x60y115_80x64.tif'));

figure(1),imshow(orgImg);

%% Coding experiment with two-degree vanishing moment (VM2)

% Preparation
dec = 2;
nLevels = 3;
load 'lppufb_icip2010_dec22_ord44_alp-2.0_hor_vm2.mat'
paramMtx = getParameterMatrices(lppufb);

% Coding with ECSQ
dirdwtquantizer = ...
    DirectionalDwtQuantizer([dec dec],paramMtx,aveRate);
dirdwtquantizer = ...
    dirDwtQuantize(dirdwtquantizer,orgImg,nLevels);

% Display experiomental result
resVm2Img = getImg(dirdwtquantizer);
figure(2),imshow(resVm2Img);
psnr = getPsnr(dirdwtquantizer);
tvmTitle = sprintf('VM2: %.2f [dB]',psnr);
title(tvmTitle)
fprintf('VM2 : %.2f [dB]\n',psnr);

%% Coding experiment with trend vanishing moment (TVM)

% Preparation
dec = 2;
nLevels = 3;
load 'lppufb_icip2010_dec22_ord44_alp-2.0_hor_tvm_phi153.43.mat'
paramMtx = getParameterMatrices(lppufb);

% Coding with ECSQ
dirdwtquantizer = ...
    DirectionalDwtQuantizer([dec dec],paramMtx,aveRate);
dirdwtquantizer = ...
    dirDwtQuantize(dirdwtquantizer,orgImg,nLevels);

% Display experiomental result
resTvmImg = getImg(dirdwtquantizer);
figure(3),imshow(resTvmImg);
psnr = getPsnr(dirdwtquantizer);
tvmTitle = sprintf('TVM: %.2f [dB]',psnr);
title(tvmTitle)
fprintf('TVM : %.2f [dB]\n',psnr);
