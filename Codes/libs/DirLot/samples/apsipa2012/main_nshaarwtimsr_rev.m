% MAIN_HSHAARWTIMSR Image Super-resolution with Non-subsampled Haar Wavelet
%
% SVN identifier:
% $Id: main_nshaarwtimsr_rev.m 383 2013-10-07 04:55:32Z sho $
%
% Requirements: MATLAB R2011b
%
% Copyright (c) 2012, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
clear all; clc

%% Parameter setting
dfactor = 2;
shblur = 'gaussian_wide';
dgrd = istaimrstr.Decimation(dfactor,shblur);
lambda = 0.0017;
nlevels = 2;
isverbose = true;
isminord = false;

%% Load test image
[src,strpartpic] = load_testimg('lena');
p = im2double(src);

%% Create observed picture
nsigma = 0;
x = observation(dgrd,p,strpartpic,nsigma);

%% Download ssim_index.m if it is absent
download_ssim_index

%% ISTA
disp('ISTA')
rstr = istaimrstr.NsHaarWtIstaImRestorationRev(dgrd,lambda,nlevels);
if isverbose
    rstr = setReference(rstr,p);
    rstr = setMonitoring(rstr,true);
    rstr = setEvaluation(rstr,true);
end
figure(1)
tic
rstr = run(rstr,x);
toc

%% Evaluation
y = getResult(rstr);
[psnr,mse] = fcn_psnr4peak1(p,y);
res = im2uint8(y);
ssim = ssim_index(src,res);
disp(['(ista) mse= ' num2str(mse*255^2) ...
        ', psnr=' num2str(psnr) ' [dB]' ...
        ', ssim=' num2str(ssim) ]);
% s = sprintf('%s_%dx%d_%s_ns%6.2f',...
%         strpic,nDim(1),nDim(2),getString(istaimrstr),nsigma);
% imwrite(res,sprintf('./results/res_%s.tif',s));
% save(sprintf('./results/psnrs_%s',s),'psnr','mse','ssim')

%% Bicubic
stype = 'bicubic';
ycubic = imresize(x,dfactor);
[psnr,mse] = fcn_psnr4peak1(p,ycubic);
res = im2uint8(ycubic);
ssim = ssim_index(src,res);
disp(['(' stype ') mse= ' num2str(mse*255^2) ...
        ', psnr=' num2str(psnr) ' [dB]' ...
        ', ssim=' num2str(ssim) ]);
%s = sprintf('%s_%dx%d_%s_%s_ns%6.2f',...
%        strpic,nDim(1),nDim(2),stype,getString(dgrd),nsigma);
%imwrite(res,sprintf('./results/res_%s.tif',s));
%save(sprintf('./results/psnrs_%s',s),'psnr','mse','ssim')

%%
figure(2) 
imshow(x)
figure(3) 
imshow(y)
figure(4)
imshow(ycubic)
