function [y,valueT] = fcn_sowvshrink(x,lambda,nLevels)
%
% Requirements: Image Processing Tbx
%
isMinOrd = false;
isdisplay = false;

if lambda < 0 
    disp('BayesShrink')    
    isbayes = true;
else
    fprintf('lambda = %6.3f\n',lambda)    
    isbayes = false;
end

%% Wavelet setting
if nargin < 3 || isempty(nLevels) || nLevels <= 0
    nLevels = floor(log2(min(size(x))))-1;
end
fprintf('#levels: %d\n',nLevels)

[sfwdtrx,sinvtrx] = fcn_gendic(isMinOrd,isdisplay);
fwdtrx = sfwdtrx{1};
invtrx = sinvtrx{1};

%% Forward Transform
[valueC,valueS] = wavedec2(fwdtrx,x,nLevels); 

%% Shrinkage
if isbayes
    [valueC,valueT] = fcn_bayesshrink(valueC,valueS);
else
    [valueC,valueT] = fcn_softshrink(valueC,lambda,valueS);
end
     

%% Inverse Transform
y = waverec2(invtrx,valueC,valueS);