function [y,valueT] = fcn_sowvshrink(x,ord)
%
% Requirements: Image Processing Tbx
%

nLevels = 4;
if nargin < 2 || ord < 2
    isMinOrd = true;
else
    isMinOrd = false;
end

%% Wavelet setting
if isMinOrd
    lppufb = fcn_eznsgenlotcvm2();
else
    fname = sprintf('./filters/data128x128i0.25/ga/lppufb2dDec22Ord%d%dAlp0.0Dir1Vm2h.mat',ord,ord);
    load(fname)
end
fwdtrx = ForwardDirLot(lppufb,'circular');
invtrx = InverseDirLot(lppufb,'circular');

%% Forward Transform
[valueC,valueS] = wavedec2(fwdtrx,x,nLevels); 

%% Shrinkage
[valueC,valueT] = fcn_bayesshrink(valueC,valueS);

%% Inverse Transform
y = waverec2(invtrx,valueC,valueS);