% MAIN_ICIP2010BASIS
%
% SVN identifier:
% $Id: main_icip2010basis.m 91 2011-03-02 04:06:12Z sho $
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

%% Load a design Example
% Variable lppufb is an instance of Class LpPuFb2d
% close all
load lppufb_icip2010_dec22_ord44_alp-2.0_hor_tvm_phi153.43.mat

%% Magnitude response of the lowpass filter
figure(1)
freqz2(lppufb(1)) % lppufb(k) returns impluse response of the k-th filter
view(-40,70)

zlabel('Magnitude','FontSize',12,'FontName','AvantGarde')
xlabel('\omega_x/\pi','FontSize',12,'FontName','AvantGarde')
ylabel('\omega_y/\pi','FontSize',12,'FontName','AvantGarde')

set(gca,'FontSize',12)
set(gca,'FontName','AvantGarde')

%% Basis images
figure(2)
dispBasisImages(lppufb) % shows all basis images in array
set(gca,'FontName','AvantGarde')
