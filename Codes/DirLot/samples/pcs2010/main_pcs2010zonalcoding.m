% MAIN_PCS2010DESIGN_ALP0
%
% SVN identifier:
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
close all
isOutput = false;

phix = -30; % Ramp direction
dim = [48 48 ];

%% DirLOT
load('lppufb2dDec22Ord02Alp-0.6Dir1Vmd-30.00h.mat')

[I,S,J] = zonalcoding(lppufb,phix,dim);

%% Display
figure(1)
imshow(I)
title('Original')

figure(2)
imshow(S)
title('Subband (DirLOT)')

figure(3)
imshow(J)
title('Result (DirLOT)')

if isOutput
    % Source
    fname = sprintf('./images/srcImg%06.2f.tif',phix);
    imwrite(I,fname)
    % Subband
    fname = sprintf('./images/subbandDirLot%06.2f.tif',phix);
    imwrite(S,fname)
    % Reconstructed
    fname = sprintf('./images/rstImgDirLot%06.2f.tif',phix);
    imwrite(J,fname)
end

%% PSNR
psnr = 10*log10( numel(I)/sum((I(:)-J(:)).^2));
fprintf('psnr(DirLOT) = %5.2f [dB]\n',psnr);

%% Haar
% haar = LpPuFb2d([2 2],[0 0],0,1,0);
haar = LpPuFb2dFactory.createLpPuFb2d(0,[2 2],[0 0],0,1);

[I,S,J] = zonalcoding(haar,phix,dim);

%% Display
figure(4)
imshow(S)
title('Subband (Haar)')

figure(5)
imshow(J)
title('Result (Haar)')

if isOutput
    % Subband
    fname = sprintf('./images/subbandHaar%06.2f.tif',phix);
    imwrite(S,fname)
    % Reconstructed
    fname = sprintf('./images/rstImgHaar%06.2f.tif',phix);
    imwrite(J,fname)
end

%% PSNR
psnr = 10*log10( numel(I)/sum((I(:)-J(:)).^2));
fprintf('psnr(Haar) = %5.2f [dB]\n',psnr);
