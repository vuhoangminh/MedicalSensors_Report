function arrayCoefs = ...
    supportExtensionVertical(arrayCoefs,nRows,nCols,isPeriodicExt,...
    Uy1,Uy2) %#codegen
%SUPPORTEXTENSIONVERTICAL Function for vertical support extension
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

% Phase 1 for vertical direction
I = eye(size(Uy1));
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = downShiftLowerCoefs(arrayCoefs,nRows,nCols);
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = arrayCoefs/2.0;
for iCol = 1:nCols
    for iRow = 1:nRows
        if iRow == 1 && ~isPeriodicExt
            U = -I;
        else
            U = Uy1;
        end
        arrayCoefs = lowerBlockRot(arrayCoefs,nRows,...
            iRow,iCol,U);
    end
end

% Phase 2 for vertical direction
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = upShiftUpperCoefs(arrayCoefs,nRows,nCols);
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = arrayCoefs/2.0;
for iCol = 1:nCols
    for iRow = 1:nRows
        U = Uy2;
        arrayCoefs = lowerBlockRot(arrayCoefs,nRows,iRow,iCol,U);
    end
end

function arrayCoefs = downShiftLowerCoefs(arrayCoefs,nRows,nCols)
for iCol = 1:nCols
    indexCol1 = (iCol-1)*nRows+1;
    colData0 = arrayCoefs(:,indexCol1);
    lowerCoefsPre = colData0(3:4);
    for iRow = 2:nRows
        indexCol = (iCol-1)*nRows+iRow;
        colData = arrayCoefs(:,indexCol);
        lowerCoefsCur = colData(3:4);
        colData(3:4) = lowerCoefsPre;
        arrayCoefs(:,indexCol) = colData;
        lowerCoefsPre = lowerCoefsCur;
    end
    colData0(3:4) = lowerCoefsPre;
    arrayCoefs(:,indexCol1) = colData0;
end

function arrayCoefs = upShiftUpperCoefs(arrayCoefs,nRows,nCols)
for iCol = 1:nCols
    indexCol1 = (iCol-1)*nRows+1;
    colData0 = arrayCoefs(:,indexCol1);
    upperCoefsPost = colData0(1:2);
    for iRow = nRows:-1:2
        indexCol = (iCol-1)*nRows+iRow;
        colData = arrayCoefs(:,indexCol);
        upperCoefsCur = colData(1:2);
        colData(1:2) = upperCoefsPost;
        arrayCoefs(:,indexCol) = colData;
        upperCoefsPost = upperCoefsCur;
    end
    colData0(1:2) = upperCoefsPost;
    arrayCoefs(:,indexCol1) = colData0;
end