function output = HSDirLOT_SURELET_denoise(input)
% HSDIRLOT_SURELET_DENOISE Removes additive Gaussian white noise 
% using the SURE-LET
%
% SVN identifier:
% $Id: HSDirLOT_SURELET_denoise.m 377 2013-02-01 07:39:58Z sho $
%
% Requirements: MATLAB R2008a
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

sdir = '../icassp2012/filters/data128x128ampk3l3/ga/';
idx = 1;
%
fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vm2.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir2Vmd000.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir2Vmd030.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir1Vmd060.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vmd090.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir1Vmd120.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir2Vmd150.00.mat';
%
nTrx = length(fname);
u = cell(nTrx,1);
%
parfor idx = 1:nTrx
    S = load([sdir fname{idx}],'lppufb');
    u{idx} = NSGenLOT_SURELET_denoise(input,S.lppufb);
end
output = 0;
for idx = 1:nTrx
    output = output + u{idx};
end
output = output/nTrx;
