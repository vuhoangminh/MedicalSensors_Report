function [subLL,subHL,subLH,subHH] = im97trnscq_ip(fullPicture)
%IM97TRNSCQ_IP 9/7 forward lifting step
%
% SVN identifier:
% $Id: im97trnscq_ip.m 184 2011-08-17 14:13:14Z sho $
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

fullPicture = double(fullPicture);

% Vertical transform (inplace computation)
fullPicture = predictionStep_ip(fullPicture,a);
fullPicture = updateStep_ip(fullPicture,b);
fullPicture = predictionStep_ip(fullPicture,g);
fullPicture = updateStep_ip(fullPicture,d);
fullPicture(1:2:end,:,:) = fullPicture(1:2:end,:,:)/K;
fullPicture(2:2:end,:,:) = fullPicture(2:2:end,:,:)*K;

% Horizontal transform (inplace computation)
fullPicture = predictionStep_ip(fullPicture.',a);
fullPicture = updateStep_ip(fullPicture,b);
fullPicture = predictionStep_ip(fullPicture,g);
fullPicture = updateStep_ip(fullPicture,d).';
fullPicture(:,1:2:end,:) = fullPicture(:,1:2:end,:)/K;
fullPicture(:,2:2:end,:) = fullPicture(:,2:2:end,:)*K;

% Permutation of Coefs.
subLL = fullPicture(1:2:end,1:2:end,:);
subHL = fullPicture(1:2:end,2:2:end,:);
subLH = fullPicture(2:2:end,1:2:end,:);
subHH = fullPicture(2:2:end,2:2:end,:);

% end of im97trnscq_ip
