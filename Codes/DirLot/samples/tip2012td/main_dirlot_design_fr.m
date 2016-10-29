function main_dirlot_design_fr
%MAIN_DIRLOT_DESIGN_FR Design of DirLOTs by subband frequency specification
%
% SVN identifier:
% $Id: main_dirlot_design_fr.m 271 2011-12-16 05:13:51Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009-2011, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
params.nPoints = [ 128 128 ]; % Frequency grid
params.ord = [ 4 4 ]; % Polyphase order
params.dec = [ 2 2 ]; % Number of decomposition
params.alpha = -2.0; % Specification parameter
params.dir = Direction.HORIZONTAL; % Slant direction
params.transition = 0.25; % Transition width
params.vm = 'd153.43'; % Order of vanishing moments {0,1,2, 'd###.#'}
params.sd = [1 1]; % Directions of two triangles
[cost, lppufb, sbsp] = fcn_dirlot_design_fr(params);

disp(spsbt)
disp(cost)
figure(1), dispBasisImages(lppufb)
figure(2)
subplot(2,2,1), freqz2(lppufb(1))
subplot(2,2,2), freqz2(lppufb(2))
subplot(2,2,3), freqz2(lppufb(3))
subplot(2,2,4), freqz2(lppufb(4))

%angles = getAngles(lppufb);
%mus = getMus(lppufb);
%paramMtx = getParameterMatrices(lppufb);