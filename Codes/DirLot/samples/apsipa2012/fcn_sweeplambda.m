function fcn_sweeplambda(dgrd,istarstr,imgset,partimgstrset,nsgm,...
    nLambdas,stepLambda,isverbose,offsetLambda)
%
% SVN identifier:
% $Id: fcn_sweeplambda.m 375 2013-01-30 01:49:35Z sho $
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

if nargin < 9
    offsetLambda = 0;
end
    
%% Download ssim_index.m if it is absent
download_ssim_index

%% Pictures
nImgs = length(imgset);
p = cell(1,nImgs);
x = cell(nImgs,length(dgrd));
for iImg = 1:nImgs
    p{iImg} = im2double(imgset{iImg});
    for idgrd = 1:length(dgrd)
        x{iImg,idgrd} = ...
            observation(dgrd{idgrd},p{iImg},partimgstrset{iImg},nsgm{idgrd});
    end
end

% MEMO:
% numlabs
% labindex

%% Sweep lambda
for iImg = 1:nImgs
    pp = p{iImg};
    ssrc = imgset{iImg};
    strpic = partimgstrset{iImg};
    for irstr = 1:size(istarstr,1)
        %s = cell(1,length(dgrd));
        for idgrd = 1:length(dgrd)
            rstr = istarstr{irstr,idgrd};
            %disp(getString(rstr))
            if isverbose
                rstr = setReference(rstr,pp);
                rstr = setMonitoring(rstr,true);
                rstr = setEvaluation(rstr,true);
                figure(1)
            end
            xx = x{iImg,idgrd};
            nnsgm = nsgm{idgrd};
            psnr = zeros(1,nLambdas);
            mse = zeros(1,nLambdas);
            ssim = zeros(1,nLambdas);
            parfor ilambda = 1:nLambdas
                lambda_ = (ilambda-1)*stepLambda + offsetLambda;
                rstr_ = istaimrstr.IstaImRestorationFactory. ...
                        createIstaImRestoration(rstr);
                rstr_ = setLambda(rstr_,lambda_);
                tic
                rstr_ = run(rstr_,xx);
                toc
                % Evaluation
                y = getResult(rstr_);
                [psnr(ilambda),mse(ilambda)] = fcn_psnr4peak1(pp,y);
                res = im2uint8(y);
                ssim(ilambda) = ssim_index(ssrc,res);
                %
                sim = sprintf('%s_%s_ns%06.2f',...
                    strpic,getString(rstr_),nnsgm);                
                disp(sim);
                disp(['(' num2str(lambda_) ')'...
                    ' mse= ' num2str(mse(ilambda)*255^2) ...
                    ', psnr=' num2str(psnr(ilambda)) ' [dB]' ...
                    ', ssim=' num2str(ssim(ilambda)) ]);
                %imwrite(res,sprintf('./results/res_%s.tif',sim));
            end                
            %
            lambda = (0:nLambdas-1)*stepLambda + offsetLambda;
            %
            [maxpsnr,idxpsnrmax] = max(psnr(:));
            [maxssim,idxssimmax] = max(ssim(:));
            maxlambdapsnr = lambda(idxpsnrmax);
            maxlambdassim = lambda(idxssimmax);
            %
            rstr = setLambda(rstr,maxlambdassim);
            scnd = sprintf('%s_%s_ns%06.2f',...
                strpic,getString(rstr),nnsgm);
            %
            psnrsname = sprintf('./results/psnrs_%s.mat',scnd);
            disp(psnrsname)
            save(psnrsname,'lambda','psnr','mse','ssim','rstr',...
                'maxpsnr','maxlambdapsnr','maxssim','maxlambdassim')
        end
    end
end
