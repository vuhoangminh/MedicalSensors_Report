function [y,coefs] = fcn_hsnsctshrink(x, filters, nLevels, nw, lambda)
% Nonsubsampling Contourlet Denoising with Heuristic Shrinkage
%
ext = mexext;
name = {'atrousc' 'zconv2' 'zconv2S'};
for idx = 1:length(name)
    fcn_repcppcmnts(sprintf('./nsct_toolbox/%s.c',name{idx}));
    cd ./nsct_toolbox
    ename = sprintf('./%s.%s',name{idx},ext);
    if ~exist(ename,'file')
        cname = sprintf('%s.c',name{idx});
        mex(cname)
        fprintf('%s was compiled!\n',cname)
    end
    ename = sprintf('./%s.dll',name{idx});
    if exist(ename,'file')
        dllname = sprintf('%s.dll',name{idx});
        movefile(dllname,sprintf('%s.org',dllname));
        fprintf('%s was renamed.\n',dllname)
    end
    cd ..
end

addpath('./nsct_toolbox');

%% Contourlet setting
if nargin < 2
    pfilter = 'maxflat' ;              % Pyramidal filter
    dfilter = 'dmaxflat5' ;              % Directional filter
else
    pfilter = filters{1};
    dfilter = filters{2};
end
if nargin < 3
    nLevels = [ 3, 3, 4, 4 ]; % Decomposition level
    nw = [ 1/32 1/8 1/4 1 ];
    %nLevels =  [ 1 2 ];
    %nw = [ 1/2 1 ];
end

if nargin < 5
    disp('BayesShrink')
    isbayes = true;
elseif lambda < 0
    disp('BayesShrink')
    isbayes = true;
else
    fprintf('lambda = %6.3f\n',lambda)
    isbayes = false;
end

%% Main Process of Heuristic Shrinkage 
% Nonsubsampled Contourlet decomposition
coefs = nsctdec( x, nLevels, dfilter, pfilter );
% Shrinkage 
if isbayes
    coefs = bayesshrinknsct(coefs,nw);
else
    coefs = softshrinknsct(coefs,nw,lambda);
end

% Reconstruct image
y = nsctrec( coefs, dfilter, pfilter );

%%
function valueNC = bayesshrinknsct(valueC,nw)
% BayesShrink for NSCT

% Estimation of standard deviation
hh1 = cell2mat(valueC{end}); %finest wavelet coefs
esigma = median(abs(hh1(:)))/.6745;
ve = esigma^2;

% Subband dependent thresholding
valueNC = cell(length(valueC),1);
valueNC{1} = valueC{1}; % Lowest component
nLevels = length(valueC);
for iLevel=2:nLevels
    nDirs = length(valueC{iLevel});
    for iDir = 1:nDirs
        c = valueC{iLevel}{iDir};
        vy = var(c(:));
        ven = ve*nw(iLevel-1); % Level dependent weight adjustment        
        sigmax = sqrt(max(vy-ven,0));
        T = min(ven/sigmax,max(abs(c(:))));
        nc = (abs(c(:))-T);
        nc(nc<0) = 0;
        valueNC{iLevel}{iDir} = sign(c).*reshape(nc,size(c));
    end
end

%%
function valueNC = softshrinknsct(valueC,nw,lambda)

% Subband dependent thresholding
valueNC = cell(length(valueC),1);
%{
c = valueC{1}; % Lowest component
T = lambda*nw(1);
nc = (abs(c(:))-T);
nc(nc<0) = 0;
valueNC{1} = sign(c).*reshape(nc,size(c));
%}
valueNC{1} = valueC{1};
nLevels = length(valueC);
for iLevel=2:nLevels
    nDirs = length(valueC{iLevel});
    for iDir = 1:nDirs
        c = valueC{iLevel}{iDir};
        T = lambda*nw(iLevel-1);
        nc = (abs(c(:))-T);
        nc(nc<0) = 0;
        valueNC{iLevel}{iDir} = sign(c).*reshape(nc,size(c));
    end
end

