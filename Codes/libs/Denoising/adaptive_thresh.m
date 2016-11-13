% INPUTS:
%   I      Image Data

% OUTPUTS:
%   lowThresh  low Threshold value
%   highThresh high Threshold value

function [lowThresh, highThresh]= adaptive_thresh(I)
PercentOfPixelsNotEdges = .7; % Used for selecting thresholds
ThresholdRatio = .4;          % Low thresh is this fraction of the high.
sigma  = 2;                   % Sigma  standard deviation of Gaussian
thresh = [];                  % Thresh Threshold value
% Calculate gradients using a derivative of Gaussian filter
[dx, dy] = smoothGradient(I, sigma);

% Calculate Magnitude of Gradient
magGrad = hypot(dx, dy);

% Normalize for threshold selection
magmax = max(magGrad(:));
if magmax > 0
    magGrad = magGrad / magmax;
end

% Determine Hysteresis Thresholds
[lowThresh, highThresh] = selectThresholds(thresh, magGrad, PercentOfPixelsNotEdges, ThresholdRatio, mfilename);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : smoothGradient
%
function [GX, GY] = smoothGradient(I, sigma)
    % Create an even-length 1-D separable Derivative of Gaussian filter

    % Determine filter length
    filterLength = 8*ceil(sigma);
    n = (filterLength - 1)/2;
    x = -n:n;

    % Create 1-D Gaussian Kernel
    c = 1/(sqrt(2*pi)*sigma);
    gaussKernel = c * exp(-(x.^2)/(2*sigma^2));

    % Normalize to ensure kernel sums to one
    gaussKernel = gaussKernel/sum(gaussKernel);

    % Create 1-D Derivative of Gaussian Kernel
    derivGaussKernel = gradient(gaussKernel);

    % Normalize to ensure kernel sums to zero
    negVals = derivGaussKernel < 0;
    posVals = derivGaussKernel > 0;
    derivGaussKernel(posVals) = derivGaussKernel(posVals)/sum(derivGaussKernel(posVals));
    derivGaussKernel(negVals) = derivGaussKernel(negVals)/abs(sum(derivGaussKernel(negVals)));

    % Compute smoothed numerical gradient of image I along x (horizontal)
    % direction. GX corresponds to dG/dx, where G is the Gaussian Smoothed
    % version of image I.
    GX = imfilter(I, gaussKernel', 'conv', 'replicate');
    GX = imfilter(GX, derivGaussKernel, 'conv', 'replicate');

    % Compute smoothed numerical gradient of image I along y (vertical)
    % direction. GY corresponds to dG/dy, where G is the Gaussian Smoothed
    % version of image I.
    GY = imfilter(I, gaussKernel, 'conv', 'replicate');
    GY  = imfilter(GY, derivGaussKernel', 'conv', 'replicate');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : selectThresholds
%
function [lowThresh, highThresh] = selectThresholds(thresh, magGrad, PercentOfPixelsNotEdges, ThresholdRatio, ~)

[m,n] = size(magGrad);

% Select the thresholds
if isempty(thresh)
    counts=imhist(magGrad, 64);
    highThresh = find(cumsum(counts) > PercentOfPixelsNotEdges*m*n,...
        1,'first') / 64;
    lowThresh = ThresholdRatio*highThresh;
elseif length(thresh)==1
    highThresh = thresh;
    if thresh>=1
        error(message('images:edge:thresholdMustBeLessThanOne'))
    end
    lowThresh = ThresholdRatio*thresh;
elseif length(thresh)==2
    lowThresh = thresh(1);
    highThresh = thresh(2);
    if (lowThresh >= highThresh) || (highThresh >= 1)
        error(message('images:edge:thresholdOutOfRange'))
    end
end

