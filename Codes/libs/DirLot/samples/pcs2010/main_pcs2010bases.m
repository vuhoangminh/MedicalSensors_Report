% MAIN_PCS2010BASES
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

%%
close all
nPoints = [128 128];

isOutput = false;

%%
load('lppufb2dDec22Ord02Alp-0.6Dir1Vmd-30.00h.mat')

figure(1)
psa = flipud(getSubbandAssignment(sbsp,nPoints));
imshow(psa/max(psa(:)))
colormap(jet)

figure(2)
for idx=1:4
    subplot(2,2,idx), freqz2(lppufb(idx))
end

figure(3)
dispBasisImages(lppufb)

if isOutput
    imwrite(lppufb(1)+0.5,'./images/bi_hor0rev.tif')
    imwrite(lppufb(2)+0.5,'./images/bi_hor1rev.tif')
    imwrite(lppufb(3)+0.5,'./images/bi_hor2rev.tif')
    imwrite(lppufb(4)+0.5,'./images/bi_hor3rev.tif')
end

%%
load('lppufb2dDec22Ord20Alp-0.6Dir2Vmd120.00h.mat')

figure(4)
psa = flipud(getSubbandAssignment(sbsp,nPoints));
imshow(psa/max(psa(:)))
colormap(jet)

figure(5)
for idx=1:4
    subplot(2,2,idx), freqz2(lppufb(idx))
end

figure(6)
dispBasisImages(lppufb)

if isOutput
    imwrite(lppufb(1)+0.5,'./images/bi_ver0rev.tif')
    imwrite(lppufb(2)+0.5,'./images/bi_ver1rev.tif')
    imwrite(lppufb(3)+0.5,'./images/bi_ver2rev.tif')
    imwrite(lppufb(4)+0.5,'./images/bi_ver3rev.tif')
end
