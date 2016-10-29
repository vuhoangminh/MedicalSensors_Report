% MAIN_HEURISTICSURELETSHRINKAGE: Shrinkage Denoising with wavelets
%
% SVN identifier:
% $Id: main_hssoshrinkage.m 374 2013-01-30 00:08:46Z sho $
%
% Requirements: MATLAB R2011a
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
close all; clear all; clc

%% Download ssim_index.m if it is absent
if ~exist('ssim_index.m','file')
    ssimcode = ...
        urlread('https://ece.uwaterloo.ca/~z70wang/research/ssim/ssim_index.m');
    fid = fopen('ssim_index.m','w');
    fwrite(fid,ssimcode);
    fprintf('ssim_index.m was downloaded.\n');
else
    fprintf('ssim_index.m already exists.\n');
end

if ~exist('OWT_SURELET','dir')
    fprintf('Downloading OWT_SURELET.zip.\n');
    url = 'http://bigwww.epfl.ch/demo/suredenoising/matlab/OWT_SURELET.zip';
    unzip(url,'./OWT_SURELET')
    fprintf('Done!\n');
end

addpath('./OWT_SURELET/OWT SURE-LET')

%% Read test images

download_testimg('goldhill.png');
srcImg{1} = imread('./images/goldhill.png');
%
download_testimg('lena.png');
srcImg{2} = imread('./images/lena.png');
%
download_testimg('baboon.png');
srcImg{3} = imread('./images/baboon.png');
%
download_testimg('barbara.png');
srcImg{4} = imread('./images/barbara.png');

picture = { 'goldhill' 'lena' 'baboon' 'barbara' };

%{
for iImg = 1:length(srcImg)
    subplot(1,2,iImg), subimage(srcImg{iImg});
    axis off;
end
drawnow
%}

%% 
sigma = [10 20 30 40 50];
wtype = { 'sym5' 'son4' 'udn4' };
%
shfcn{1} = @(x) OWT_SURELET_denoise(x,wtype{1});
%
load('../icassp2012/filters/data128x128ampk3l3/ga/lppufb2dDec22Ord44Alp0.0Dir1Vm2.mat');
shfcn{2} = @(x) NSGenLOT_SURELET_denoise(x,lppufb);
%
shfcn{3} = @(x) HSDirLOT_SURELET_denoise(x);

%%
for iImg = 1:length(srcImg)
    src = srcImg{iImg};
    p = im2double(src);
    psnr = zeros(length(sigma),length(wtype));
    ssim = zeros(length(sigma),length(wtype));
    mse = zeros(length(sigma),length(wtype));
    for iSigma = 1:length(sigma)
        ssigma = sigma(iSigma);
        v = (ssigma/255)^2;
        strpic = picture{iImg};
        fnoisy = sprintf('./images/noisy_%s_%d_0.tif',...
            strpic,ssigma);
        if exist(fnoisy,'file')
            fprintf('\n')
            disp(['Read ' fnoisy])
            b = im2double(imread(fnoisy));
        else
            fprintf('\n')
            disp(['Generate ' fnoisy])
            b = imnoise(p,'gaussian',0,v);
            imwrite(im2uint8(b),fnoisy);
        end
        cpsnr = cell(1,length(shfcn));
        cssim = cell(1,length(shfcn));
        cmse = cell(1,length(shfcn));
        fprintf('\n%s %d\n',strpic,ssigma)
        for iFcn=1:length(shfcn)
            y = shfcn{iFcn}(b);
            [cpsnr{iFcn},cmse{iFcn}] = fcn_psnr4peak1(p,y);
            res = im2uint8(y);
            cssim{iFcn} = ssim_index(src,res);
            disp(['(' wtype{iFcn} ') mse= ' num2str(cmse{iFcn}*255^2) ...
                ', psnr=' num2str(cpsnr{iFcn}) ' [dB]' ...
                ', ssim=' num2str(cssim{iFcn}) ]);
            imwrite(res,sprintf('./images/result_%s_%s_%d.tif',...
                wtype{iFcn},strpic,ssigma));
        end
        for iFcn=1:length(shfcn)
            psnr(iSigma,iFcn) = cpsnr{iFcn};
            mse(iSigma,iFcn) = cmse{iFcn};
            ssim(iSigma,iFcn) = cssim{iFcn};
        end
        for iTrial = 1:4
            fnoisy = sprintf('./images/noisy_%s_%d_%d.tif',...
                strpic,ssigma,iTrial);
            if exist(fnoisy,'file')
                fprintf('\n')
                disp(['Read ' fnoisy])
                b = im2double(imread(fnoisy));
            else
                fprintf('\n')
                disp(['Generate ' fnoisy])
                b = imnoise(p,'gaussian',0,v);
                imwrite(im2uint8(b),fnoisy);
            end
            fprintf('\n%s %d\n',strpic,ssigma)
            parfor iFcn=1:length(shfcn)
                y = shfcn{iFcn}(b);
                [cpsnr{iFcn},cmse{iFcn}] = fcn_psnr4peak1(p,y);
                res = im2uint8(y);
                cssim{iFcn} = ssim_index(src,res);
                disp(['(' wtype{iFcn} ') mse= ' num2str(cmse{iFcn}*255^2) ...
                    ', psnr=' num2str(cpsnr{iFcn}) ' [dB]' ...
                    ', ssim=' num2str(cssim{iFcn}) ]);
            end
            for iFcn=1:length(shfcn)
                psnr(iSigma,iFcn) = psnr(iSigma,iFcn) + ...
                    (cpsnr{iFcn} - psnr(iSigma,iFcn) ) / (iTrial + 1 );
                ssim(iSigma,iFcn) = ssim(iSigma,iFcn) + ...
                    (cssim{iFcn} - ssim(iSigma,iFcn) ) / (iTrial + 1 );
                mse(iSigma,iFcn) = mse(iSigma,iFcn) + ...
                    (cmse{iFcn} - mse(iSigma,iFcn) ) / (iTrial + 1 );
            end
        end
        disp(psnr)
        disp(ssim)
        disp(mse)
        save(sprintf('./results/surelet_psnrs_%s',picture{iImg}),...
            'sigma','wtype','psnr','mse','ssim')
    end
end
