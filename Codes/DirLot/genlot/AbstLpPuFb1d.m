classdef AbstLpPuFb1d < handle
    %ABSTLPPUFB1D One-dimensional linear-phase paraunitary filter banks.
    %   This class generates a 1-D LPPUFB by a set of
    %   controling parameters.
    %
    % SVN identifier:
    % $Id: AbstLpPuFb1d.m 249 2011-11-27 01:55:42Z sho $
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
    properties (GetAccess = public, SetAccess = protected)
        ord;
        dec;
        angles;
        mus;
        isInitialized;
        nHalfDec;
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
        
        function this = AbstLpPuFb1d(varargin)
            
            if nargin == 1 && isa(varargin{1},'AbstLpPuFb1d')
                srcObj = varargin{1};
                props = properties(srcObj);
                for iProp = 1:length(props)
                    this.(props{iProp}) = srcObj.(props{iProp});
                end
            else
                this.isInitialized = false;
                if nargin < 1
                    this.dec = 4;
                else
                    this.dec = varargin{1};
                end
                this.nHalfDec = this.dec/2;
                if nargin < 2
                    this.ord = this.getDefaultOrd_();
                else
                    this.ord = varargin{2};
                end
                this.nStages = 1+this.ord;
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
            
            sizeOfMus = [ this.nHalfDec this.nStages+1 ];
            
            if isscalar(mus) && mus == 1
                mus = -ones(sizeOfMus);
                mus(:,1:2) = ones(size(mus,1),2);
            end
            if size(mus,1) ~= sizeOfMus(1) || ...
                    size(mus,2) ~= sizeOfMus(2)
                id = 'GenLOT:IllegalArgumentException';
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
            nAngsPerStg = this.nHalfDec*(this.nHalfDec-1)/2;
            sizeOfAngles = [nAngsPerStg this.nStages+1];
            if isscalar(angles) && angles == 0
                angles = zeros(sizeOfAngles);
            end
            if size(angles,1) ~= sizeOfAngles(1) || ...
                    size(angles,2) ~= sizeOfAngles(2)
                id = 'GenLOT:IllegalArgumentException';
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
            matrixE = getPolyPhaseMatrix(this);
            value = double(matrixE);
        end
        
        function value = getPolyPhaseMatrix(this)
            H = getAnalysisFilterBank_(this);
            nSubbands = this.dec;
            coefs = zeros(nSubbands,nSubbands,this.ord+1);
            for iPhs = 1:this.dec
                iSubband = iPhs;
                hi = H(iSubband,:); % TODO
                for iOrd = 0:this.ord
                    b = hi(iOrd*this.dec+1:(iOrd+1)*this.dec);
                    coefs(iSubband,:,iOrd+1) = b(:).';
                end
            end
            value = PolyPhaseMatrix(coefs);
        end
        
        function value = getAngles(this)
            value = this.angles;
        end
        
        function value = getMus(this)
            value = this.mus;
        end
        
        function value = getDec(this)
            value = this.dec;
        end

        function value = getOrd(this)
            value = this.ord;
        end

        function value = char(this)
            vectorH = getPolyPhaseMatrix(this)*getDelayChain_(this);
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
                    value = H(idx,:);
                otherwise
                    error('Specify subband index as obj(index)')
            end
        end % subsref
        
        function dispBasisVectors(this)
            
                H = getAnalysisFilterBank_(this);
                for ib=1:2*this.nHalfDec
                    subplot(2,this.nHalfDec,ib)
                    impz(fliplr(H(ib,:)))
                    title(num2str(ib))
                    axis([0 this.dec*(this.ord+1)-1 -1 1])
                end
        end

        function value = getParameterMatrices(this)
            value = this.paramMtx;
        end

%         function value = get(this,fieldName)
%             switch fieldName
%                 case 'xxx'
%                     value = this.xxx;
%                 case 'yyy'
%                     value = this.yyy;
%                 otherwise
%                     id = 'GetLot:IllegalArgumentException';
%                     msg = [fieldName,...
%                         ' Invalid filed name'];
%                     me = MException(id, msg);
%                     throw(me);
%             end
%         end
        %}
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
            % Basis extention
            for iOrd = 1:this.ord
                U = this.paramMtx{iParamMtx};
                R = blkdiag(I,U);
                E = R*AbstLpPuFb1d.processQ_(E);
                iParamMtx = iParamMtx+1;
            end
            value = E;
        end
        
        function value = getMatrixE0_(this)
            coefs = dctmtx(this.dec);
            value = [ 
                coefs(1:2:end,:);
               -coefs(2:2:end,:) ];
        end
        
        function value = getMatrixI_(this)
            value = eye(this.nHalfDec);
        end
        
        function value = getMatrixZ_(this)
            value = zeros(this.nHalfDec);
        end
        
        %{
        function value = getMatrixG_(this)
            value = diag((-1).^(0:this.dec-1));
        end
        %}
        function this = calcGvnRotT_(this)
            nQ = this.nHalfDec/2;
            matrixT = [zeros(nQ) eye(nQ) ; eye(nQ) zeros(nQ)];
            gvnT = GivensRotations();
            gvnT = setMatrix(gvnT,matrixT);
            this.gvnrotT = gvnT;
        end

        function value = getDelayChain_(this)
            delay = zeros(this.dec,1,this.dec);
            for iBnd = 1:this.dec
                delay(iBnd,1,iBnd) = 1;
            end
            value = PolyPhaseMatrix(delay);
        end

    end
    
    methods (Access = protected, Static = true)
        
        function value = processQ_(x)
            nDecs = size(x,1);
            hDecs = nDecs/2;
            value = AbstLpPuFb1d.butterfly_(x);
            % Block delay lower Coefs. in Horizontal direction
            Z = zeros(hDecs,nDecs);
            value = [
                value(1:hDecs,:) Z;
                Z value(hDecs+1:end,:) ];
            value = AbstLpPuFb1d.butterfly_(value)/2.0;
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
