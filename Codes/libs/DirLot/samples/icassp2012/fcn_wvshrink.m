function [y,valueT] = fcn_wvshrink(x,lambda,wtype,nLevels)
%
% Requirements: Image Processing Tbx, Wavelet Tbx
%

if lambda < 0 
    disp('BayesShrink')    
    isbayes = true;
else
    fprintf('lambda = %6.3f\n',lambda)    
    isbayes = false;
end

%% Wavelet setting
if nargin<3
    wtype = 'db3';
end

%% Forward Transform
[valueC,valueS] = wavedec2(x,nLevels,wtype); 

%% Shrinkage
if isbayes
    [valueC,valueT] = fcn_bayesshrink(valueC,valueS);
else
    [valueC,valueT] = fcn_softshrink(valueC,lambda,valueS);
end
        
%% Inverse Transform
y = waverec2(valueC,valueS,wtype);
%figure(3), imshow(y)

