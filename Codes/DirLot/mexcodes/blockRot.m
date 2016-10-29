function arrayCoefs = blockRot(arrayCoefs,nRows,iRow,iCol,W,U) %#codegen
%BLOCKROT Function for block rotation
%
% SVN identifier:
% $Id: ButterFly.m 346 2012-10-24 05:19:46Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2012, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

indexCol = (iCol-1)*nRows+iRow;
colData = arrayCoefs(:,indexCol);
colData(1:2) = W*colData(1:2);
colData(3:4) = U*colData(3:4);
arrayCoefs(:,indexCol) = colData;
