function [y,valueT] = fcn_wvshrink(x,wtype)
%
% Requirements: Image Processing Tbx, Wavelet Tbx
%

%% Wavelet setting
if nargin<2
    wtype = 'db5';
end
nLevels = 4;

%% Forward Transform
[valueC,valueS] = wavedec2(x,nLevels,wtype); 

%% Shrinkage
[valueC,valueT] = fcn_bayesshrink(valueC,valueS);

%% Inverse Transform
y = waverec2(valueC,valueS,wtype);
%figure(3), imshow(y)

