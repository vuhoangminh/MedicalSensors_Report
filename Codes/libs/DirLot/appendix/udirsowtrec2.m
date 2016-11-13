function X = udirsowtrec2( C, S, invtrx )
%UDIRSOWTREC2 Reconstruction by a union of directional symmetric 
%
% SVN identifier:
% $Id: udirsowtrec2.m 379 2013-02-01 08:43:41Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2013, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
nTrx = length(invtrx); % Number of bases

% Inverset transform
subimg = cell(1,nTrx);
nCoefs = length(C)/nTrx;
parfor idx = 1:nTrx
    coefs = C(nCoefs*(idx-1)+1:nCoefs*idx);
    subimg{idx} = waverec2(invtrx{idx},coefs,S);
end
X = 0;
for idx = 1:nTrx
    X = X + subimg{idx}/nTrx;
end

end
