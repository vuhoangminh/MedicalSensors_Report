function original_of_main_icip2009dwt97(aveRate)
% MAIN_ICIP2009DWT97
%
% SVN identifier:
% $Id: original_of_main_icip2009dwt97.m 244 2011-11-22 14:18:13Z sho $
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

%% 2-Level 9/7 Forward Dwt
[subLL1,subHL1,subLH1,subHH1] = im97trnscq_ip(I);
[subLL2,subHL2,subLH2,subHH2] = im97trnscq_ip(subLL1);
coefs{1} = subLL2;
coefs{2} = subHL2;
coefs{3} = subLH2;
coefs{4} = subHH2;
coefs{5} = subHL1;
coefs{6} = subLH1;
coefs{7} = subHH1;

%% ECSQ for biorthogonal transforms
etaSet = [1/16 1/16 1/16 1/16 1/4 1/4 1/4];
ebsqrd =1;
cb = 1/12;
nDecs = 7;
elementSet = zeros(1,nDecs);
for iSubband = 1:nDecs
    elementSet(iSubband) = var(coefs{iSubband}(:));
end
gainSet(1) = 4.122409873969057;
gainSet(2) = 1.996812457154978;
gainSet(3) = 1.996812457154978;
gainSet(4) = 0.967215806032981;
gainSet(5) = 1.011286475626873;
gainSet(6) = 1.011286475626873;
gainSet(7) = 0.520217981897461;
bitRates = posBitAssign(aveRate,elementSet,etaSet,gainSet);
for iSubband = 1:nDecs
    qStep = sqrt(ebsqrd*elementSet(iSubband)/cb)*2^(-bitRates(iSubband));
    s = coefs{iSubband};
    q = sign(s).*floor(abs(s/qStep));
    coefs{iSubband} = sign(q).*(abs(q)+0.5)*qStep; % #ok
end

%% 2-Level 9/7 Inverse Dwt
subLL2 = coefs{1};
subHL2 = coefs{2};
subLH2 = coefs{3};
subHH2 = coefs{4};
subHL1 = coefs{5};
subLH1 = coefs{6};
subHH1 = coefs{7};
subLL1 = im97itrnscq_ip(subLL2,subHL2,subLH2,subHH2);
X = im97itrnscq_ip(subLL1,subHL1,subLH1,subHH1);

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

