% MAIN_ICIP2010RDCURVE
%
% SVN identifier:
% $Id: main_icip2010rdcurve.m 91 2011-03-02 04:06:12Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009-2010, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

% close all

orgImg = im2double(...
    imread('./brodatz_d15_x60y115_80x64.tif'));

%% Coding experiment with TVM from 0.1[bpp] to 4[bpp]
h = waitbar(0,'TVM');
binTvm = zeros(1,length(.1:.2:4));
iExperiment = 1;
for aveRate = .1:.2:4
    binTvm(iExperiment) = tvm(orgImg,aveRate);
    waitbar(iExperiment/length(.1:.2:4),h)
    iExperiment = iExperiment + 1;
end
close(h)

%% Coding experiment with VM2 from 0.1[bpp] to 4[bpp]
h = waitbar(0,'VM2');
binVm2 = zeros(1,length(.1:.2:4));
iExperiment = 1;
for aveRate = .1:.2:4
    binVm2(iExperiment) = vm2(orgImg,aveRate);
    waitbar(iExperiment/length(.1:.2:4),h)
    iExperiment = iExperiment + 1;
end
close(h)

%% Coding experiment with 9/7-tap DWT from 0.1[bpp] to 4[bpp]
h = waitbar(0,'9/7-tap DWT');
binDWT = zeros(1,length(.1:.2:4));
iExperiment = 1;
for aveRate = .1:.2:4
    binDWT(iExperiment) = dwt97(orgImg,aveRate);
    waitbar(iExperiment/length(.1:.2:4),h)
    iExperiment = iExperiment + 1;
end
close(h)

%% Plot rate-distortion curve
mkGraph(binTvm,binVm2,binDWT)
