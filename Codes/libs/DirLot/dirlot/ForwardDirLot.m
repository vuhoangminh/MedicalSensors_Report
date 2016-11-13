classdef ForwardDirLot < handle
    %FORWARDDIRLOT Forward directional lapped orthogoal transform
    %
    % NOTE:
    % The number of decomposition in each direction should be even.
    % The orders in both directions should be even and identical to each
    % other.
    %
    % SVN identifier:
    % $Id: ForwardDirLot.m 316 2012-04-24 07:07:44Z harashin $
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
        hLen;
    end
    
    methods
        
        % Constructor
        function this = ForwardDirLot(varargin)

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
                    this.ordY = 0;
                    this.ordX = 0;
                else
                    this.paramMtx = varargin{2};
                    ord = (length(this.paramMtx)-2)/2;  % Equivalent order
                    this.ordY = ord;
                    this.ordX = ord;
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
                            error('DirLot:ForwardDirLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
            else
                dec = getDec(varargin{1});
                this.decX = dec(Direction.HORIZONTAL);
                this.decY = dec(Direction.VERTICAL);
                this.paramMtx = getParameterMatrices(varargin{1});
                ord = getOrd(varargin{1});  % Not equivalent order
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
                            error('DirLot:ForwardDirLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
                
            end
        end
        
        function this = forwardTransform(this,srcImg)
            height = size(srcImg,1);
            width = size(srcImg,2);
            this.nRows = int32(height/this.decY);
            this.nCols = int32(width/this.decX);
            blockSize(Direction.VERTICAL) = this.decY;
            blockSize(Direction.HORIZONTAL) = this.decX;
            
            if isinteger(srcImg)
                srcImg = im2double(srcImg);
            end
            
            % Block DCT
            if this.decY == 2 && this.decX == 2
                this.arrayCoefs = zeros(size(srcImg));
                subImg1 = srcImg(1:2:end,1:2:end);
                subImg2 = srcImg(2:2:end,1:2:end);
                subImg3 = srcImg(1:2:end,2:2:end);
                subImg4 = srcImg(2:2:end,2:2:end);
                this.arrayCoefs(1:2:end,1:2:end) = ...
                    (subImg1+subImg2+subImg3+subImg4)/2;
                this.arrayCoefs(2:2:end,1:2:end)  = ...
                    (subImg1-subImg2-subImg3+subImg4)/2;
                this.arrayCoefs(1:2:end,2:2:end)  = ...
                    (subImg1-subImg2+subImg3-subImg4)/2;
                this.arrayCoefs(2:2:end,2:2:end)  = ...
                    (subImg1+subImg2-subImg3-subImg4)/2;
            else
                if exist('blockproc','file') == 2
                    fun = @(x) dct2(x.data);
                    this.arrayCoefs = blockproc(srcImg,blockSize,fun);
                    fun = @(x) ForwardDirLot.permuteDctCoefs_(x.data);
                    this.arrayCoefs = blockproc(this.arrayCoefs,blockSize,fun);
                else
                    % For release before R2009a
                    fun = @(x) dct2(x);
                    this.arrayCoefs = blkproc(srcImg,blockSize,fun); %#ok
                    fun = @(x) ForwardDirLot.permuteDctCoefs_(x);
                    this.arrayCoefs = blkproc(this.arrayCoefs,blockSize,fun); %#ok
                end
            end
            this.arrayCoefs = im2col(this.arrayCoefs,blockSize,'distinct');
            this.hLen = size(this.arrayCoefs,1)/2;
            
            if ~isempty(this.paramMtx)
                W0 = this.paramMtx{1};
                U0 = this.paramMtx{2};
                upperData = W0*this.arrayCoefs(1:this.hLen,:);
                lowerData = U0*this.arrayCoefs(this.hLen+1:end,:);
                this.arrayCoefs = [ upperData ; lowerData ];
                %for iCol = 1:this.nCols
                %    for iRow = 1:this.nRows
                %        this = blockRot_(this,iRow,iCol,W0,U0);
                %    end
                %end
            end
            
            % Support extension
            this = insertParameterMatrices_(this);
            ftype = exist('supportExtensionHorizontal_mex','file');
            for iOrd = 1:this.ordX/2  % Horizontal process
                paramMtx1 = this.paramMtx{2*iOrd+1};
                paramMtx2 = this.paramMtx{2*iOrd+2};
                if ftype == 3 && this.hLen == 2                
                    this.arrayCoefs = ...
                        supportExtensionHorizontal_mex(this.arrayCoefs,...
                        this.nRows,this.nCols,this.isPeriodicExt,...
                        paramMtx1,paramMtx2); 
                else
                this = ...
                    supportExtensionHorizontal_(this,paramMtx1,paramMtx2);
                end
            end
            ftype = exist('supportExtensionVertical_mex','file');
            for iOrd = 1:this.ordY/2  % Vertical process
                paramMtx1 = ...
                    this.paramMtx{2*iOrd+length(this.paramMtx)/2};
                paramMtx2 = ...
                    this.paramMtx{2*iOrd+length(this.paramMtx)/2+1};
                if ftype == 3 && this.hLen == 2
                    this.arrayCoefs = ...
                        supportExtensionVertical_mex(this.arrayCoefs,...
                        this.nRows,this.nCols,this.isPeriodicExt,...
                        paramMtx1,paramMtx2);
                else
                    this = supportExtensionVertical_(this,paramMtx1,paramMtx2);
                end
            end
        end
        
        function value = getCoefs(this)
            res = cell(this.nRows,this.nCols);
            for iCol = 1:this.nCols
                for iRow = 1:this.nRows
                    coefs = this.arrayCoefs(:,(iCol-1)*this.nRows+iRow);
                    res{iRow,iCol} = reshape(coefs,this.decY,this.decX);
                end
            end
            value = cell2mat(res);
        end
        
        function value = getSubbandCoefs(this)
            nDecs = size(this.arrayCoefs,1);
            res = zeros(this.nRows,this.nCols,nDecs);
            for iCol = 1:this.nCols
                for iRow = 1:this.nRows
                    coefs = this.arrayCoefs(:,(iCol-1)*this.nRows+iRow);
                    for iSubband = 1:nDecs
                        res(iRow,iCol,iSubband) = coefs(iSubband);
                    end
                end
            end
            value = cell(nDecs,1);
            for iSubband = 1:nDecs
                value{iSubband} = res(:,:,iSubband);
            end
        end
        
        function [valueC valueS] = wavedec2(this,srcImg,nLevels,varargin)
            subbandCoef1 = srcImg;
            valueS = zeros(nLevels+2,2);
            valueS(nLevels+2,:) = size(subbandCoef1);
            valueC = zeros(1,numel(subbandCoef1));
            for iLevel = 1:nLevels
                this = forwardTransform(this,subbandCoef1);
                subbandCoefs = getSubbandCoefs(this);
                subbandCoef1 = subbandCoefs{1};
                subbandCoef2 = subbandCoefs{3};
                subbandCoef3 = subbandCoefs{4};
                subbandCoef4 = subbandCoefs{2};
                ws = numel(subbandCoef1)+1;
                we = numel(subbandCoef1)+numel(subbandCoef2)+...
                    numel(subbandCoef3)+numel(subbandCoef4);
                valueC(1,ws:we) = [subbandCoef2(:).' subbandCoef3(:).' ...
                    subbandCoef4(:).'];
                valueS(nLevels+2-iLevel,:) = size(subbandCoef2);
            end
            valueS(1,:) = size(subbandCoef1);
            valueC(1,1:numel(subbandCoef1)) = subbandCoef1(:).';
        end
        
        function value = waveletDirLot(this,srcImg,nLevels)
            subbandCoef1 = srcImg;
            value = cell(3*nLevels+1,1);
            for iLevel = 1:nLevels
                this = forwardTransform(this,subbandCoef1);
                subbandCoefs = getSubbandCoefs(this);
                subbandCoef1 = subbandCoefs{1};
                subbandCoef2 = subbandCoefs{2};
                subbandCoef3 = subbandCoefs{3};
                subbandCoef4 = subbandCoefs{4};
                value{(nLevels-iLevel)*3+2} = subbandCoef2;
                value{(nLevels-iLevel)*3+3} = subbandCoef3;
                value{(nLevels-iLevel)*3+4} = subbandCoef4;
            end
            value{1} = subbandCoef1;
        end
        
    end
    
    methods ( Access = private )
        
        function this = rightShiftLowerCoefs_(this)
            for iRow = 1:this.nRows
                indexCol1 = iRow;
                colData0 = this.arrayCoefs(:,indexCol1);
                lowerCoefsPre = colData0(this.hLen+1:end);
                for iCol = 2:this.nCols
                    indexCol = (iCol-1)*this.nRows+iRow;
                    colData = this.arrayCoefs(:,indexCol);
                    lowerCoefsCur = colData(this.hLen+1:end);
                    colData(this.hLen+1:end) = lowerCoefsPre;
                    this.arrayCoefs(:,indexCol) = colData;
                    lowerCoefsPre = lowerCoefsCur;
                end
                colData0(this.hLen+1:end) = lowerCoefsPre;
                this.arrayCoefs(:,indexCol1) = colData0;
            end
        end
        
        function this = leftShiftUpperCoefs_(this)
            for iRow = 1:this.nRows
                indexCol1 = iRow;
                colData0 = this.arrayCoefs(:,indexCol1);
                upperCoefsPost = colData0(1:this.hLen);
                for iCol = this.nCols:-1:2
                    indexCol = (iCol-1)*this.nRows+iRow;
                    colData = this.arrayCoefs(:,indexCol);
                    upperCoefsCur = colData(1:this.hLen);
                    colData(1:this.hLen) = upperCoefsPost;
                    this.arrayCoefs(:,indexCol) = colData;
                    upperCoefsPost = upperCoefsCur;
                end
                colData0(1:this.hLen) = upperCoefsPost;
                this.arrayCoefs(:,indexCol1) = colData0;
            end
        end
        
        function this = downShiftLowerCoefs_(this)
            for iCol = 1:this.nCols
                indexCol1 = (iCol-1)*this.nRows+1;
                colData0 = this.arrayCoefs(:,indexCol1);
                lowerCoefsPre = colData0(this.hLen+1:end);
                for iRow = 2:this.nRows
                    indexCol = (iCol-1)*this.nRows+iRow;
                    colData = this.arrayCoefs(:,indexCol);
                    lowerCoefsCur = colData(this.hLen+1:end);
                    colData(this.hLen+1:end) = lowerCoefsPre;
                    this.arrayCoefs(:,indexCol) = colData;
                    lowerCoefsPre = lowerCoefsCur;
                end
                colData0(this.hLen+1:end) = lowerCoefsPre;
                this.arrayCoefs(:,indexCol1) = colData0;
            end
        end
        
        function this = upShiftUpperCoefs_(this)
            for iCol = 1:this.nCols
                indexCol1 = (iCol-1)*this.nRows+1;
                colData0 = this.arrayCoefs(:,indexCol1);
                upperCoefsPost = colData0(1:this.hLen);
                for iRow = this.nRows:-1:2
                    indexCol = (iCol-1)*this.nRows+iRow;
                    colData = this.arrayCoefs(:,indexCol);
                    upperCoefsCur = colData(1:this.hLen);
                    colData(1:this.hLen) = upperCoefsPost;
                    this.arrayCoefs(:,indexCol) = colData;
                    upperCoefsPost = upperCoefsCur;
                end
                colData0(1:this.hLen) = upperCoefsPost;
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
                supportExtensionHorizontal_(this,paramMtx1,paramMtx2)
            
            % Phase 1 for horizontal direction
            Ux1 = paramMtx1;
            I = eye(size(Ux1));
            this = blockButterfly_(this);
            this = rightShiftLowerCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            for iRow = 1:this.nRows
                for iCol = 1:this.nCols
                    if iCol == 1 && ~this.isPeriodicExt
                        U = -I;
                    else
                        U = Ux1;
                    end
                    this = lowerBlockRot_(this,iRow,iCol,U);
                end
            end
            
            % Phase 2 for horizontal direction
            Ux2 = paramMtx2;
            this = blockButterfly_(this);
            this = leftShiftUpperCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            for iRow = 1:this.nRows
                for iCol = 1:this.nCols
                    U = Ux2;
                    this = lowerBlockRot_(this,iRow,iCol,U);
                end
            end
        end
        
        function this = ...
                supportExtensionVertical_(this,paramMtx1,paramMtx2)
            
            % Phase 1 for vertical direction
            Uy1 = paramMtx1;
            I = eye(size(Uy1));
            this = blockButterfly_(this);
            this = downShiftLowerCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            for iCol = 1:this.nCols
                for iRow = 1:this.nRows
                    if iRow == 1 && ~this.isPeriodicExt
                        U = -I;
                    else
                        U = Uy1;
                    end
                    this = lowerBlockRot_(this,iRow,iCol,U);
                end
            end
            
            % Phase 2 for vertical direction
            Uy2 = paramMtx2;
            this = blockButterfly_(this);
            this = upShiftUpperCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            for iCol = 1:this.nCols
                for iRow = 1:this.nRows
                    U = Uy2;
                    this = lowerBlockRot_(this,iRow,iCol,U);
                end
            end
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
    
    methods (Access = private, Static = true)
              
        function value = permuteDctCoefs_(coefs)
            cee = coefs(1:2:end,1:2:end);
            coo = coefs(2:2:end,2:2:end);
            coe = coefs(2:2:end,1:2:end);
            ceo = coefs(1:2:end,2:2:end);
            value = [ cee(:) ; coo(:) ; coe(:) ; ceo(:) ];
            value = reshape(value,size(coefs));
        end
    end
    
end

