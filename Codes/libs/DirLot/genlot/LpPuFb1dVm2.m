classdef LpPuFb1dVm2 < AbstLpPuFb1d
    %LPPUFB1DVM1 1-D LPPUFB with 2-order vanishing moments
    %   This class generates a 1-D LPPUFB by a set of
    %   controling parameters.
    %
    % SVN identifier:
    % $Id: LpPuFb1dVm2.m 249 2011-11-27 01:55:42Z sho $
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
    properties (GetAccess = public, SetAccess = public)
        sd;
    end
    
    properties (GetAccess = private, SetAccess = private)
        x3;
        lenx3;
        lambdaUeq;
        ckVm2;
    end
    
    methods
        
        function this = LpPuFb1dVm2(varargin)
            this = this@AbstLpPuFb1d(varargin{:});
            
            if this.ord < 2
                id = 'GenLOT:IllegalArgumentException';
                msg = 'Order must be greater than or equal to 2';
                me = MException(id, msg);
                throw(me);
            end
            
            if nargin < 5
                s = -1;
            else
                s = varargin{5};
            end
            this = setSign4Lambda(this,s);
            this = update_(this);
            this.isInitialized = true;
        end
        
        function this = setSign4Lambda(this,sd)
            this.sd = sd;
            if this.isInitialized
                this = update_(this);
            end
        end
        
        function value = getLengthX3(this)
            value = this.lenx3;
        end
        
        function value = getLambdaUeq(this)
            value = this.lambdaUeq;
        end
        
        function value = checkVm2(this)
            %
            value = this.ckVm2;
            if ~(getLengthX3(this)<=2)
                warning('GenLOT:Vm2Violation','Warning: ||x3|| > 2.');
            end
            if ~(getLambdaUeq(this)<=0)
                warning('GenLOT:Vm2Violation','Warning: lambda is violated.');
            end
        end
    end

    methods (Access = protected)
        
        function this = update_(this)
            
            this.angles(1:this.nHalfDec-1,1) = ...
                zeros(this.nHalfDec-1,1);
            this.mus(1,1) = 1;
            
            I = getMatrixI_(this);
            Z = getMatrixZ_(this);
            E0 = this.matrixE0;
            
            L = this.nHalfDec;
            M = this.dec;
            
            d = -(0:M-1).';
            b = 2/(M*sqrt(M))*[Z I]*E0*d;
            a = zeros(L,1);
            a(1) = 1;
            c = I;
            v = b;
            
            % W
            W = double(GivensRotations(this.angles(:,1),this.mus(:,1)));
            this.paramMtx{1} = W;
            iParamMtx = 2;
            
            nFree = this.ord-2;
            for iFree=1:nFree
                U = double(GivensRotations(this.angles(:,iParamMtx),...
                    this.mus(:,iParamMtx)));
                this.paramMtx{iParamMtx} = U;
                iParamMtx = iParamMtx + 1;
                c = [ I U * c ];
                v = [ a ; v ]; %#ok<AGROW>
            end
            
            % U(N-2)
            this.x3 =  c * v;
            this.lenx3 = norm( this.x3 );
            lambda1 = 2*real(asin(this.lenx3/2));
            lambda2 = real(acos(this.lenx3/2));
            lambda = lambda1 + lambda2;
            
            % to be revised
            %this.lambdaUeq = abs(cos(lambda))...
            %    - abs(prod(cos(this.angles(2:L-1,iParamMtx)))); % <= 0
            cc = cos(lambda)/prod(cos(this.angles(2:L-1,iParamMtx)));
            this.lambdaUeq = abs(cc) - 1; % <= 0
            %
            %this.angles(1,iParamMtx) = this.sd*real(acos(cos(lambda)/...
            %    prod(cos(this.angles(2:L-1,iParamMtx)))));
            this.angles(1,iParamMtx) = this.sd*real(acos(cc));
            this.mus(1,iParamMtx) = 1;
            %
            A = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            P = GivensRotations();
            P = setProjectionOfVector(P,this.x3);
            U = A*double(P);
            this.paramMtx{iParamMtx} = U;
            iParamMtx = iParamMtx + 1;
            c = [ I U * c ];
            v = [ a ; v ];
            
            % U(N-1)
            % to be revised
            this.angles(1:L-1,iParamMtx) = zeros(L-1,1);
            this.mus(1,iParamMtx) = 1;
            P = setProjectionOfVector(P, -a-U*this.x3);
            this.angles(:,iParamMtx) = this.angles(:,iParamMtx) + getAngles(P);
            U = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            this.paramMtx{iParamMtx} = U;
            iParamMtx = iParamMtx + 1;
            c = [ I U * c ];
            v = [ a ; v ];
            
            % UN
            U = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            this.paramMtx{iParamMtx} = U;
            
            % Check VM2
            this.ckVm2 = norm( c * v )/sqrt(L);
        end
    end
    
    methods (Access = protected, Static = true)
        function value = getDefaultOrd_()
            value = 2;
        end
    end
    
end
