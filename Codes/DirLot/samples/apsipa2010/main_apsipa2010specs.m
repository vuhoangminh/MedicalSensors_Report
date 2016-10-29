% MAIN_APSIPA2010SPECS
%
% SVN identifier:
% $Id: main_apsipa2010specs.m 244 2011-11-22 14:18:13Z sho $
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
%
close all

params.dec = [4 4];
params.ord = [2 2];
params.alpha = -2.0;
params.dir = Direction.HORIZONTAL;
params.trans = 0.25;
params.nPoints = [128 128];

%% Subband Specification
sbsp = SubbandSpecification(params.alpha,params.dir,params.dec);
sbsp = setTransition(sbsp,params.trans);
ros = getSubbandLocation(sbsp,params.nPoints);
for idx=2:prod(params.dec)
    ros = ros + idx*getSubbandLocation(sbsp,params.nPoints,idx);
end

%% Whole subband assignment
figure(1)
imshow(flipud(ros))
colormap('default')
caxis('auto')

%% Individual subband assignment
figure(2)
for iSubband = 1:prod(params.dec)
    psa = flipud(...
        (getPassStopAssignment(sbsp,params.nPoints,iSubband)+1)/2);
    subplot(params.dec(1),params.dec(2),iSubband)
    imshow(psa)
end
