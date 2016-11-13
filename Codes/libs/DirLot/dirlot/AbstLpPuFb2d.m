classdef AbstLpPuFb2d < handle
    %ABSTLPPUFB2D Abstract class 2-D linear-phase paraunitary filter bank
    %   This class generates a 2-D LPPUFB by a set of
    %   controling parameters.
    %
    % SVN identifier:
    % $Id: AbstLpPuFb2d.m 225 2011-11-04 06:32:32Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit-2.0-beta1
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
    properties (GetAccess = public, SetAccess = protected)
        ordX;
        ordY;
        decX;
        decY;
        angles;
        mus;
        isInitialized;
        nHalfDecs;
        nStages;
        gvnrotT;
        matrixE0;
        paramMtx;
    end
    
    methods (Access = protected, Static = true, Abstract = true)
        value = getDefaultOrd_();
    end
    
    methods (Access = protected, Abstract = true)
        this = update_(this);
    end
    
    methods
        
        function this = AbstLpPuFb2d(varargin)
            
            if nargin == 1 && isa(varargin{1},'AbstLpPuFb2d')
                srcObj = varargin{1};
                props = properties(srcObj);
                for iProp = 1:length(props)
                    this.(props{iProp}) = srcObj.(props{iProp});
                end
            else
                this.isInitialized = false;
                if nargin < 1
                    this.decY = 2;
                    this.decX = 2;
                else
                    dec = varargin{1};
                    this.decX = dec(Direction.HORIZONTAL);
                    this.decY = dec(Direction.VERTICAL);
                end
                nDecs = (this.decX*this.decY);
                this.nHalfDecs = nDecs/2;
                if nargin < 2
                    ord = this.getDefaultOrd_();
                else
                    ord = varargin{2};
                end
                this.ordX = ord(Direction.HORIZONTAL);
                this.ordY = ord(Direction.VERTICAL);
                this.nStages = 1+this.ordX+this.ordY;
                if nargin < 3
                    this = setAngles(this,0);
                else
                    this = setAngles(this,varargin{3});
                end
                if nargin < 4
                    this = setMus(this,1);
                else
                    this = setMus(this,varargin{4});
                end
                this.matrixE0 = getMatrixE0_(this);
                this.paramMtx = cell(this.nStages+1,1);
            end
        end
        
        function this = setMus(this,mus)
            
            sizeOfMus = [ this.nHalfDecs this.nStages+1 ];
            
            if isscalar(mus) && mus == 1
                
                mus = -ones(sizeOfMus);
                mus(:,1:2) = ones(size(mus,1),2);
                
                if mod(this.ordX,2)==1 && ~isempty(this.gvnrotT)
                    mus(:,2) = getMus(this.gvnrotT);
                    mus(:,3) = getMus(this.gvnrotT);
                end
                if mod(this.ordY,2)==1
                    mus(:,this.ordX+3) = ones(size(mus,1),1);
                end
            end
            if size(mus,1) ~= sizeOfMus(1) || ...
                    size(mus,2) ~= sizeOfMus(2)
                
                id = 'DirLOT:IllegalArgumentException';
                
                msg = sprintf(...
                    'Size of mus must be [ %d %d ]',...
                    sizeOfMus(1), sizeOfMus(2));
                me = MException(id, msg);
                throw(me);
            else
                this.mus = mus;
            end
            if this.isInitialized
                this = update_(this);
            end
        end
        
        function this = setAngles(this,angles)
            
            
            nAngsPerStg = this.nHalfDecs*(this.nHalfDecs-1)/2;
            sizeOfAngles = [nAngsPerStg this.nStages+1];
            
            
            if isscalar(angles) && angles == 0
                angles = zeros(sizeOfAngles);
                if mod(this.ordX,2)==1
                    this = calcGvnRotT_(this);
                    angles(:,2) = getAngles(this.gvnrotT);
                    angles(:,3) = getAngles(this.gvnrotT);
                end
            end
            if size(angles,1) ~= sizeOfAngles(1) || ...
                    size(angles,2) ~= sizeOfAngles(2)
                
                id = 'DirLOT:IllegalArgumentException';
                
                msg = sprintf(...
                    'Size of angles must be [ %d %d ]',...
                    sizeOfAngles(1), sizeOfAngles(2));
                me = MException(id, msg);
                throw(me);
            else
                this.angles = angles;
            end
            if this.isInitialized
                this = update_(this);
            end
        end
        
        function value = double(this)
            matrixE = getPolyPhaseMatrix2d(this);
            value = double(matrixE);
        end
        
        function value = getPolyPhaseMatrix2d(this)
            H = getAnalysisFilterBank_(this);
            nSubbands = this.decY*this.decX;
            coefs = zeros(nSubbands,nSubbands,this.ordY+1,this.ordX+1);
            for iPhsX = 1:this.decX
                for iPhsY = 1:this.decY
                    iSubband = (iPhsX-1)*this.decY+iPhsY;
                    hi = H(:,:,iSubband);
                    for iOrdX = 0:this.ordX
                        for iOrdY = 0:this.ordY
                            b = hi(...
                                iOrdY*this.decY+1:(iOrdY+1)*this.decY,...
                                iOrdX*this.decX+1:(iOrdX+1)*this.decX);
                            coefs(iSubband,:,iOrdY+1,iOrdX+1) = b(:).';
                        end
                    end
                end
            end
            value = PolyPhaseMatrix2d(coefs);
        end
        
        function value = getAngles(this)
            value = this.angles;
        end
        
        function value = getMus(this)
            value = this.mus;
        end
        function value = getDec(this)
            value = [this.decY this.decX];
        end
        
        function value = getOrd(this)
            value = [this.ordY this.ordX];
        end
        
        function value = char(this)
            vectorH = getPolyPhaseMatrix2d(this)*getDelayChain_(this);
            value = char(vectorH);
        end
        
        function disp(this)
            disp([char(this) 10]);
        end
        
        function value = subsref(this,sub)
            % Implement a special subscripted assignment
            H = getAnalysisFilterBank_(this);
            switch sub.type
                case '()'
                    idx = sub.subs{1};
                    value = H(:,:,idx);
                otherwise
                    error('Specify subband index as obj(index)')
            end
        end % subsref
        
        function dispBasisImages(this)
            H = getAnalysisFilterBank_(this);
            for ib=1:2*this.nHalfDecs
                subplot(2,this.nHalfDecs,ib);
                subimage(fliplr(flipud(H(:,:,ib))+0.5));
                %subimage(rot90(H(:,:,ib))+0.5); % why rot90???
                title(num2str(ib));
                axis off;
            end
        end
        
        function value = getParameterMatrices(this)
            %value = this.paramMtx;
            if iscell(this.paramMtx)
                value = this.paramMtx;
            else
                value = cell(this.nStages+1,1);
                for iParamMtx = 1:this.nStages+1
                    value{iParamMtx} = this.paramMtx(:,:,iParamMtx);
                end
            end
        end
        
        function bimshow(this)
            H = getAnalysisFilterBank_(this);
            for ib=1:2*this.nHalfDecs
                subplot(this.decY,this.decX,ib);
                imshow(fliplr(flipud(H(:,:,ib))+0.5));
            end
        end
    end
    
    methods (Access = protected)
        
        function value = getAnalysisFilterBank_(this)
            this = update_(this);
            %
            I = getMatrixI_(this);
            E0 = this.matrixE0;
            %
            W = this.paramMtx{1};
            U = this.paramMtx{2};
            R = blkdiag(W,U);
            E = R*E0;
            iParamMtx = 3;
            % Horizontal extention
            for iOrdX = 1:this.ordX
                U = this.paramMtx{iParamMtx};
                R = blkdiag(I,U);
                E = R*AbstLpPuFb2d.processQx_(E);
                iParamMtx = iParamMtx+1;
            end
            % Vertical extention
            dec(Direction.VERTICAL)  = this.decY;
            dec(Direction.HORIZONTAL)  = this.decX;
            ord(Direction.HORIZONTAL)  = this.ordX;
            for iOrdY = 1:this.ordY
                ord(Direction.VERTICAL)  = iOrdY;
                U = this.paramMtx{iParamMtx};
                R = blkdiag(I,U);
                E = R*AbstLpPuFb2d.processQy_(E,dec,ord);
                iParamMtx = iParamMtx+1;
            end
            nSubbands = size(E,1);
            lenY = this.decY*(this.ordY+1);
            lenX = this.decX*(this.ordX+1);
            value = zeros(lenY,lenX,nSubbands);
            for iSubband = 1:nSubbands
                value(:,:,iSubband) = reshape(E(iSubband,:),lenY,lenX);
            end
            %             end
        end
        
        function value = getMatrixE0_(this)
            nRows = this.decY;
            nCols = this.decX;
            nElmBi = nRows*nCols;
            dctY = dctmtx(nRows);
            dctX = dctmtx(nCols);
            coefs = zeros(nElmBi);
            iElm = 1; % E0.'= [ Bee Boo Boe Beo ] % Byx
            for iCol = 1:2:nCols % x-e
                for iRow = 1:2:nRows % y-e
                    dctCoef = zeros(nRows,nCols);
                    dctCoef(iRow,iCol) = 1;
                    basisImage = dctY.'*dctCoef*dctX;
                    coefs(iElm,:) = basisImage(:).';
                    iElm = iElm + 1;
                end
            end
            for iCol = 2:2:nCols % x-o
                for iRow = 2:2:nRows % y-e
                    dctCoef = zeros(nRows,nCols);
                    dctCoef(iRow,iCol) = 1;
                    basisImage = dctY.'*dctCoef*dctX;
                    coefs(iElm,:) = basisImage(:).';
                    iElm = iElm + 1;
                end
            end
            for iCol = 1:2:nCols % x-e
                for iRow = 2:2:nRows % y-o
                    dctCoef = zeros(nRows,nCols);
                    dctCoef(iRow,iCol) = 1;
                    basisImage = dctY.'*dctCoef*dctX;
                    coefs(iElm,:) = -basisImage(:).';
                    iElm = iElm + 1;
                end
            end
            for iCol = 2:2:nCols % x-o
                for iRow = 1:2:nRows % y-e
                    dctCoef = zeros(nRows,nCols);
                    dctCoef(iRow,iCol) = 1;
                    basisImage = dctY.'*dctCoef*dctX;
                    coefs(iElm,:) = -basisImage(:).';
                    iElm = iElm + 1;
                end
            end
            value = coefs;
        end
        
        function value = getMatrixI_(this)
            value = eye(this.nHalfDecs);
        end
        
        function value = getMatrixZ_(this)
            value = zeros(this.nHalfDecs);
        end
        
        function value = getMatrixG_(this)
            value = diag((-1).^(0:2*this.nHalfDecs-1));
        end
        
        function this = calcGvnRotT_(this)
            nQ = this.nHalfDecs/2;
            matrixT = [zeros(nQ) eye(nQ) ; eye(nQ) zeros(nQ)];
            gvnT = GivensRotations();
            gvnT = setMatrix(gvnT,matrixT);
            this.gvnrotT = gvnT;
        end
        
        function value = getDelayChain_(this)
            idx = 1;
            delay = zeros(this.decX*this.decY,1,this.decY,this.decX);
            for iBndX = 1:this.decX
                for iBndY = 1:this.decY
                    delay(idx,:,iBndY,iBndX) = 1;
                    idx = idx + 1;
                end
            end
            value = PolyPhaseMatrix2d(delay);
        end
        
    end
    
    methods (Access = protected, Static = true)
        
        function value = processQx_(x)
            nDecs = size(x,1);
            hDecs = nDecs/2;
            value = AbstLpPuFb2d.butterfly_(x);
            % Block delay lower Coefs. in Horizontal direction
            Z = zeros(hDecs,nDecs);
            value = [
                value(1:hDecs,:) Z;
                Z value(hDecs+1:end,:) ];
            value = AbstLpPuFb2d.butterfly_(value)/2.0;
        end
        
        function value = processQy_(x,dec,ord)
            decY_ = dec(Direction.VERTICAL);
            decX_ = dec(Direction.HORIZONTAL);
            ordY_ = ord(Direction.VERTICAL);
            ordX_ = ord(Direction.HORIZONTAL);
            nDecs = size(x,1);
            hDecs = nDecs/2;
            value = AbstLpPuFb2d.butterfly_(x);
            % Block delay lower Coefs. in Horizontal direction
            nTapsYp = decY_*ordY_;
            nTapsY = decY_*(ordY_+1);
            nTapsX = decX_*(ordX_+1);
            nTaps = nTapsY*nTapsX;
            upper = zeros(hDecs,nTaps);
            lower = zeros(hDecs,nTaps);
            for idx = 0:decX_*(ordX_+1)-1
                range0 = idx*nTapsYp+1:(idx+1)*nTapsYp;
                range1 = idx*nTapsY+1:(idx+1)*nTapsY-decY_;
                range2 = idx*nTapsY+decY_+1:(idx+1)*nTapsY;
                upper(:,range1) = value(1:hDecs,    range0);
                lower(:,range2) = value(hDecs+1:end,range0);
            end
            value = [ upper ; lower ];
            value = AbstLpPuFb2d.butterfly_(value)/2.0;
        end
        
        function value = butterfly_(x)
            hDecs = size(x,1)/2;
            upper = x(1:hDecs,:);
            lower = x(hDecs+1:end,:);
            value = [
                upper+lower ;
                upper-lower ];
        end
    end
end
