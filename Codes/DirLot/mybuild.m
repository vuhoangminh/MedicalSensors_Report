% MYBUILD Scripts for MATLAB Coder
%
% SVN identifier:
% $Id: mybuild.m 347 2012-10-24 05:22:07Z sho $
%
% Requirements: MATLAB R2012a
%
% Copyright (c) 2012, Shogo MURAMATSU and Shintaro HARA
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
maxCols = 518400;
addpath('./mexcodes')

%% Definition of data types
arrayCoefs = coder.typeof(double(0),[4 maxCols],[0 1]);
nRows = coder.typeof(int32(0),[1 1],[0 0]);
nCols = coder.typeof(int32(0),[1 1],[0 0]);
ord = coder.typeof(int32(0),[1 1],[0 0]);
isPeriodicExt = coder.typeof(false,[1 1],[0 0]);
modeTerminationCheck = coder.typeof(int32(0),[1 1],[0 0]);
trmCkOffsetX = coder.typeof(int32(0),[1 1],[0 0]);
paramMtx = coder.typeof(double(0),[2 2],[0 0]);

%% Functions for mex codes
blist = [];
idx = 0;
%
idx = idx + 1;
blist{idx} = { ...
    'basesCombinationHorizontal'
    '{ arrayCoefs, nRows, nCols, ord, isPeriodicExt, modeTerminationCheck, trmCkOffsetX, paramMtx, paramMtx }' };
%
idx = idx + 1;
blist{idx} = { ...
    'basesCombinationVertical' 
    '{ arrayCoefs, nRows, nCols, ord, isPeriodicExt, modeTerminationCheck, trmCkOffsetX, paramMtx, paramMtx }' };
%
idx = idx + 1;
blist{idx} = { ...
    'supportExtensionHorizontal'
   '{ arrayCoefs, nRows, nCols, isPeriodicExt, paramMtx, paramMtx }' };    
%
idx = idx + 1;
blist{idx} = { ...
    'supportExtensionVertical'
   '{ arrayCoefs, nRows, nCols, isPeriodicExt, paramMtx, paramMtx }' };        

%% Generate MEX files
cfg = coder.config('mex');
cfg.DynamicMemoryAllocation = 'Off';
cfg.GenerateReport = true;
for idx = 1:length(blist)
    name = blist{idx}{1};
    args = blist{idx}{2};
    seval = ['codegen -config cfg -o mexcodes/' name '_mex' ...
        ' mexcodes/' name ' -args ' args];
    disp(seval)
    eval(seval)
end
