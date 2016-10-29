function arrayCoefs = ...
    supportExtensionHorizontal(arrayCoefs,nRows,nCols,isPeriodicExt,...
    Ux1,Ux2) %#codegen
%SUPPORTEXTENSIONHORIZONTAL Function for horizontal support extension
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

% Phase 1 for horizontal direction
I = eye(size(Ux1));
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = rightShiftLowerCoefs(arrayCoefs,nRows,nCols);
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = arrayCoefs/2.0;
for iRow = 1:nRows
    for iCol = 1:nCols
        if iCol == 1 && ~isPeriodicExt
            U = -I;
        else
            U = Ux1;
        end
        arrayCoefs = blockRot(arrayCoefs,nRows,...
            iRow,iCol,I,U);
    end
end

% Phase 2 for horizontal direction
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = leftShiftUpperCoefs(arrayCoefs,nRows,nCols);
% Butterfly
upper = arrayCoefs(1:2,:);
lower = arrayCoefs(3:4,:);
arrayCoefs = [ upper + lower; upper - lower ];
%
arrayCoefs = arrayCoefs/2.0;
for iRow = 1:nRows
    for iCol = 1:nCols
        U = Ux2;
        arrayCoefs =  blockRot(arrayCoefs,nRows,iRow,iCol,I,U);
    end
end

function arrayCoefs = leftShiftUpperCoefs(arrayCoefs,nRows,nCols)
for iRow = 1:nRows
    indexCol1 = iRow;
    colData0 = arrayCoefs(:,indexCol1);
    upperCoefsPost = colData0(1:2);
    for iCol = nCols:-1:2
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

function arrayCoefs = rightShiftLowerCoefs(arrayCoefs,nRows,nCols)
for iRow = 1:nRows
    indexCol1 = iRow;
    colData0 = arrayCoefs(:,indexCol1);
    lowerCoefsPre = colData0(3:4);
    for iCol = 2:nCols
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
