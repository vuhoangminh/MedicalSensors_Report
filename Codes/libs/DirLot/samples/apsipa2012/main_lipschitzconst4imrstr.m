% MAIN_LIPSCTHITZCONST4IMRSTR Pre-calculation of Lipshitz Constant
%
% SVN identifier:
% $Id: main_lipschitzconst4imrstr.m 361 2012-12-12 01:55:55Z sho $
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

%% Parameter settings
nDim = [512 512];

%% Instantiation of degradation
idx = 0;
% Super-resolution
idx = idx+1;
dfactor = 2;
shblur = 'gaussian_wide';
dgrd{idx} = istaimrstr.Decimation(dfactor,shblur);

idx = idx+1;
dfactor = 4;
shblur = 'gaussian_wide';
dgrd{idx} = istaimrstr.Decimation(dfactor,shblur);

% Deblurring
idx = idx+1;
sigma = 2;
shblur = 'gaussian';
dgrd{idx} = istaimrstr.Blur(shblur,sigma);

idx = idx+1;
sigma = 4;
shblur = 'gaussian';
dgrd{idx} = istaimrstr.Blur(shblur,sigma);

% Inpainting
idx = idx+1;
losstype = 'random';
density = 0.2;
seed = 0;
dgrd{idx} = istaimrstr.PixelLoss(losstype,density,seed);

idx = idx+1;
losstype = 'random';
density = 0.4;
seed = 0;
dgrd{idx} = istaimrstr.PixelLoss(losstype,density,seed);

%% Run pre-calculation of Lipschitz constants
for idx = 1:length(dgrd)
    valueL = getLipschitzConstantOverK(dgrd{idx},nDim);
    disp([getString(dgrd{idx}) ': ' num2str(valueL)])
end
