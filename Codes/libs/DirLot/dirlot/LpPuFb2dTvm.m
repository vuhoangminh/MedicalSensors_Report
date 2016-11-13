classdef LpPuFb2dTvm < AbstLpPuFb2d
    %LPPUFB2DTVM 2-D LPPUFB with 2-order trend vanishing moments
    %   This class generates a 2-D LPPUFB by a set of
    %   controling parameters.
    %
    % SVN identifier:
    % $Id: LpPuFb2dTvm.m 243 2011-11-22 09:12:42Z sho $
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
    properties (GetAccess = public, SetAccess = private)
        angleVm; % degree
        sl;
    end
    
    properties (GetAccess = private, SetAccess = private)
        x3;
        lenx3;
        lambdaueq
        ckTvm;
    end
    
    methods
        
        function this = LpPuFb2dTvm(varargin)
            this = this@AbstLpPuFb2d(varargin{2:end});
            if this.decX ~= this.decY
                id = 'DirLOT:IllegalArgumentException';
                msg = 'My and Mx must be the same as each other';
                me = MException(id, msg);
                throw(me);
            end
            if this.ordX + this.ordY < 2
                id = 'DirLOT:IllegalArgumentException';
                msg = 'Order must be greater than or equal to 2';
                me = MException(id, msg);
                throw(me);
            end
            if nargin == 1 && isa(varargin{1},'LpPuFb2dTvm')
                srcObj = varargin{1};
                props = properties(srcObj);
                for iProp = 1:length(props)
                    this.(props{iProp}) = srcObj.(props{iProp});
                end
            else
                if nargin < 1
                    this.angleVm = 0;
                else % Maps angleVm into [-45,135]
                    this.angleVm = mod(varargin{1}+45,180)-45;
                end
                if nargin < 6
                    this = setSign4Lambda(this,1);
                else
                    this = setSign4Lambda(this,varargin{6});
                end
            end
            this = update_(this);
            this.isInitialized = true;
        end
        
        function this = setSign4Lambda(this,sl)
            this.sl = sl;
            if this.isInitialized
                this = update_(this);
            end
        end
        
        function this = setSigns4Lambda(this,sd)
            this = setSign4Lambda(this,sd(1));
        end
        
        function value = getLengthX3(this)
            value = this.lenx3;
        end
        
        function value = getLambdaUeq(this)
            value = this.lambdaueq;
        end
        
        function value = getSign4Lambda(this)
            value = this.sl;
        end
        
        function [valueC valueA]= checkTvm(this)
            valueC = this.ckTvm;
            valueA = this.angleVm;
            if ~(getLengthX3(this)<=2)
                disp('Warnning: ||x3|| > 2.');
            end
            if ~(getLambdaUeq(this)<=0)
                disp('Warnning: lambda is violated.');
            end
        end
        
        function dispBasisImages(this)
            if ~(getLengthX3(this)<=2)
                disp('Warnning: ||x3|| > 2.');
            end
            if ~(getLambdaUeq(this)<=0)
                disp('Warnning: lambda is violated.');
            end
            dispBasisImages@AbstLpPuFb2d(this);
        end
        
    end
    
    methods (Access = protected)
        
        function this = update_(this)
            
            % VM1 condition
            this.angles(1:this.nHalfDecs-1,1) = zeros(this.nHalfDecs-1,1);
            this.mus(1,1) = 1;
            
            % W0, Unx, Uny
            for iParamMtx=1:this.nStages+1
                this.paramMtx{iParamMtx} = ...
                    double(GivensRotations(this.angles(:,iParamMtx),...
                    this.mus(:,iParamMtx)));
            end
            
            % TVM condition
            if this.ordX >= 2 && this.angleVm <= 45 % Table I
                this = updateParameterMatricesTvmHorizontal_(this);
            elseif this.ordY >= 2 && ...
                    (this.angleVm >= 45 || this.angleVm == -45 )% Table II
                this = updateParameterMatricesTvmVertical_(this);
                %elseif this.ordY == 1 && this.ordX == 1 && ...
                %   this.angleVm ~= 0 && this.angleVm ~= 90
                %
            else
                id = 'DirLOT:IllegalArgumentException';
                msg = 'Unsupported combination of PHI and ORD';
                me = MException(id, msg);
                throw(me);
            end
            
        end
        
        function this = updateParameterMatricesTvmHorizontal_(this)
            
            % Calculate \bar{x}_3 and the length
            this.x3 = getBarX3Horizontal_(this);
            this.lenx3 = norm( this.x3 );
            
            % Calculate lambda
            lambda1 = real(acos(1-(this.lenx3^2)/2));
            lambda2 = real(acos(this.lenx3/2));
            lambda = lambda1 + lambda2;
            
            % Calculate U_{Nx-2} and U_{Nx-1}
            L = this.nHalfDecs;
            a = zeros(L,1);
            a(1) = 1;
            
            iParamMtx = this.ordX; % Nx-2
            %this.lambdaueq = abs(cos(lambda))...
            %    -abs(prod(cos(this.angles(2:L-1,iParamMtx)))); % <= 0
            cc = cos(lambda)/(prod(cos(this.angles(2:L-1,iParamMtx))));
            this.lambdaueq = abs(cc) -1; % <= 0
            %
            %this.angles(1,iParamMtx) = this.sl*real(acos(cos(lambda)/...
            %    prod(cos(this.angles(2:L-1,iParamMtx)))));
            this.angles(1,iParamMtx) = this.sl*real(acos(cc));
            this.mus(1,iParamMtx) = 1;
            %
            A = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            P = GivensRotations();
            P = setProjectionOfVector(P, this.x3);
            Vb = A*double(P);
            this.paramMtx{iParamMtx} = Vb;
            iParamMtx = iParamMtx + 1;
            
            % U_{Nx-1}
            % to be revised
            this.angles(1:L-1,iParamMtx) = zeros(L-1,1);
            this.mus(1,iParamMtx) = 1;
            P = setProjectionOfVector(P, -a-Vb*this.x3);
            this.angles(:,iParamMtx) = this.angles(:,iParamMtx) + getAngles(P);
            Va = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            this.paramMtx{iParamMtx} = Va;
            iParamMtx = iParamMtx + 1;
            
            % U_{Nx} = \bar{U} * U_{Nx-2}.' * U_{Nx-1}.'
            if this.ordY > 0
                U = this.paramMtx{iParamMtx} * ...
                    this.paramMtx{iParamMtx-2}.' * ...
                    this.paramMtx{iParamMtx-1}.';
                this.paramMtx{iParamMtx} = U;
            end
            
            % Check TVM
            vx1 = a;
            vx2 = Va*a;
            vx3 = Va*Vb*this.x3;
            this.ckTvm = norm( vx1 + vx2 + vx3 )/sqrt(L);
        end
        
        function value = getBarX3Horizontal_(this)
            
            I = getMatrixI_(this);
            Z = getMatrixZ_(this);
            E0 = this.matrixE0;
            %
            L = this.nHalfDecs;
            M = 2*L;
            My = this.decY;
            phi = pi * this.angleVm /180.0;
            %
            dy = -mod(0:M-1,My).';
            dx = -floor((0:M-1)/My).';
            by = 2/sqrt(M)*[Z I]*double(E0)*dy;
            bx = 2/sqrt(M)*[Z I]*double(E0)*dx;
            bphix = (1/sqrt(M))*(tan(phi)*by + bx);
            a = zeros(L,1);
            a(1) = 1;
            
            % u0
            u0 = bphix;
            iParamMtx = 2; % n=0
            for iFree=1:this.ordX-2
                U = this.paramMtx{iParamMtx};
                iParamMtx = iParamMtx + 1;
                u0 = U * u0;
            end
            
            % u1
            u1 = zeros(L,1);
            if this.ordX > 2
                u1 = a;
                iParamMtx = 3; % nx=1
                for iFree=1:this.ordX-3
                    U = this.paramMtx{iParamMtx};
                    u1 = U * u1 + a;
                    iParamMtx = iParamMtx + 1;
                end
            end
            
            % u2
            u2 = zeros(L,1);
            if this.ordY > 0
                v = a;
                iParamMtx = this.nStages; % ny=Ny-1
                for iFree=2:this.ordY
                    U = this.paramMtx{iParamMtx};
                    v = U.' * v + a;
                    iParamMtx = iParamMtx - 1;
                end
                iParamMtx = this.ordX+2; % nx=Nx as \bar{U}
                U = this.paramMtx{iParamMtx};
                u2 = tan(phi) * U.' * v;
            end
            
            % \bar{x}_3
            value = u0 + u1 + u2;
        end
        
        function this = updateParameterMatricesTvmVertical_(this)
            
            % Calculate \bar{x}_3 and the length
            this.x3 = getBarX3Vertical_(this);
            this.lenx3 = norm( this.x3 );
            
            % Calculate lambda
            lambda1 = real(acos(1-(this.lenx3^2)/2));
            lambda2 = real(acos(this.lenx3/2));
            lambda = lambda1 + lambda2;
            
            % Update U_{N-2} and U_{N-1}
            L = this.nHalfDecs;
            a = zeros(L,1);
            a(1) = 1;
            
            iParamMtx = this.nStages-1; % U_{Ny-2}
            %this.lambdaueq = abs(cos(lambda))...
            %    -abs(prod(cos(this.angles(2:L-1,iParamMtx)))); % <= 0
            cc = cos(lambda)/(prod(cos(this.angles(2:L-1,iParamMtx))));
            this.lambdaueq = abs(cc) -1; % <= 0
            %
            %this.angles(1,iParamMtx) = this.sl*real(acos(cos(lambda)/...
            %    prod(cos(this.angles(2:L-1,iParamMtx)))));
            this.angles(1,iParamMtx) = this.sl*real(acos(cc));
            this.mus(1,iParamMtx) = 1;
            %
            A = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            P = GivensRotations();
            P = setProjectionOfVector(P, this.x3);
            Vb = A*double(P);
            this.paramMtx{iParamMtx} = Vb;
            iParamMtx = iParamMtx + 1;
            
            % Uy_{Ny-1}
            % to be revised
            this.angles(1:L-1,iParamMtx) = zeros(L-1,1);
            this.mus(1,iParamMtx) = 1;
            P = setProjectionOfVector(P, -a-Vb*this.x3);
            this.angles(:,iParamMtx) = this.angles(:,iParamMtx) + getAngles(P);
            Va = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            this.paramMtx{iParamMtx} = Va;
            
            % Check TVM
            vx1 = a;
            vx2 = Va*a;
            vx3 = Va*Vb*this.x3;
            this.ckTvm = norm( vx1 + vx2 + vx3 )/sqrt(L);
        end
        
        function value = getBarX3Vertical_(this)
            
            I = getMatrixI_(this);
            Z = getMatrixZ_(this);
            E0 = this.matrixE0;
            %
            L = this.nHalfDecs;
            M = 2*L;
            My = this.decY;
            phi = pi * this.angleVm /180.0;
            %
            dy = -mod(0:M-1,My).';
            dx = -floor((0:M-1)/My).';
            by = 2/sqrt(M)*[Z I]*double(E0)*dy;
            bx = 2/sqrt(M)*[Z I]*double(E0)*dx;
            bphiy = (1/sqrt(M))*(by + bx*cot(phi));
            a = zeros(L,1);
            a(1) = 1;
            
            % u0
            u0 = bphiy;
            iParamMtx = 2; % U0
            for iFree=1:this.ordX+this.ordY-2
                U = this.paramMtx{iParamMtx};
                u0 = U * u0;
                iParamMtx = iParamMtx + 1;
            end
            
            % u1
            u1 = zeros(L,1);
            if this.ordY > 2
                u1 = a;
                iParamMtx = this.ordX+3; % ny=1
                for iFree=1:this.ordY-3
                    U = this.paramMtx{iParamMtx};
                    u1 = U * u1 + a;
                    iParamMtx = iParamMtx + 1;
                end
            end
            
            % u2
            u2 = zeros(L,1);
            if this.ordX > 0
                v = a;
                iParamMtx = 3; %nx=1
                for iFree=1:this.ordX-1
                    U = this.paramMtx{iParamMtx};
                    v = U * v + a;
                    iParamMtx = iParamMtx + 1;
                end
                u2 = v;
                iParamMtx = this.ordX+2; % nx=Nx
                for iFree=1:this.ordY-2
                    U = this.paramMtx{iParamMtx};
                    u2 = U * u2;
                    iParamMtx = iParamMtx + 1;
                end
                u2 = cot(phi) * u2;
            end
            
            % \bar{x}_3
            value = u0 + u1 + u2;
            
        end
        
    end
    
    methods (Access = protected, Static = true)
        function value = getDefaultOrd_()
            value = [2 2];
        end
    end
    
end
