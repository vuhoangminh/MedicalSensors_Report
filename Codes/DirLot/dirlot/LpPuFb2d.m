classdef LpPuFb2d < handle 
    %LPPUFB2D Bridge to several 2-D LPPUFB classes
    %
    %   LPPUFB2D is not recommended.  Use LPPUFB2DFACTORY instead.
    %
    % SVN identifier:
    % $Id: LpPuFb2d.m 249 2011-11-27 01:55:42Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit-2.0-beta1
    %
    % Copyright (c) 2008-2010, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties
        lppufb;
    end
    
    % For compatibility with the original class definition
    properties (GetAccess = private, SetAccess = private)
        ordX;
        ordY;
        decX;
        decY;
        angles;
        mus;
        isInitialized;
        nHalfDecs;
        nStages;
        isVm1;
        isVm2;
        isDirVm;
        angleVm;
        gvnrotT;
        matrixE0;
        paramMtx;
        ckVm2;
        ckDirVm;
        sy;
        sx;
        x3x;
        x3y;
        lenx3x;
        lenx3y;
        lambdaxueq;
        lambdayueq;
    end
    
    methods
        
        function this = LpPuFb2d(varargin)
            warning('DirLOT:Deprecated',...
                'LPPUFB2D is not recommended. Use LPPUFB2DFACTORY instead.');
            
            if nargin == 1 && isa(varargin{1},'LpPuFb2d')
                vm = varargin{1}.lppufb;
                args = {};
            else
                if nargin < 5
                    vm = 0;
                    args = cell(1,nargin);
                    for idx = 1:nargin
                        args{idx} = varargin{idx};
                    end
                else
                    vm = varargin{5};
                    args = cell(1,nargin-1);
                    for idx = 1:4
                        args{idx} = varargin{idx};
                    end
                    for idx = 5:nargin-1
                        args{idx} = varargin{idx+1};
                    end
                end
            end
            
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(vm,args{:});
            
            
        end
        
        function value = double(this)
            if isempty(this.lppufb) % For original class definition
                matrixE = getPolyPhaseMatrix2d(this);
                value = double(matrixE);
            else
                value = double(this.lppufb);
            end
        end
        
        function this = setAngles(this,ang)
            this.lppufb = setAngles(this.lppufb,ang);
        end
        
        function this = setMus(this,mus)
            this.lppufb = setMus(this.lppufb,mus);
        end
        
        function this = setSigns4Lambda(this,sd)
            if isa(this.lppufb,'LpPuFb2dVm2')
                this.lppufb = setSigns4Lambda(this.lppufb,sd);
            elseif isa(this.lppufb,'LpPuFb2dTvm')
                sl = sd(1);
                this.lppufb = setSign4Lambda(this.lppufb,sl);
            end
        end
        
        function value = getType(this)
            if isempty(this.lppufb)
                value = 'LpPuFb2d';
            else
                value = class(this.lppufb);
            end
        end
        
        function value = getAngles(this)
            if isempty(this.lppufb) % For original class definition
                value = this.angles;
            else
                value = getAngles(this.lppufb);
            end
        end
        
        function value = getSigns4Lambda(this)
            if isempty(this.lppufb) % For original class definition
                value = [this.sy this.sx];
            else
                if isa(this.lppufb,'LpPuFb2dTvm')
                    value = getSign4Lambda(this.lppufb);
                elseif isa(this.lppufb,'LpPuFb2dVm2')
                    value = getSigns4Lambda(this.lppufb);
                end
            end
        end
        
        function value = getPolyPhaseMatrix2d(this)
            if isempty(this.lppufb) % For original class definition
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
            else
                value = getPolyPhaseMatrix2d(this.lppufb);
            end
        end
        
        function value = getPolyPhaseMatrix1d(this)
            if isempty(this.lppufb) % For original class definition
                H = getAnalysisFilterBank1d_(this);
                nSubbands = this.decX;
                coefs = zeros(nSubbands,nSubbands,this.ordX+1);
                for iSubband = 1:this.decX
                    hi = H(:,:,iSubband);
                    for iOrdX = 0:this.ordX
                        b = hi(1,iOrdX*this.decX+1:(iOrdX+1)*this.decX);
                        coefs(iSubband,:,iOrdX+1) = b(:).';
                    end
                end
                value = PolyPhaseMatrix(coefs);
            else
                value = getPolyPhaseMatrix1d(this.lppufb);
            end
        end
        
        function value = getLengthX3(this)
            if isempty(this.lppufb) % For original class definition
                if this.isVm2
                    value(Direction.VERTICAL) = this.lenx3y;
                    value(Direction.HORIZONTAL) = this.lenx3x;
                elseif this.isDirVm
                    value = this.lenx3x;
                else
                    value = [];
                end
            else
                value = getLengthX3(this.lppufb);
            end
        end
        
        function value = getLambdaUeq(this)
            if isempty(this.lppufb) % For original class definition
                if this.isVm2
                    value(Direction.VERTICAL) = this.lambdayueq;
                    value(Direction.HORIZONTAL) = this.lambdaxueq;
                elseif this.isDirVm
                    value = this.lambdaxueq;
                else
                    value = [];
                end
            else
                value = getLambdaUeq(this.lppufb);
            end
        end
        
        function value = getLengthX3x(this)
            if isempty(this.lppufb) % For original class definition
                value = this.lenx3x;
            else
                value = getLengthX3x(this.lppufb);
            end
        end
        
        function value = getLengthX3y(this)
            if isempty(this.lppufb) % For original class definition
                value = this.lenx3y;
            else
                value = getLengthX3y(this.lppufb);
            end
        end
        
        function value = getLambdaXueq(this)
            if isempty(this.lppufb) % For original class definition
                value = this.lambdaxueq;
            else
                value = getLambdaXueq(this.lppufb);
            end
        end
        
        function value = getLambdaYueq(this)
            if isempty(this.lppufb) % For original class definition
                value = this.lambdayueq;
            else
                value = getLambdaYueq(this.lppufb);
            end
        end
        
        function [value0 value1] = checkDirVm(this)
            if isempty(this.lppufb) % For original class definition
                value0 = this.ckDirVm;
                value1 = this.angleVm;
                if ~(getLengthX3(this)<=2)
                    disp('Warnning: ||x3|| > 2.');
                end
                if ~(getLambdaUeq(this)<=0)
                    disp('Warnning: lambda is violated.');
                end
            else
                [value0 value1] = checkTvm(this.lppufb);
            end
        end
        
        function value = checkVm2(this)
            if isempty(this.lppufb) % For original class definition
                %
                value = this.ckVm2;
                if ~(getLengthX3x(this)<=2)
                    disp('Warnning: ||x3x|| > 2.');
                end
                if ~(getLengthX3y(this)<=2)
                    disp('Warnning: ||x3y|| > 2.');
                end
                if ~(getLambdaXueq(this)<=0)
                    disp('Warnning: lambdax is violated.');
                end
                if ~(getLambdaYueq(this)<=0)
                    disp('Warnning: lambday is violated.');
                end
                %
            else
                value = checkVm2(this.lppufb);
            end
        end
        
        function value = char(this)
            if isempty(this.lppufb) % For original class definition
                vectorH = getPolyPhaseMatrix2d(this)*getDelayChain_(this);
                value = char(vectorH);
            else
                value = char(this.lppufb);
            end
        end
        
        function value = subsref(this,sub)
            if isempty(this.lppufb) % For original class definition
                H = getAnalysisFilterBank_(this);
                switch sub.type
                    case '()'
                        idx = sub.subs{1};
                        value = H(:,:,idx);
                    otherwise
                        error('Specify subband index as obj(index)')
                end
            else
                value = subsref(this.lppufb,sub);
            end
        end
        
        function value = getParameterMatrices(this)
            if isempty(this.lppufb) % For original class definition
                if iscell(this.paramMtx)
                    value = this.paramMtx;
                else
                    value = cell(this.nStages+1,1);
                    for iParamMtx = 1:this.nStages+1
                        value{iParamMtx} = this.paramMtx(:,:,iParamMtx);
                    end
                end
            else
                value = getParameterMatrices(this.lppufb);
            end
        end
        
        function value = getSeparableBasis(this,direction,idx)
            value = getSeparableBasis(this.lppufb,direction,idx);
        end
        
        function value = getMus(this)
            if isempty(this.lppufb) % For original class definition
                value = this.mus;
            else
                value = getMus(this.lppufb);
            end
        end
        
        function value = getDec(this)
            if isempty(this.lppufb) % For original class definition
                value = [this.decY this.decX];
            else
                value = getDec(this.lppufb);
            end
        end
        
        function value = getOrd(this)
            if isempty(this.lppufb) % For original class definition
                value = [this.ordY this.ordX];
            else
                value = getOrd(this.lppufb);
            end
        end
        
        function dispBasisImages(this)
            if isempty(this.lppufb) % For original class definition
                H = getAnalysisFilterBank_(this);
                for ib=1:2*this.nHalfDecs
                    subplot(2,this.nHalfDecs,ib);
                    subimage(fliplr(flipud(H(:,:,ib)))+0.5); %#ok
                    %subimage(rot90(H(:,:,ib))+0.5); % why rot90???
                    title(num2str(ib));
                    axis off;
                end
            else
                dispBasisImages(this.lppufb)
            end
        end
        
        function bimshow(this)
            bimshow(this.lppufb)
        end
        
    end
    
    % For original class definition
    methods (Access = private)
        
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
        
        function value = getAnalysisFilterBank_(this)
            %this = update_(this);
            if ~iscell(this.paramMtx)
                value = cell(this.nStages+1,1);
                for iParamMtx = 1:this.nStages+1
                    value{iParamMtx} = this.paramMtx(:,:,iParamMtx);
                end
                this.paramMtx = value;
            end
            
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
                E = R*LpPuFb2d.processQx_(E);
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
                E = R*LpPuFb2d.processQy_(E,dec,ord);
                iParamMtx = iParamMtx+1;
            end
            nSubbands = size(E,1);
            lenY = this.decY*(this.ordY+1);
            lenX = this.decX*(this.ordX+1);
            value = zeros(lenY,lenX,nSubbands);
            for iSubband = 1:nSubbands
                value(:,:,iSubband) = reshape(E(iSubband,:),lenY,lenX);
            end
        end
        
        function value = getAnalysisFilterBank1d_(this)     % TODO: Test other order case
            %this = update_(this);
            %
            I = getMatrixI_(this);
            E0 = this.matrixE0;
            %
            W = this.paramMtx{1};
            U = this.paramMtx{2};
            R = blkdiag(W,U);
            E = R*E0;
            iParamMtx = 3;
            % 1D extention
            for iOrdX = 1:this.ordX
                U = this.paramMtx{iParamMtx};
                R = blkdiag(I,U);
                E = R*AbstLpPuFb2d.processQx_(E);
                iParamMtx = iParamMtx+1;
            end
            nSubbands = size(E,1);
            len = this.decX*(this.ordX+1);
            value = zeros(1,len,nSubbands);
            for iSubband = 1:nSubbands
                value(:,:,iSubband) = E(iSubband,:);
            end
        end
        
        function value = getMatrixI_(this)
            value = eye(this.nHalfDecs);
        end
        
    end
    
    % For original class definition
    methods (Access = private, Static = true)
        
        function value = processQx_(x)
            nDecs = size(x,1);
            hDecs = nDecs/2;
            value = LpPuFb2d.butterfly_(x);
            % Block delay lower Coefs. in Horizontal direction
            Z = zeros(hDecs,nDecs);
            value = [
                value(1:hDecs,:) Z;
                Z value(hDecs+1:end,:) ];
            value = LpPuFb2d.butterfly_(value)/2.0;
        end
        
        function value = processQy_(x,dec,ord)
            decY_ = dec(Direction.VERTICAL);
            decX_ = dec(Direction.HORIZONTAL);
            ordY_ = ord(Direction.VERTICAL);
            ordX_ = ord(Direction.HORIZONTAL);
            nDecs = size(x,1);
            hDecs = nDecs/2;
            value = LpPuFb2d.butterfly_(x);
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
            value = LpPuFb2d.butterfly_(value)/2.0;
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
