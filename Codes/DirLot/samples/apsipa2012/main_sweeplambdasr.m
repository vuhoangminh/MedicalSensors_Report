% MAIN_WLAMBDA4IMRSTR Pre-calculation of Shrinkage Weights
%
% SVN identifier:
% $Id: main_sweeplambdasr.m 374 2013-01-30 00:08:46Z sho $
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

nLambdas = 1000;
stepLambda = 1e-4;

%%
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

%% Super-resolution
idgrd = 0;
%
idgrd = idgrd + 1;
dfactor = 2;
shblur = 'gaussian_wide';
dgrd{idgrd} = istaimrstr.Decimation(dfactor,shblur);
nsgm{idgrd} = 0;

%% Restrators
istarstr = cell(2,length(dgrd));
lambda_ = 0;
for idgrd = 1:length(dgrd)
    % DirSowt5
    istarstr{1,idgrd} = ...
        istaimrstr.DirSowtIstaImRestoration(dgrd{idgrd},...
        lambda_,nLevelsDirSowt,nTrx,isminord);
    % NsHaarWt
    istarstr{2,idgrd} = ...
        istaimrstr.NsHaarWtIstaImRestoration(dgrd{idgrd},...
        lambda_,nLevelsNsWt);
end

%%
fcn_sweeplambda(dgrd,istarstr,imgset,partimgstrset,nsgm,nLambdas,...
    stepLambda,isverbose);