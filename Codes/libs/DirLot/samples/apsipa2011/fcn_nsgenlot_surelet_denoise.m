function output = fcn_nsgenlot_surelet_denoise(input,wtype,sigma)
%FCN_NSGENLOT_SURELET_DENOISE Removes additive Gaussian white noise using the
%   inter-scale SURE-LET principle in the framework of an orthonormal
%   wavelet transform (OWT).
% 	
%   output = FCB_NSGENLOT_SURELET_DENOISE(input,wtype,sigma) performs an inter-scale
%   orthonormal wavelet thresholding based on the principle exposed in [1].
%
%   Input:
%   - input : noisy signal of size [nx,ny].
%   - (OPTIONAL) wtype : an object of class LpPuFb2dAbst
%   - (OPTIONAL) sigma : standard deviation of the additive Gaussian white
%   noise. By default 'sigma' is estimated using a robust median
%   estimator.
% 	
%   Output:
%   - output : denoised signal of the same size as 'input'.
%
% SVN identifier:
% $Id: main_wvshrinkage.m 184 2011-08-17 14:13:14Z sho $
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
%   References:
%   [1] F. Luisier, T. Blu, M. Unser, "A New SURE Approach to Image
%   Denoising: Interscale Orthonormal Wavelet Thresholding," 
%   IEEE Transactions on Image Processing, vol. 16, no. 3, pp. 593-606, 
%   March 2007.

if(nargin<2)
    wtype = eznsgenlot22(0);
end

paramMtx = getParameterMatrices(wtype);
dec = 2;

[nx,ny] = size(input);

% Compute the Most Suitable Number of Iterations
%-----------------------------------------------
J = aux_num_of_iters([nx,ny]);
nLevels = min(J);
fprintf(['nLevels = ' num2str(nLevels) '\n'])
if(nLevels==0)
    disp('The size of the signal is too small to perform a reliable denoising based on statistics.');
    output = input;
    return;
end
nBands = 3*nLevels+1;

%% Orthonormal Wavelet Transform
%------------------------------
fdirlot = ForwardDirLot([dec dec],paramMtx,'circular');
WT = cell(nBands,1);
LL = cell(nLevels,1);
nOrientations = 3;
coefLL = input;
for iLevel = nLevels:-1:1
    fdirlot = forwardTransform(fdirlot,coefLL);
    coefs = getSubbandCoefs(fdirlot);
    LL{iLevel} = coefs{1};
    idx = 3*iLevel-2;
    for iOrientation=1:nOrientations
        iSubband = idx+iOrientation;
        WT{iSubband} = coefs{iOrientation+1}; 
    end
    coefLL = coefs{1};
    %figure, imshow(WTp{iLevel}/max(max(WTp{iLevel})))
end
WT{1} = coefLL;
denoisedWT = WT;

%% Estimation of the Noise Standard Deviation 
%-------------------------------------------
if(nargin<3)
    if(nLevels>0)
        HH = WT{nBands-2};
    end
    sigma = median(abs(HH(:)))/0.6745;
    fprintf(['\nEstimated Noise Standard Deviation: ' num2str(sigma,'%.2f') '\n']);
end

%% Denoising Part
%------------------
w = cell(nOrientations);
for iOrientation=1:nOrientations
    h = wtype(iOrientation+1);
    w{iOrientation} = h/norm(h(:));
end
for iLevel = 1:nLevels
    idx = 3*iLevel-2;
    for iOrientation=1:nOrientations
        iSubband = idx+iOrientation;
        Y = WT{iSubband};
        Yp = abs(imfilter(LL{iLevel},w{iOrientation},'conv','circular'));
        Yp = aux_gaussian_smoothing(Yp,1);
        denoisedWT{iSubband} = fcn_min_sure(Y,Yp,sigma);
    end
end

%% Inverse transform
%------------------
idirlot = InverseDirLot([dec dec],paramMtx,'circular');
output = iwaveletDirLot(idirlot,denoisedWT,nLevels);