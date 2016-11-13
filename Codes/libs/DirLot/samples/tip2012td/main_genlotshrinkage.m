% MAIN_GENLOTSHRINKAGE: Shrinkage Denoising with GENLOT
%
% SVN identifier:
% $Id: main_nsctshrinkage.m 184 2011-08-17 14:13:14Z sho $
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
    fprintf('Downloading ssim_index.m.\n');
    ssimcode = ...
    urlread('https://ece.uwaterloo.ca/~z70wang/research/ssim/ssim_index.m');
    fid = fopen('ssim_index.m','w');
    fwrite(fid,ssimcode);
    fprintf('Done!\n');
else
    fprintf('ssim_index.m already exists.\n');
    fprintf('See %s\n', ...
        'https://ece.uwaterloo.ca/~z70wang/research/ssim/');
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
sigma = [10 20 30 40 50];
picture = {'goldhill' 'lena' 'baboon' 'barbara' };
ord = 2;
wtype = sprintf('gltn%d',ord);
shfcn = @(x) fcn_genlotshrink(x,ord);

%%
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
        ssigma = sigma(iSigma);
        fprintf('\n%s %d\n',strpic,ssigma)
        y = shfcn(b);
        [psnr(iSigma),mse(iSigma)] = fcn_psnr4peak1(p,y);
        res = im2uint8(y);
        ssim(iSigma) = ssim_index(src,res);
            disp(['(' wtype ') mse= ' num2str(mse(iSigma)*255^2) ...
                ', psnr=' num2str(psnr(iSigma)) ' [dB]' ...
                ', ssim=' num2str(ssim(iSigma)) ]);            
        imwrite(res,sprintf('./images/result_%s_%s_%d.tif',...
            wtype,strpic,ssigma));
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
    save(sprintf('./results/genlot_psnrs_%s',picture{iImg}),...
        'sigma','wtype','psnr','mse','ssim')
end
