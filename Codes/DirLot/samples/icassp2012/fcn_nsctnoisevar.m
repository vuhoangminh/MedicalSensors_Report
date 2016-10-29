function varw = fcn_nsctnoisevar(sigma, nLevels)
% Variance ratios among scales in NSCT for AWGN
if nargin < 1
    sigma = 30;
end
% NSCT Toolbox is required, which is available from MATLAB Central
% http://www.mathworks.com/matlabcentral/
addpath('./nsct_toolbox');

%% Contourlet setting
if nargin < 2
    nLevels = [ 3, 3, 4, 4 ]; % Decomposition level
end
pfilter = 'maxflat' ;              % Pyramidal filter
dfilter = 'dmaxflat7' ;              % Directional filter

%% Noise
nTrials = 32;
snLevels = cell(nTrials,1);
sv = cell(nTrials,1);
for idx = 1:nTrials
    snLevels{idx} = nLevels;
    sv{idx} = (sigma/255)^2;
end
parfor idx = 1:nTrials
    % Noise picture
    p = im2double(zeros(256,256));
    m = 0;
    b = imnoise(p,'gaussian',m,sv{idx});

    % Nonsubsampled Contourlet decomposition
    coefs = nsctdec( b, snLevels{idx}, dfilter, pfilter );
    
   % Noise variances
    nLevels = length(coefs);
    nw = zeros(1,nLevels);
    c = coefs{1};
    nw(1) = var(c(:));
    for iLevel=2:nLevels
        nDirs = length(coefs{iLevel});
        for iDir = 1:nDirs
            c = cell2mat(coefs{iLevel});
            v = var(c(:));
            nw(iLevel) = v;
        end
    end
    nw = nw/nw(nLevels);
    lvarw{idx} = nw;
end
varw = 0;
for idx = 1:nTrials
    varw = varw + lvarw{idx};
end
varw = varw/nTrials;