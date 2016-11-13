% MAIN_WLAMBDA4IMRSTR Pre-calculation of Shrinkage Weights
%
% SVN identifier:
% $Id: main_sweeplambdaip_rev.m 383 2013-10-07 04:55:32Z sho $
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

nLambdas = 400;
stepLambda = 1e-4;

%%
imgstrset = { 'baboon128' };%{ 'goldhill128' 'lena128' 'barbara128' 'baboon128' };
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
offsetLambda = 0.01;
isminord = false;

%% Inpainting
idgrd = 0;
%
idgrd = idgrd+1;
losstype = 'random';
density = 0.2;
seed = 0;
dgrd{idgrd} = istaimrstr.PixelLoss(losstype,density,seed);
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
        istaimrstr.NsHaarWtIstaImRestorationRev(dgrd{idgrd},...
        lambda_,nLevelsNsWt);
end

%%
fcn_sweeplambda(dgrd,istarstr,imgset,partimgstrset,nsgm,nLambdas,...
    stepLambda,isverbose,offsetLambda);