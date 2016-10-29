%
% SVN identifier:
% $Id: main_dirlot_ramprot.m 260 2011-11-29 08:10:55Z sho $
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

params.eps = 1e-15;
params.dim = [ 32 32 ];
transition = 0.25;   % Transition band width
params.location = sprintf('./filters/data128x128i%.2f/ga',transition);

%% First example
params.dec   = 2; % Decimation factor
params.ord   = 4;
params.alpha = -2.0; % Deformation parameter
params.dir   = Direction.HORIZONTAL; % Deforming direciton

[dirlotNorm0,dctNorm0,phixd,arrayCard] = fcn_dirlot_ramprot(params);

figure(1)
plot(phixd,dirlotNorm0/arrayCard,phixd,dctNorm0/arrayCard)

save results/dirlot_ramprot_results_1st phixd dirlotNorm0 dctNorm0 arrayCard

%% Second example
params.dec   = 4; % Decimation factor
params.ord   = 2;
params.alpha = -2.0; % Deformation parameter
params.dir   = Direction.HORIZONTAL; % Deforming direciton

[dirlotNorm0,dctNorm0,phixd,arrayCard] = fcn_dirlot_ramprot(params);

figure(2)
plot(phixd,dirlotNorm0/arrayCard,phixd,dctNorm0/arrayCard)

save results/dirlot_ramprot_results_2nd phixd dirlotNorm0 dctNorm0 arrayCard