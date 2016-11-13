function arrayCoefs = basesCombinationVertical(arrayCoefs,nRows,nCols,...
    ordY,isPeriodicExt,modeTerminationCheck,trmCkOffsetY,...
    paramMtx1,paramMtx2) %#codegen 
%BASESCOMBINATIONVERTICAL Function for vertical basis combination 
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

% Phase 1 for vertical direction
Uy2 = paramMtx1.';
I = eye(size(Uy2));
for iCol = 1:nCols
    for iRow = 1:nRows
        U = Uy2;
        arrayCoefs = lowerBlockRot(arrayCoefs,nRows,iRow,iCol,U);
    end
end
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = downShiftUpperCoefs(arrayCoefs,nRows,nCols);
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = arrayCoefs/2.0;

% Phase 2 for vertical direction
Uy1 = paramMtx2.';
for iCol = 1:nCols
    for iRow = 1:nRows
        if (iRow == 1 && ~isPeriodicExt) || ...
                (iRow == ordY+1+trmCkOffsetY && ...
                mod(modeTerminationCheck,2) == 1)
            U = -I;
        else
            U = Uy1;
        end
        arrayCoefs = lowerBlockRot(arrayCoefs,nRows,iRow,iCol,U);
    end
end
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = upShiftLowerCoefs(arrayCoefs,nRows,nCols);
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = arrayCoefs/2.0;

function arrayCoefs = downShiftUpperCoefs(arrayCoefs,nRows,nCols)
for iCol = 1:nCols
    indexCol1 = (iCol-1)*nRows+1;
    colData0 = arrayCoefs(:,indexCol1);
    upperCoefsPre = colData0(1:2);
    for iRow = 2:nRows
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

function arrayCoefs = upShiftLowerCoefs(arrayCoefs,nRows,nCols)
for iCol = 1:nCols
    indexCol1 = (iCol-1)*nRows+1;
    colData0 = arrayCoefs(:,indexCol1);
    lowerCoefsPost = colData0(3:4);
    for iRow = nRows:-1:2
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
