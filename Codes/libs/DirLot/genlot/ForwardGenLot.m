classdef ForwardGenLot < handle
    %FORWARDGENLOT Forward generalized lapped orthogoal transform
    %
    % NOTE:
    % The number of decomposition should be even.
    % The order should be even.
    %
    % SVN identifier:
    % $Id: ForwardGenLot.m 316 2012-04-24 07:07:44Z harashin $
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
        hLen;
    end
    
    methods
        
        % Constructor
        function this = ForwardGenLot(varargin)
            
%             iptchecknargin(0,3,nargin,mfilename);

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
                    this.ord = length(this.paramMtx)-2;  % Equivalent order
                end
                if nargin < 3
                    this.isPeriodicExt = false; % Symmetric mode
                else
                    validStrings = { 'symmetric' 'circular' };
%                     string = iptcheckstrs(varargin{3},validStrings,...
%                         mfilename,'EXTENTION SCHEME',3);
                    string = validatestring(varargin{3},validStrings,...
                        mfilename,'EXTENTION SCHEME',3);
                    switch string
                        case 'symmetric'
                            this.isPeriodicExt = false; % Symmetric mode
                        case 'circular'
                            this.isPeriodicExt = true; % Periodic mode
                        otherwise
                            error('GenLot:ForwardGenLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
            else
                this.dec = getDec(varargin{1});
                this.paramMtx = getParameterMatrices(varargin{1});
                this.ord = getOrd(varargin{1});  % Not equivalent order
                
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
                            error('GenLot:ForwardGenLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
            end
            this.hLen = this.dec/2;
        end
        
        function this = forwardTransform(this,srcImg,varargin)
            
%             iptchecknargin(1,3,nargin,mfilename);
            narginchk(1,3);
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
                            error('GenLot:ForwardGenLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
            end
            
            this.nRows = size(srcImg,1);
            this.nCols = size(srcImg,2);
            this.nBlocks = this.nRows/this.dec;
            
            if isinteger(srcImg)
                srcImg = im2double(srcImg);
            end
            
            % Block DCT
            this.arrayCoefs = reshape(srcImg,this.dec,this.nBlocks*this.nCols);
            this.arrayCoefs = dct(this.arrayCoefs);
            this.arrayCoefs = ForwardGenLot.permuteDctCoefs_(this.arrayCoefs);
            
            if ~isempty(this.paramMtx)
                W0 = this.paramMtx{1};
                U0 = this.paramMtx{2};
                upperData = W0*this.arrayCoefs(1:this.hLen,:);
                lowerData = U0*this.arrayCoefs(this.hLen+1:end,:);
                this.arrayCoefs = [ upperData ; lowerData ];
            end
            
            % Support extension
            for iOrd = 1:this.ord/2  
                paramMtx1 = this.paramMtx{2*iOrd+1};
                paramMtx2 = this.paramMtx{2*iOrd+2};
                this = supportExtension_(this,paramMtx1,paramMtx2);
            end
            
            if isNatural
                arrayCoefs_ = zeros(size(this.arrayCoefs));
                arrayCoefs_(1:2:end,:) = this.arrayCoefs(1:this.hLen,:);
                arrayCoefs_(2:2:end,:) = this.arrayCoefs(this.hLen+1:end,:);
                this.arrayCoefs = arrayCoefs_;
            end
            
        end
        
        function value = getCoefs(this)
             value = reshape(this.arrayCoefs,this.nRows,this.nCols);
        end
        
        function value = getSubbandCoefs(this)
            value = cell(this.dec,1);
            for iSubband = 1:this.dec
                res = this.arrayCoefs(iSubband,:);
                value{iSubband} = reshape(res,this.nRows/this.dec,this.nCols);
            end
        end
        
        function value = getDec(this)
            value = this.dec;
        end
        
    end
    
    methods ( Access = private )
        
        function this = downShiftLowerCoefs_(this)
            for iCol = 1:this.nCols
                cData = this.arrayCoefs(this.hLen+1:end,....
                    (iCol-1)*this.nBlocks+1:iCol*this.nBlocks);
                cData = circshift(cData,[0 1]);
                this.arrayCoefs(this.hLen+1:end,....
                    (iCol-1)*this.nBlocks+1:iCol*this.nBlocks) = cData;
            end
        end
        
        function this = upShiftUpperCoefs_(this)
            for iCol = 1:this.nCols
                cData = this.arrayCoefs(1:this.hLen,....
                    (iCol-1)*this.nBlocks+1:iCol*this.nBlocks);
                cData = circshift(cData,[0 -1]);
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
        
        function this = supportExtension_(this,paramMtx1,paramMtx2)

            % Phase 1
            U1 = paramMtx1;
            I = eye(size(U1));
            this = blockButterfly_(this);
            this = downShiftLowerCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            for iBlock = 1:this.nBlocks
                if iBlock == 1 && ~this.isPeriodicExt
                    U = -I; % Symmetric extension
                else
                    U = U1;
                end
                this = lowerBlockRot_(this,iBlock,U);
            end
            
            % Phase 2
            U2 = paramMtx2;
            this = blockButterfly_(this);
            this = upShiftUpperCoefs_(this);
            this = blockButterfly_(this);
            this.arrayCoefs = this.arrayCoefs/2.0;
            for iBlock = 1:this.nBlocks
                U = U2;
                this = lowerBlockRot_(this,iBlock,U);
            end
        end
    end
    
    methods (Access = private, Static = true)
        
        function value = permuteDctCoefs_(coefs)
            value = [ coefs(1:2:end,:); coefs(2:2:end,:) ];
        end
        
    end
end