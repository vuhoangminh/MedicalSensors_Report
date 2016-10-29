function ckvm2 = verifyVm2(lppufb)
%VERIFYVM2 Verify classical 2-order vanishing moments of 2-D LPPUFBs
%
% SVN identifier:
% $Id: verifyVm2.m 184 2011-08-17 14:13:14Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2008-2009, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
persistent hy
persistent hx

dec = getDec(lppufb);
H = lppufb(1);
ckvm2 = checkVm2(lppufb);

if isempty(hy)
    hy = figure;
else
    figure(hy)
end
for y = 0:dec(1)-1
    subplot(1,dec(1),y+1)
    zplane(sum(diag((exp(-1i*2*pi/dec(1)*y)).^(0:(size(H,1)-1)))*H))
    axis([-1.5 1.5 -1.5 1.5])
    title(sprintf('H_0(z_y,z_x)|_{k_y=%d}',y))
    ylabel('Im')
    xlabel('Re')
end

if isempty(hx)
    hx = figure;
else
    figure(hx)
end
for x = 0:dec(2)-1    
    subplot(1,dec(2),x+1)
    zplane(sum(diag((exp(-1i*2*pi/dec(2)*x)).^(0:(size(H,2)-1)))*H.'))
    axis([-1.5 1.5 -1.5 1.5])
    title(sprintf('H_0(z_y,z_x)|_{k_x=%d}',x))
    ylabel('Im')
    xlabel('Re')
end
