function [ C, S ] = udirsowtdec2( X, N, fwdtrx )
%UDIRSOWTDEC2 Decomposition by a union of directional symmetric 
%
% SVN identifier:
% $Id: udirsowtdec2.m 379 2013-02-01 08:43:41Z sho $
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
nTrx = length(fwdtrx); % Number of bases

% Forward transform
coefs = cell(1,nTrx);
csize = cell(1,nTrx);
parfor idx = 1:nTrx
    if idx == 1
        [ coefs{idx}, csize{idx} ] = wavedec2(fwdtrx{idx},X,N);
    else
        coefs{idx}= wavedec2(fwdtrx{idx},X,N);
    end
end
C = cell2mat(coefs);
S = csize{1};
end
