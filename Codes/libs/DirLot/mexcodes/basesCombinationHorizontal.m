function arrayCoefs = basesCombinationHorizontal(arrayCoefs,...
    nRows,nCols,ordX,isPeriodicExt,modeTerminationCheck,trmCkOffsetX,...
    paramMtx1,paramMtx2) %#codegen 
%BASESCOMBINATIONHORIZONTAL Function for horizontal basis combination 
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
%

% Phase 1 for horizontal direction
Ux2 = paramMtx1.';
I = eye(size(Ux2));
for iRow = 1:nRows
    for iCol = 1:nCols
        U = Ux2;
        arrayCoefs = lowerBlockRot(arrayCoefs,nRows,iRow,iCol,U);
    end
end

% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = rightShiftUpperCoefs(arrayCoefs,nRows,nCols);
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = arrayCoefs/2.0;

% Phase 2 for horizonal direction
Ux1 = paramMtx2.';
for iRow = 1:nRows
    for iCol = 1:nCols
        if (iCol == 1 && ~isPeriodicExt) || ...
                (floor(modeTerminationCheck/2)>=1 && ...
                iCol == ordX+1+trmCkOffsetX)
            U = -I;
        else
            U = Ux1;
        end
        arrayCoefs = lowerBlockRot(arrayCoefs,nRows,iRow,iCol,U);
    end
end
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = leftShiftLowerCoefs(arrayCoefs,nRows,nCols);
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = arrayCoefs/2.0;

function arrayCoefs = leftShiftLowerCoefs(arrayCoefs,nRows,nCols)
for iRow = 1:nRows
    indexCol1 = iRow;
    colData0 = arrayCoefs(:,indexCol1);
    lowerCoefsPost = colData0(3:4);
    for iCol = nCols:-1:2
        indexCol = (iCol-1)*nRows+iRow;
        colData = arrayCoefs(:,indexCol);
        lowerCoefsCur = colData(3:4);
        colData(3:4) = lowerCoefsPost;
        arrayCoefs(:,indexCol) = colData;
        lowerCoefsPost = lowerCoefsCur;
    end
    colData0(3:4) = lowerCoefsPost;
    arrayCoefs(:,indexCol1) = colData0;
end

function arrayCoefs = rightShiftUpperCoefs(arrayCoefs,nRows,nCols)
for iRow = 1:nRows
    indexCol1 = iRow;
    colData0 = arrayCoefs(:,iRow);
    upperCoefsPre = colData0(1:2);
    for iCol = 2:nCols
        indexCol = (iCol-1)*nRows+iRow;
        colData = arrayCoefs(:,indexCol);
        upperCoefsCur = colData(1:2);
        colData(1:2) = upperCoefsPre;
        arrayCoefs(:,indexCol) = colData;
        upperCoefsPre = upperCoefsCur;
    end
    colData0(1:2) = upperCoefsPre;
    arrayCoefs(:,indexCol1) = colData0;
end
