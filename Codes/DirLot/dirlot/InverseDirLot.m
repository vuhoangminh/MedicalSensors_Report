classdef InverseDirLot < handle
    %INVERSEDIRLOT Inverse directional lapped orthogoal transform
    %
    % NOTE:
    % The number of decomposition in each direction should be even.
    % The orders in both directions should be even and identical to each
    % other.
    %
    % SVN identifier:
    % $Id: InverseDirLot.m 316 2012-04-24 07:07:44Z harashin $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2008-2011, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    %
    properties (GetAccess = private, SetAccess = private)
        decX;
        decY;
        ordX;
        ordY;
        nRows;
        nCols;
        arrayCoefs;
        paramMtx;
        isPeriodicExt;
        isWavelet;
        modeTerminationCheck;
        trmCkOffsetX;
        trmCkOffsetY;
        hLen;
    end
    
    methods
        
        % constractor
        function this = InverseDirLot(varargin)
            
            %iptchecknargin(0,3,nargin,mfilename);
            narginchk(0,3);
            
            this.isWavelet = false;
            if nargin == 0 || (~isa(varargin{1},'LpPuFb2d') && ...
                    ~isa(varargin{1},'AbstLpPuFb2d'))
                if nargin < 1
                    this.decY = 2;
                    this.decX = 2;
                else
                    dec = varargin{1};
                    this.decX = dec(Direction.HORIZONTAL);
                    this.decY = dec(Direction.VERTICAL);
                end
                if nargin < 2
                    this.paramMtx = [];
                else
                    this.paramMtx = varargin{2};
                    this.ordX = int32(floor(length(this.paramMtx)/4));
                    this.ordY = int32(floor(length(this.paramMtx)/4));
                end
                if nargin < 3
                    this.isPeriodicExt = false; % Termination mode
                else
                    validStrings = { 'termination' 'circular' };
%                     string = iptcheckstrs(varargin{3},validStrings,...
%                         mfilename,'EXTENSION SCHEME',3);
                    string = validatestring(varargin{3},validStrings,...
                        mfilename,'EXTENSION SCHEME',3);
                    switch string
                        case 'termination'
                            this.isPeriodicExt = false; % Termination mode
                        case 'circular'
                            this.isPeriodicExt = true; % Periodic mode
                        otherwise
                            error('DirLot:InverseDirLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
            else
                dec = getDec(varargin{1});
                this.decX = dec(Direction.HORIZONTAL);
                this.decY = dec(Direction.VERTICAL);
                this.paramMtx = getParameterMatrices(varargin{1});
                ord = int32(getOrd(varargin{1}));
                this.ordX = ord(Direction.HORIZONTAL);
                this.ordY = ord(Direction.VERTICAL);
                
                if nargin < 2
                    this.isPeriodicExt = false; % Termination mode
                else
                    validStrings = { 'termination' 'circular' };
%                     string = iptcheckstrs(varargin{2},validStrings,...
%                         mfilename,'EXTENSION SCHEME',3);
                    string = validatestring(varargin{2},validStrings,...
                        mfilename,'EXTENSION SCHEME',3);
                    switch string
                        case 'termination'
                            this.isPeriodicExt = false; % Termination mode
                        case 'circular'
                            this.isPeriodicExt = true; % Periodic mode
                        otherwise
                            error('DirLot:InverseDirLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
                
            end
            this.modeTerminationCheck = int32(0);
            this.trmCkOffsetX = int32(0);
            this.trmCkOffsetY = int32(0);
        end
        
        function this = inverseTransform(this,subCoefs)
            
            blockSize(Direction.VERTICAL) = this.decY;
            blockSize(Direction.HORIZONTAL) = this.decX;
            
            if iscell(subCoefs)     % When input cell matrix
                subCoefs = InverseDirLot.getMatrix_(subCoefs,blockSize);
            end
            if isinteger(this.arrayCoefs)
                % subCoefs = im2double(subCoefs);
                subCoefs = double(subCoefs);
            end
            
            height  = size(subCoefs,1);
            width = size(subCoefs,2);
            this.nRows = int32(height/this.decY);
            this.nCols = int32(width/this.decX);
            
            this.arrayCoefs = im2col(subCoefs,...
                [this.decY this.decX],'distinct');
            this.hLen = size(this.arrayCoefs,1)/2;
            
            % Bases combination
            this = insertParameterMatrices_(this);
            ftype = exist('basesCombinationVertical_mex','file');
            for iOrd = 1:floor(length(this.paramMtx)/4)  % Vertical process
                paramMtx1 = this.paramMtx{end-2*iOrd+2};
                paramMtx2 = this.paramMtx{end-2*iOrd+1};
                if ftype == 3 && this.hLen == 2
                    this.arrayCoefs = ...
                        basesCombinationVertical_mex(...
                        this.arrayCoefs,this.nRows,this.nCols,this.ordY,...
                        this.isPeriodicExt,this.modeTerminationCheck,...
                        this.trmCkOffsetY,paramMtx1,paramMtx2);
                else
                    this = basesCombinationVertical_(this,paramMtx1,paramMtx2);
                end
            end
            ftype = exist('basesCombinationHorizontal_mex','file');
            for iOrd = 1:floor(length(this.paramMtx)/4)  % Horizontal process
                paramMtx1 = ...
                    this.paramMtx{end-2*iOrd-length(this.paramMtx)/2+3};
                paramMtx2 = ...
                    this.paramMtx{end-2*iOrd-length(this.paramMtx)/2+2};
                if ftype == 3 && this.hLen == 2
                    this.arrayCoefs = ...
                        basesCombinationHorizontal_mex(...
                        this.arrayCoefs,this.nRows,this.nCols,this.ordX,...
                        this.isPeriodicExt,this.modeTerminationCheck,...
                        this.trmCkOffsetX,paramMtx1,paramMtx2);
                else
                    this = ...
                        basesCombinationHorizontal_(this,paramMtx1,paramMtx2);
                end
            end
            
            if ~isempty(this.paramMtx)
                W0 = this.paramMtx{1}.';
                U0 = this.paramMtx{2}.';
                upperData = W0*this.arrayCoefs(1:this.hLen,:);
                lowerData = U0*this.arrayCoefs(this.hLen+1:end,:);
                this.arrayCoefs = [ upperData ; lowerData ];
                %for iCol = 1:this.nCols
                %    for iRow = 1:this.nRows
                %        this = blockRot_(this,iRow,iCol,W0,U0);
                %    end
                %end
            end
            
            this.arrayCoefs = col2im(this.arrayCoefs,...
                [this.decY this.decX],[height width],'distinct');
            if this.decY == 2 && this.decX == 2
                subCoef1 = this.arrayCoefs(1:2:end,1:2:end);
                subCoef2 = this.arrayCoefs(2:2:end,1:2:end);
                subCoef3 = this.arrayCoefs(1:2:end,2:2:end);
                subCoef4 = this.arrayCoefs(2:2:end,2:2:end);
                this.arrayCoefs(1:2:end,1:2:end) = ...
                    (subCoef1+subCoef2+subCoef3+subCoef4)/2;
                this.arrayCoefs(2:2:end,1:2:end)  = ...
                    (subCoef1-subCoef2-subCoef3+subCoef4)/2;
                this.arrayCoefs(1:2:end,2:2:end)  = ...
                    (subCoef1-subCoef2+subCoef3-subCoef4)/2;
                this.arrayCoefs(2:2:end,2:2:end)  = ...
                    (subCoef1+subCoef2-subCoef3-subCoef4)/2;
            else
                if exist('blockproc','file') == 2
                    fun = ...
                        @(x) InverseDirLot.permuteIdctCoefs_(x.data,...
                        this.decY,this.decX);
                    this.arrayCoefs = blockproc(this.arrayCoefs,blockSize,fun);
                    fun = @(x) idct2(x.data);
                    this.arrayCoefs = blockproc(this.arrayCoefs,blockSize,fun);
                else
                    % For release before R2009a
                    fun = @(x) InverseDirLot.permuteIdctCoefs_(x,...
                        this.decY,this.decX);
                    this.arrayCoefs = blkproc(this.arrayCoefs,blockSize,fun); %#ok
                    fun = @(x) idct2(x);
                    this.arrayCoefs = blkproc(this.arrayCoefs,blockSize,fun); %#ok
                end
            end
        end
        
        function value = getImage(this)
            value = this.arrayCoefs;
        end
        
        function value = waverec2(this,C,S,varargin)
            nDecs = this.decY*this.decX;
            nLevels = size(S,1)-2;
            for iLevel = 1:nLevels
                subCoefs = cell(nDecs,1);
                coefRow = S(iLevel+1,1);
                coefCol = S(iLevel+1,2);
                subCoefs{1} = reshape(...
                    C(1,1:coefRow*coefCol),...
                    [coefRow coefCol]);
                subCoefs{2} = reshape(...
                    C(1,coefRow*coefCol*3+1:coefRow*coefCol*4),...
                    [coefRow coefCol]);
                subCoefs{3} = reshape(...
                    C(1,coefRow*coefCol+1:coefRow*coefCol*2),...
                    [coefRow coefCol]);
                subCoefs{4} = reshape(...
                    C(1,coefRow*coefCol*2+1:coefRow*coefCol*3),...
                    [coefRow coefCol]);
                this = inverseTransform(this,subCoefs);
                value = getImage(this);
                C = [value(:).' C(1,coefRow*coefCol*nDecs+1:end)];
            end
        end
        
        function value = iwaveletDirLot(this,subCoefs,nLevels)
            nDecs = this.decY*this.decX;
            coefs = cell(nDecs,1);
            coefs{1} = subCoefs{1};
            for iLevel = 1:nLevels
                for iSubband = 2:nDecs
                    coefs{iSubband} = subCoefs{...
                        iSubband+(iLevel-1)*(nDecs-1)};
                end
                this = inverseTransform(this,coefs);
                value = getImage(this);
                coefs{1} = value;
            end
        end
        
        function this = setTerminationCheckMode(this,mode)
            this.modeTerminationCheck = int32(0);
            this.trmCkOffsetX = int32(0);
            this.trmCkOffsetY = int32(0);
            if (~isempty(strfind(mode,'N')) || ~isempty(strfind(mode,'n'))) && ...
                    (~isempty(strfind(mode,'S')) || ~isempty(strfind(mode,'s')))
                error('DirLot:InverseDirLot:unexpectedError', ...
                    '%s', 'Unexpected logic error.')
            end
            if (~isempty(strfind(mode,'W')) || ~isempty(strfind(mode,'w'))) && ...
                    (~isempty(strfind(mode,'E')) || ~isempty(strfind(mode,'e')))
                error('DirLot:InverseDirLot:unexpectedError', ...
                    '%s', 'Unexpected logic error.')
            end
            if ~isempty(strfind(mode, 'N')) || ~isempty(strfind(mode,'n'))
                this.modeTerminationCheck = int32(1);
                this.trmCkOffsetY = int32(0);
            elseif ~isempty(strfind(mode,'S')) || ~isempty(strfind(mode,'s'))
                this.modeTerminationCheck = int32(1);
                this.trmCkOffsetY = int32(1);
            end
            if ~isempty(strfind(mode, 'W')) || ~isempty(strfind(mode,'w'))
                this.modeTerminationCheck = ...
                    int32(this.modeTerminationCheck + 2);
                this.trmCkOffsetX = int32(0);
            elseif ~isempty(strfind(mode,'E')) || ~isempty(strfind(mode,'e'))
                this.modeTerminationCheck = ...
                    int32(this.modeTerminationCheck + 2);
                this.trmCkOffsetX = int32(1);
            end
        end
        
    end
    
    methods ( Access = private )
        
        function this = downShiftUpperCoefs_(this)
            for iCol = 1:this.nCols
                indexCol1 = (iCol-1)*this.nRows+1;
                colData0 = this.arrayCoefs(:,indexCol1);
                upperCoefsPre = colData0(1:this.hLen);
                for iRow = 2:this.nRows
                    indexCol = (iCol-1)*this.nRows+iRow;
                    colData = this.arrayCoefs(:,indexCol);
                    upperCoefsCur = colData(1:this.hLen);
                    colData(1:this.hLen) = upperCoefsPre;
                    this.arrayCoefs(:,indexCol) = colData;
                    upperCoefsPre = upperCoefsCur;
                end
                colData0(1:this.hLen) = upperCoefsPre;
                this.arrayCoefs(:,indexCol1) = colData0;
            end
        end
        
        function this = upShiftLowerCoefs_(this)
            for iCol = 1:this.nCols
                indexCol1 = (iCol-1)*this.nRows+1;
                colData0 = this.arrayCoefs(:,indexCol1);
                lowerCoefsPost = colData0(this.hLen+1:end);
                for iRow = this.nRows:-1:2
                    indexCol = (iCol-1)*this.nRows+iRow;
                    colData = this.arrayCoefs(:,indexCol);
                    lowerCoefsCur = colData(this.hLen+1:end);
                    colData(this.hLen+1:end) = lowerCoefsPost;
                    this.arrayCoefs(:,indexCol) = colData;
                    lowerCoefsPost = lowerCoefsCur;
                end
                colData0(this.hLen+1:end) = lowerCoefsPost;
                this.arrayCoefs(:,indexCol1) = colData0;
            end
        end
        
        function this = rightShiftUpperCoefs_(this)
            for iRow = 1:this.nRows
                indexCol1 = iRow;
                colData0 = this.arrayCoefs(:,iRow);
                upperCoefsPre = colData0(1:this.hLen);
                for iCol = 2:this.nCols
                    indexCol = (iCol-1)*this.nRows+iRow;
                    colData = this.arrayCoefs(:,indexCol);
                    upperCoefsCur = colData(1:this.hLen);
                    colData(1:this.hLen) = upperCoefsPre;
                    this.arrayCoefs(:,indexCol) = colData;
                    upperCoefsPre = upperCoefsCur;
                end
                colData0(1:this.hLen) = upperCoefsPre;
                this.arrayCoefs(:,indexCol1) = colData0;
            end
        end
        
        function this = leftShiftLowerCoefs_(this)
            for iRow = 1:this.nRows
                indexCol1 = iRow;
                colData0 = this.arrayCoefs(:,indexCol1);
                lowerCoefsPost = colData0(this.hLen+1:end);
                for iCol = this.nCols:-1:2
                    indexCol = (iCol-1)*this.nRows+iRow;
                    colData = this.arrayCoefs(:,indexCol);
                    lowerCoefsCur = colData(this.hLen+1:end);
                    colData(this.hLen+1:end) = lowerCoefsPost;
                    this.arrayCoefs(:,indexCol) = colData;
                    lowerCoefsPost = lowerCoefsCur;
                end
                colData0(this.hLen+1:end) = lowerCoefsPost;
                this.arrayCoefs(:,indexCol1) = colData0;
            end
        end
        
        function this = blockButterfly_(this)
            upper = this.arrayCoefs(1:this.hLen,:);
            lower = this.arrayCoefs(this.hLen+1:end,:);
            this.arrayCoefs = [
                upper + lower;
                upper - lower ];
        end
        
        function this = blockRot_(this,iRow,iCol,W,U)
            indexCol = (iCol-1)*this.nRows+iRow;
            colData = this.arrayCoefs(:,indexCol);
            colData(1:this.hLen) = W*colData(1:this.hLen);
            colData(this.hLen+1:end) = U*colData(this.hLen+1:end);
            this.arrayCoefs(:,indexCol) = colData;
        end
        
        function this = lowerBlockRot_(this,iRow,iCol,U)
            indexCol = (iCol-1)*this.nRows+iRow;
            colData = this.arrayCoefs(:,indexCol);
            colData(this.hLen+1:end) = U*colData(this.hLen+1:end);
            this.arrayCoefs(:,indexCol) = colData;
        end
        
        function this = ...
                basesCombinationVertical_(this,paramMtx1,paramMtx2)
            
            % Phase 1 for vertical direction
            Uy2 = paramMtx1.';
            I = eye(size(Uy2));
            for iCol = 1:this.nCols
                for iRow = 1:this.nRows
                    U = Uy2;
                    this = lowerBlockRot_(this,iRow,iCol,U);
                end
            end
            this = blockButterfly_(this);
            this = downShiftUpperCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            
            % Phase 2 for vertical direction
            Uy1 = paramMtx2.';
            for iCol = 1:this.nCols
                for iRow = 1:this.nRows
                    if (iRow == 1 && ~this.isPeriodicExt) || ...
                            (iRow == this.ordY+1+this.trmCkOffsetY && ...
                            mod(this.modeTerminationCheck,2) == 1)
                        U = -I;
                    else
                        U = Uy1;
                    end
                    this = lowerBlockRot_(this,iRow,iCol,U);
                end
            end
            this = blockButterfly_(this);
            this = upShiftLowerCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
        end
        
        function this = ...
                basesCombinationHorizontal_(this,paramMtx1,paramMtx2)
            
            % Phase 1 for horizontal direction
            Ux2 = paramMtx1.';
            I = eye(size(Ux2));
            for iRow = 1:this.nRows
                for iCol = 1:this.nCols
                    U = Ux2;
                    this = lowerBlockRot_(this,iRow,iCol,U);
                end
            end
            this = blockButterfly_(this);
            this = rightShiftUpperCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            
            % Phase 2 for horizonal direction
            Ux1 = paramMtx2.';
            for iRow = 1:this.nRows
                for iCol = 1:this.nCols
                    if (iCol == 1 && ~this.isPeriodicExt) || ...
                            (floor(this.modeTerminationCheck/2)>=1 && ...
                            iCol == this.ordX+1+this.trmCkOffsetX)
                        U = -I;
                    else
                        U = Ux1;
                    end
                    this = lowerBlockRot_(this,iRow,iCol,U);
                end
            end
            this = blockButterfly_(this);
            this = leftShiftLowerCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
        end
        
        function value = getMatrixI_(this)
            value = eye(this.decX*this.decY/2);
        end
        
        function this = insertParameterMatrices_(this)
            if this.ordY < this.ordX
                if this.isWavelet == false
                    I = getMatrixI_(this);
                    for iParam = this.ordX+this.ordY+3:2*this.ordX+2
                        this.paramMtx{iParam} = -I;
                    end
                    this.isWavelet = true;
                end
            elseif this.ordY > this.ordX
                if this.isWavelet == false
                    I = getMatrixI_(this);
                    diffOrd = this.ordY-this.ordX;
                    for iParam = this.ordX+this.ordY+2:-1:this.ordX+3
                        this.paramMtx{iParam+diffOrd} = ...
                            this.paramMtx{iParam};
                        if iParam <= this.ordY+2
                            this.paramMtx{iParam} = -I;
                        end
                    end
                    this.isWavelet = true;
                end
            end
        end
        
    end
    
    methods (Access = private, Static = true )
        
        function value = permuteIdctCoefs_(coefs,decY_,decX_)
            nQDecs = decY_*decX_/4;
            cee = coefs(         1:  nQDecs);
            coo = coefs(  nQDecs+1:2*nQDecs);
            coe = coefs(2*nQDecs+1:3*nQDecs);
            ceo = coefs(3*nQDecs+1:end);
            value(1:2:decY_,1:2:decX_) = reshape(cee,decY_/2,decX_/2);
            value(2:2:decY_,2:2:decX_) = reshape(coo,decY_/2,decX_/2);
            value(2:2:decY_,1:2:decX_) = reshape(coe,decY_/2,decX_/2);
            value(1:2:decY_,2:2:decX_) = reshape(ceo,decY_/2,decX_/2);
        end
        
        %
        function value = getMatrix_(subCoefs,blockSize)
            decY_ = blockSize(Direction.VERTICAL);
            decX_ = blockSize(Direction.HORIZONTAL);
            height = size(subCoefs{1},1)*decY_;
            width  = size(subCoefs{1},2)*decX_;
            value  = zeros(height,width);
            for iCol = 1:decX_
                for iRow = 1:decY_
                    iSubband = (iCol-1)*decX_ + iRow;
                    value(iRow:decY_:end,iCol:decX_:end) = ...
                        subCoefs{iSubband};
                end
            end
        end
        
    end
    
end

