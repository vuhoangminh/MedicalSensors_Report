% MAIN_SWEEPLAMBDA: Shrinkage Denoising with wavelets
%
% SVN identifier:
% $Id: main_wvshrinkage.m 184 2011-08-17 14:13:14Z sho $
%
% Requirements: MATLAB R2011a
%
% Copyright (c) 2011, Shogo MURAMATSU
%
% All rights reserved.
%1
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
iLevel = 7;
sigma = 20;
pictures = { 'goldhill' 'lena' 'baboon' 'barbara' };

wtype = { 'db5' 'son4' 'udn4' 'udn4bcr' 'nsctmfdmf5' };
lmax = 0.5;

for iPic = 1:length(pictures)
    picture = pictures{iPic};
    download_testimg(sprintf('%s.png',picture));
    srcImg = imread(sprintf('./images/%s.png',picture));
    for lambda = 0:0.02:lmax
        slmda = sprintf('lmd%4.2f',lambda);
        shfcn{1} = @(x) fcn_wvshrink(x,lambda,wtype{1},iLevel);
        shfcn{2} = @(x) fcn_sowvshrink(x,lambda,iLevel);
        shfcn{3} = @(x) fcn_hssowvshrink(x,lambda,iLevel);
        shfcn{4} = @(x) fcn_bcrsowvshrink(x,lambda,iLevel);
        shfcn{5} = @(x) fcn_hsnsctshrink(x,{'maxflat' 'dmaxflat5'},...
            [ 1 2 ], [ 1/2 1 ],lambda);
        % [ 3 3 3 4 ], [1/32 1/8 1/4 1],lambda);
        
        %
        src = srcImg;
        p = im2double(src);
        psnr = zeros(1,length(wtype));
        ssim = zeros(1,length(wtype));
        mse = zeros(1,length(wtype));
        ssigma = sigma;
        v = (ssigma/255)^2;
        strpic = picture;
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
        cpsnr = cell(1,length(shfcn));
        cssim = cell(1,length(shfcn));
        cmse = cell(1,length(shfcn));
        fprintf('\n%s %d\n',strpic,ssigma)
        parfor iFcn=1:length(shfcn)
            y = shfcn{iFcn}(b);
            [cpsnr{iFcn},cmse{iFcn}] = fcn_psnr4peak1(p,y);
            res = im2uint8(y);
            cssim{iFcn} = ssim_index(src,res);
            disp(['(' wtype{iFcn} ') mse= ' num2str(cmse{iFcn}*255^2) ...
                ', psnr=' num2str(cpsnr{iFcn}) ' [dB]' ...
                ', ssim=' num2str(cssim{iFcn}) ]);
            imwrite(res,sprintf('./images/sweep_result_%s_%s_%s_lv%d_%d.tif',...
                wtype{iFcn},strpic,slmda,iLevel,ssigma));
        end
        for iFcn=1:length(shfcn)
            psnr(1,iFcn) = cpsnr{iFcn};
            mse(1,iFcn) = cmse{iFcn};
            ssim(1,iFcn) = cssim{iFcn};
        end
        disp(psnr)
        disp(ssim)
        disp(mse)
        save(sprintf('./results/sweep_lambda_%s_lv%d_%s_%d.mat',...
            slmda,iLevel,picture,ssigma),...
            'sigma','wtype','psnr','mse','ssim')
    end
end
