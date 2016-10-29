function fullPicture = im97itrnscq_ip(subLL,subHL,subLH,subHH)
%IM97ITRNSCQ_IP 9/7 inverse lifting step
%
% SVN identifier:
% $Id: im97itrnscq_ip.m 184 2011-08-17 14:13:14Z sho $
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

a = -1.586134342059924;
b = -0.052980118572961;
g =  0.882911075530934;
d =  0.443506852043971;
K =  1.230174104914001;

% Preparation of arrays
fullSize = size(subLL) + size(subHH);
fullPicture = zeros(fullSize);

% Permutation of Coefs.
fullPicture(1:2:end,1:2:end,:) = subLL;
fullPicture(1:2:end,2:2:end,:) = subHL;
fullPicture(2:2:end,1:2:end,:) = subLH;
fullPicture(2:2:end,2:2:end,:) = subHH;

% Horizontal transform (inplace computation)
fullPicture(:,1:2:end,:) = fullPicture(:,1:2:end,:)*K;
fullPicture(:,2:2:end,:) = fullPicture(:,2:2:end,:)/K;
fullPicture = updateStep_ip(fullPicture.',-d);
fullPicture = predictionStep_ip(fullPicture,-g);
fullPicture = updateStep_ip(fullPicture,-b);
fullPicture = predictionStep_ip(fullPicture,-a).';

% Vertical transform (inplace computation)
fullPicture(1:2:end,:,:) = fullPicture(1:2:end,:,:)*K;
fullPicture(2:2:end,:,:) = fullPicture(2:2:end,:,:)/K;
fullPicture = updateStep_ip(fullPicture,-d);
fullPicture = predictionStep_ip(fullPicture,-g);
fullPicture = updateStep_ip(fullPicture,-b);
fullPicture = predictionStep_ip(fullPicture,-a);

% end of im97itrnscq_ip
