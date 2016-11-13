function picture = updateStep_ip(picture,u)
%UPDATESTEP_IP Update lifting step
%
% SVN identifier:
% $Id: updateStep_ip.m 184 2011-08-17 14:13:14Z sho $
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
if (mod(size(picture,1),2)==0)
    picture(1:2:end,:,:) = imlincomb(...
        u, [picture(2,:,:); picture(2:2:end-1,:,:)], ...
        1, picture(1:2:end,:,:), ...
        u, picture(2:2:end,:,:) ...
        );
else
    picture(1:2:end,:,:) = imlincomb(...
        u, [picture(2,:,:); picture(2:2:end-1,:,:)], ...
        1, picture(1:2:end,:,:), ...
        u, [picture(2:2:end,:,:); picture(end-1,:,:)] ...
        );
end
