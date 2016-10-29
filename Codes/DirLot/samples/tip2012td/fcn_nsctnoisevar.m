function varw = fcn_nsctnoisevar(sigma, nLevels)
% Variance ratios among scales in NSCT for AWGN
if nargin < 1
    sigma = 30;
end
% NSCT Toolbox is required, which is available from MATLAB Central
% http://www.mathworks.com/matlabcentral/

if ~exist('./nsct_toolbox','dir')
    fprintf('Downloading NSCT Toolbox.\n');
    url = 'http://www.mathworks.com/matlabcentral/fileexchange/10049-nonsubsampled-contourlet-toolbox?controller=file_infos&download=true';
    unzip(url,'.')
    fprintf('Done!\n');
end
ext = mexext;
name = {'atrousc' 'zconv2' 'zconv2S'};
for idx = 1:length(name)
    ename = sprintf('./nsct_toolbox/%s.%s',name{idx},ext);
    if ~exist(ename,'file')
        cd ./nsct_toolbox
        mex(sprintf('%s.c',name{idx}))
        fprintf('%s was compiled!\n',sprintf('%s.c',name{idx}))        
        cd ..
    end
end

addpath('./nsct_toolbox');

%% Contourlet setting
if nargin < 2
  %  nLevels = [ 3, 3, 4, 4 ]; % Decomposition level
    nLevels = [ 1, 2 ]; % Decomposition level
end
pfilter = 'maxflat' ;              % Pyramidal filter
dfilter = 'dmaxflat5' ;              % Directional filter

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