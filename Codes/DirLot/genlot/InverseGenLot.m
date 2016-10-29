classdef InverseGenLot < handle
    %INVERSEGENLOT Inverse generalized lapped orthogoal transform
    %
    % NOTE:
    % The number of decomposition should be even.
    % The order should be even.
    %
    % SVN identifier:
    % $Id: InverseGenLot.m 316 2012-04-24 07:07:44Z harashin $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2011, Shogo MURAMATSU
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
        dec;
        ord;
        nRows;
        nCols;
        nBlocks;
        arrayCoefs;
        paramMtx;
        isPeriodicExt;
        %modeTerminationCheck;
        %trmCkOffset;
        hLen;
    end
    
    methods
        
        % constractor
        function this = InverseGenLot(varargin)
            
            %iptchecknargin(0,3,nargin,mfilename);
            narginchk(0,3);
            
            if(nargin == 0 || ~isa(varargin{1},'AbstLpPuFb1d'))
                if nargin < 1
                    this.dec = 4;
                else
                    this.dec = varargin{1};
                end
                if nargin < 2
                    this.paramMtx = [];
                    this.ord = 0;
                else
                    this.paramMtx = varargin{2};
                    this.ord = length(this.paramMtx)-2;
                end
                if nargin < 3
                    this.isPeriodicExt = false; % Symmetric mode
                else
                    validStrings = { 'symmetric' 'circular' };
                    %string = iptcheckstrs(varargin{3},validStrings,...
                    %    mfilename,'EXTENTION SCHEME',3);
                    string = validatestring(varargin{3},validStrings,...
                        mfilename,'EXTENTION SCHEME',3);
                    switch string
                        case 'symmetric'
                            this.isPeriodicExt = false; % Symmetric mode
                        case 'circular'
                            this.isPeriodicExt = true; % Periodic mode
                        otherwise
                            error('GenLot:InverseGenLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
            else
                this.dec = getDec(varargin{1});
                this.paramMtx = getParameterMatrices(varargin{1});
                this.ord = getOrd(varargin{1});
                if nargin < 2
                    this.isPeriodicExt = false; % Symmetric mode
                else
                    validStrings = { 'symmetric' 'circular' };
%                     string = iptcheckstrs(varargin{2},validStrings,...
%                         mfilename,'EXTENTION SCHEME',3);
                     string = validatestring(varargin{2},validStrings,...
                         mfilename,'EXTENTION SCHEME',3);
                    
                    switch string
                        case 'symmetric'
                            this.isPeriodicExt = false; % Symmetric mode
                        case 'circular'
                            this.isPeriodicExt = true; % Periodic mode
                        otherwise
                            error('GenLot:InverseGenLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
            end
            this.hLen = this.dec/2;
            %this.modeTerminationCheck = int32(0);
            %this.trmCkOffset = int32(0);
        end
        
        function this = inverseTransform(this,subCoefs,varargin)
            %iptchecknargin(2,3,nargin,mfilename);
             narginchk(2,3);
            isNatural = false;
            if nargin > 2
                validStrings = { 'natural' 'default' };
%                 string = iptcheckstrs(varargin{1},validStrings,...
%                     mfilename,'SUBBAND ORDER',3);
                string = validatestring(varargin{1},validStrings,...
                    mfilename,'SUBBAND ORDER',3);
                
                switch string
                    case 'natural'
                        isNatural = true;
                    case 'default'
                        isNatural = false;
                    otherwise
                        error('GenLot:InverseGenLot:unexpectedError', ...
                            '%s', 'Unexpected logic error.')
                end
            end
            
            if iscell(subCoefs)     % When input cell matrix
                tmp = 0;
                for iSubband = 1:this.dec
                    tmp = tmp + ....
                        upsample(subCoefs{iSubband},this.dec,iSubband-1);
                end
                subCoefs = tmp;
            end
            this.nRows = size(subCoefs,1);
            this.nCols = size(subCoefs,2);
            this.nBlocks = this.nRows/this.dec;
            if isinteger(subCoefs)
                subCoefs = double(subCoefs);
            end
            this.arrayCoefs = ...
                reshape(subCoefs,this.dec,this.nBlocks*this.nCols);
            if isNatural
                this.arrayCoefs = [ 
                    this.arrayCoefs(1:2:end,:) ;
                    this.arrayCoefs(2:2:end,:) ];                    
            end            

            % Bases combination
            for iOrd = this.ord/2:-1:1
                paramMtx1 = this.paramMtx{2*iOrd+2};
                paramMtx2 = this.paramMtx{2*iOrd+1};
                this = basesCombination_(this,paramMtx1,paramMtx2);
            end
            
            if ~isempty(this.paramMtx)
                W0 = this.paramMtx{1}.';
                U0 = this.paramMtx{2}.';
                upperData = W0*this.arrayCoefs(1:this.hLen,:);
                lowerData = U0*this.arrayCoefs(this.hLen+1:end,:);
                this.arrayCoefs = [ upperData ; lowerData ];
            end
            
            % Block IDCT
            this.arrayCoefs = InverseGenLot.permuteIdctCoefs_(this.arrayCoefs);
            this.arrayCoefs = idct(this.arrayCoefs);
            
        end

        function value = getImage(this)
            value = reshape(this.arrayCoefs,this.nRows,this.nCols);
        end

        function value = getDec(this)
            value = this.dec;
        end
        
    end
    
    methods ( Access = private )
  
        function this = upShiftLowerCoefs_(this)
            for iCol = 1:this.nCols
                cData = this.arrayCoefs(this.hLen+1:end,....
                    (iCol-1)*this.nBlocks+1:iCol*this.nBlocks);
                cData = circshift(cData,[0 -1]);
                this.arrayCoefs(this.hLen+1:end,....
                    (iCol-1)*this.nBlocks+1:iCol*this.nBlocks) = cData;
            end
        end
        
        function this = downShiftUpperCoefs_(this)
            for iCol = 1:this.nCols
                cData = this.arrayCoefs(1:this.hLen,....
                    (iCol-1)*this.nBlocks+1:iCol*this.nBlocks);
                cData = circshift(cData,[0 1]);
                this.arrayCoefs(1:this.hLen,...
                    (iCol-1)*this.nBlocks+1:iCol*this.nBlocks) = cData;
            end
        end
        
        function this = blockButterfly_(this)
            upper = this.arrayCoefs(1:this.hLen,:);
            lower = this.arrayCoefs(this.hLen+1:end,:);
            this.arrayCoefs = [
                upper + lower;
                upper - lower ];
        end
        
        function this = lowerBlockRot_(this,iBlock,U)
            cData = this.arrayCoefs(this.hLen+1:end,...
                iBlock:this.nBlocks:end);
            this.arrayCoefs(this.hLen+1:end,...
                iBlock:this.nBlocks:end) = U*cData;
        end
        
        function this = basesCombination_(this,paramMtx1,paramMtx2)
            
            % Phase 1 
            U2 = paramMtx1.';
            for iBlock = 1:this.nBlocks
                U = U2;
                this = lowerBlockRot_(this,iBlock,U);
            end
            this = blockButterfly_(this);
            this = downShiftUpperCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            
            % Phase 2 
            U1 = paramMtx2.';
            I = eye(size(U1));
            for iBlock = 1:this.nBlocks
                if iBlock == 1 && ~this.isPeriodicExt
                    U = -I; % Symmetric extension
                else
                    U = U1;
                end
                this = lowerBlockRot_(this,iBlock,U);
            end
            this = blockButterfly_(this);
            this = upShiftLowerCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            
        end
        
    end
    
    methods (Access = private, Static = true )
        
        function value = permuteIdctCoefs_(coefs)
            dec_ = size(coefs,1);
            hLen_ = dec_/2;
            value(1:2:dec_-1,:) = coefs(1:hLen_,:);
            value(2:2:dec_,:) = coefs(hLen_+1:end,:);
        end
        
        %{
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
        %}
    end
    
end

