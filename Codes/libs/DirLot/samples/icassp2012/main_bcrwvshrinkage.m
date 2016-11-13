% MAIN_WVSHRINKAGE: Shrinkage Denoising with wavelets
%
% SVN identifier:
% $Id: main_wvshrinkage.m 184 2011-08-17 14:13:14Z sho $
%
% Requirements: MATLAB R2011a
%
% Copyright (c) 2011, Shogo MURAMATSU
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

%%
%{
for iImg = 1:length(srcImg)
    subplot(2,2,iImg), subimage(srcImg{iImg});
    axis off;
end
drawnow
%}

%%
maxLevel = 7;
minLevel = 7;
sigma = [20 30 40]; %[10 20 30 40 50];
picture = { 'goldhill' 'lena' 'baboon' 'barbara' };
wtype ='udn4bcr';

for lambda = -1:-1 %[0.1 0.2 0.3 0.4 -1]
    if lambda > 0
        slmda = sprintf('lmd%4.2f',lambda);
    else
        slmda = 'bayes';
    end
    for iLevel = maxLevel:-1:minLevel
        shfcn = @(x) fcn_bcrsowvshrink(x,lambda,iLevel);
        %
        for iImg = 1:length(srcImg)
            src = srcImg{iImg};
            strpic = picture{iImg};
            p = im2double(src);
            psnr = zeros(length(sigma),1);
            ssim = zeros(length(sigma),1);
            mse = zeros(length(sigma),1);
            parfor iSigma = 1:length(sigma)
                ssigma = sigma(iSigma);
                v = (ssigma/255)^2;
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
                    imwrite(b,fnoisy);
                end
                fprintf('\n%s %d\n',strpic,ssigma)
                y = shfcn(b);
                [cpsnr,cmse] = fcn_psnr4peak1(p,y);
                res = im2uint8(y);
                cssim = ssim_index(src,res);
                disp(['(' wtype ') mse= ' num2str(cmse*255^2) ...
                    ', psnr=' num2str(cpsnr) ' [dB]' ...
                    ', ssim=' num2str(cssim) ]);
                imwrite(res,sprintf('./images/result_%s_%s_%s_lv%d_%d.tif',...
                    wtype,strpic,slmda,iLevel,ssigma));
                psnr(iSigma) = cpsnr;
                mse(iSigma) = cmse;
                ssim(iSigma) = cssim;
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
                        imwrite(b,fnoisy);
                    end
                    fprintf('\n%s %d\n',strpic,ssigma)
                    y = shfcn(b);
                    [cpsnr,cmse] = fcn_psnr4peak1(p,y);
                    res = im2uint8(y);
                    cssim = ssim_index(src,res);
                    disp(['(' wtype ') mse= ' num2str(cmse*255^2) ...
                        ', psnr=' num2str(cpsnr) ' [dB]' ...
                        ', ssim=' num2str(cssim) ]);
                    psnr(iSigma) = psnr(iSigma) + ...
                        (cpsnr - psnr(iSigma) ) / (iTrial + 1 );
                    ssim(iSigma) = ssim(iSigma) + ...
                        (cssim - ssim(iSigma) ) / (iTrial + 1 );
                    mse(iSigma) = mse(iSigma) + ...
                        (cmse - mse(iSigma) ) / (iTrial + 1 );
                end
            end
            disp(psnr)
            disp(ssim)
            disp(mse)
            save(sprintf('./results/bcrwv_psnrs_%s_lv%d_%s.mat',...
                slmda,iLevel,picture{iImg}),...
                'sigma','wtype','psnr','mse','ssim')
        end
    end
end