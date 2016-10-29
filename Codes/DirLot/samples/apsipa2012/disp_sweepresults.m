% MAIN_SWEEPRESULTS
%
% SVN identifier:
% $Id: disp_sweepresults.m 358 2012-12-12 01:19:47Z sho $
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
clear all
imgstrset = { 'goldhill' 'lena' 'barbara' 'baboon' };
nImgs = length(imgstrset);
imgset = cell(1,nImgs);
partimgstrset = cell(1,nImgs);
for iimg = 1:nImgs
    [imgset{iimg}, partimgstrset{iimg}] = load_testimg(imgstrset{iimg});
end
%
nLevelsDirSowt = 6;
nTrx = 5;
nLevelsNsWt = 2;
%
isverbose = false;
isminord = false;

%% Degradation
dgrd = cell(1,3);
idgrd = 1;
%
sigma = 2;
shblur = 'gaussian';
dgrd{idgrd} = istaimrstr.Blur(shblur,sigma);
nsgm{idgrd} = 5;
idgrd = idgrd+1;
%
dfactor = 2;
shblur = 'gaussian_wide';
dgrd{idgrd} = istaimrstr.Decimation(dfactor,shblur);
nsgm{idgrd} = 0;
idgrd = idgrd+1;
%
losstype = 'random';
density = 0.2;
seed = 0;
dgrd{idgrd} = istaimrstr.PixelLoss(losstype,density,seed);
nsgm{idgrd} = 0;
idgrd = idgrd+1;

%% Pictures
src = cell(1,nImgs);
p = cell(1,nImgs);
x = cell(nImgs,length(dgrd));
for iImg = 1:nImgs
    p{iImg} = im2double(imgset{iImg});
    for idgrd = 1:length(dgrd)
        x{iImg,idgrd} = ...
            observation(dgrd{idgrd},p{iImg},partimgstrset{iImg},nsgm{idgrd});
    end
end

%% Solvers
istarstr = cell(2,length(dgrd));
lambda = 0;
for idgrd = 1:length(dgrd)
    % NsHaarWt
    istarstr{1,idgrd} = ...
        istaimrstr.NsHaarWtIstaImRestoration(dgrd{idgrd},...
        lambda,nLevelsNsWt);
    % DirSowt
    istarstr{2,idgrd} = ...
        istaimrstr.DirSowtIstaImRestoration(dgrd{idgrd},...
        lambda,nLevelsDirSowt,nTrx,isminord);
end
strrstr{1} = 'dirsowt';
strrstr{2} = 'nshaarwt';
strtrxlv{1} = nLevelsDirSowt;
strtrxlv{2} = nLevelsNsWt;

psnrtcell = cell(length(dgrd),nImgs,size(istarstr,1));
plmdtcell = cell(length(dgrd),nImgs,size(istarstr,1));
ssimtcell = cell(length(dgrd),nImgs,size(istarstr,1));
slmdtcell = cell(length(dgrd),nImgs,size(istarstr,1));
for iImg = 1:nImgs
    pp = p{iImg};
    ssrc = src{iImg};
    for irstr = 1:size(istarstr,1)
        for idgrd = 1:length(dgrd)
            noise_var = (nsgm{idgrd}/255)^2;
            estimated_snr = noise_var/var(pp(:));
            scnd = sprintf('%s_%s_ns%06.2f',...
                partimgstrset{iImg},...
                getString(istarstr{irstr,idgrd}),...
                nsgm{idgrd});
            idxlmd = strfind(scnd,'lmd0.0000');
            scnd(idxlmd:idxlmd+8) = 'lmd*.****';
            psnrsname = sprintf('./results/psnrs_%s.mat',scnd);
            flist = dir(psnrsname);
            if numel(flist) > 0
                fname = sprintf('./results/%s',flist(1).name);
                S =  load(fname,'-mat','lambda','psnr','ssim');
                lambda = S.lambda;
                psnr = S.psnr;
                figure(1),plot(lambda,psnr)
                grid on
                axis([min(lambda(:)) max(lambda(:)) 0 40 ])
                xlabel('\lambda')
                ylabel('PSNR')
                ssim = S.ssim;
                figure(2),plot(lambda,ssim)
                axis([min(lambda(:)) max(lambda(:)) 0 1])
                grid on
                xlabel('\lambda')
                ylabel('SSIM')
                %
                fprintf('%s\n',fname);
                [maxpsnr,ipsnr] = max(psnr(:));
                fprintf('MAX PSNR = %6.3f ( %7.5f )\n', maxpsnr, lambda(ipsnr))
                psnrtcell{idgrd,iImg,irstr} = maxpsnr;
                plmdtcell{idgrd,iImg,irstr} = lambda(ipsnr);
                [maxssim,issim] = max(ssim(:));
                fprintf('MAX SSIM = %6.4f ( %7.5f )\n', maxssim, lambda(issim))
                ssimtcell{idgrd,iImg,irstr} = maxssim;
                slmdtcell{idgrd,iImg,irstr} = lambda(issim);
                %
            else
                fprintf('%s does not exist...\n',psnrsname);
            end
            display('enter any key...')
            pause
        end
        %{
        [vv,ss] = typicalReference(dgrd{idgrd},im2double(xx),estimated_snr);
        %imshow(vv)
        strvv = sprintf('./images/%s_%dx%d_%s_%s.tif',...
                imgset{iImg},nDim(1),nDim(2),getString(dgrd{idgrd}),ss);
        disp(strvv)
        imwrite(vv,strvv)
        %y = getResult(istaimrstr);
        [psnr,mse] = fcn_psnr4peak1(pp,vv);
        res = im2uint8(vv);
        ssim = ssim_index(ssrc,res);
        disp(['mse= ' num2str(mse*255^2) ...
            ', psnr=' num2str(psnr) ' [dB]' ...
            ', ssim=' num2str(ssim) ]);
        fprintf('\n')
        %}
    end
end

%%
for iProcess = 1:length(dgrd)
    fprintf('%d\n',iProcess)
    for iImg = 1:nImgs
        fprintf('%10s ',imgstrset{iImg})
        for irstr = 1:size(istarstr,1)
            fprintf('%5.2f (%7.5f) ',psnrtcell{iProcess,iImg,irstr},...
                plmdtcell{iProcess,iImg,irstr});
        end
        fprintf('\n')
    end
end

%%
for iProcess = 1:length(dgrd)
    fprintf('%d\n',iProcess)
    for iImg = 1:nImgs
        fprintf('%10s ',imgstrset{iImg})
        for irstr = 1:size(istarstr,1)
            fprintf('%5.3f (%7.5f) ',ssimtcell{iProcess,iImg,irstr},...
                slmdtcell{iProcess,iImg,irstr});
        end
        fprintf('\n')
    end
end

