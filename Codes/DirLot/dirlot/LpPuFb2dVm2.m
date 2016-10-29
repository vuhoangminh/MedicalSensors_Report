classdef LpPuFb2dVm2 < AbstLpPuFb2d
    %LPPUFB2DVM2 2-D LPPUFB with 2-order classical vanishing moments
    %   This class generates a 2-D LPPUFB by a set of
    %   controling parameters.
    %
    % SVN identifier:
    % $Id: LpPuFb2dVm2.m 184 2011-08-17 14:13:14Z sho $
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
    properties (GetAccess = public, SetAccess = public)
        sx;
        sy;
    end
    
    properties (GetAccess = private, SetAccess = private)
        x3x;
        x3y;
        lenx3x;
        lenx3y;
        lambdaxueq;
        lambdayueq;
        ckVm2;
    end
    
    methods
        
        function this = LpPuFb2dVm2(varargin)
            this = this@AbstLpPuFb2d(varargin{:});
            
            if this.ordX < 2 || this.ordY < 2
                id = 'DirLOT:IllegalArgumentException';
                msg = 'Order must be greater than or equal to [ 2 2 ]';
                me = MException(id, msg);
                throw(me);
            end
            
            if nargin < 5
                sd = [1 -1];
            else
                sd = varargin{5};
                if isscalar(sd)
                    sd = sd * [1 1];
                end
            end
            this = setSigns4Lambda(this,sd);
            this = update_(this);
            this.isInitialized = true;
        end
        
        function this = setSigns4Lambda(this,sd)
            if isscalar(sd)
                this.sy = sd;
                this.sx = sd;
            else
                this.sy = sd(Direction.VERTICAL);
                this.sx = sd(Direction.HORIZONTAL);
            end
            if this.isInitialized
                this = update_(this);
            end
        end
        
        function value = getLengthX3x(this)
            value = this.lenx3x;
        end
        
        function value = getLengthX3y(this)
            value = this.lenx3y;
        end
        
        function value = getLambdaXueq(this)
            value = this.lambdaxueq;
        end
        
        function value = getLambdaYueq(this)
            value = this.lambdayueq;
        end
        
        function value = checkVm2(this)
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
        end
        
    end
    
    methods (Access = protected)
        
        function this = update_(this)
            
            this.angles(1:this.nHalfDecs-1,1) = ...
                zeros(this.nHalfDecs-1,1);
            this.mus(1,1) = 1;
            
            I = getMatrixI_(this);
            Z = getMatrixZ_(this);
            E0 = this.matrixE0;
            
            L = this.nHalfDecs;
            M = 2*L;
            My = this.decY;
            Mx = this.decX;
            
            dy = -mod(0:M-1,My).';
            dx = -floor((0:M-1)/My).';
            by = 2/(My*sqrt(M))*[Z I]*E0*dy;
            bx = 2/(Mx*sqrt(M))*[Z I]*E0*dx;
            a = zeros(L,1);
            a(1) = 1;
            cx = I;
            Uc = I;
            vx = bx;
            vy = by;
            
            % W
            W = double(GivensRotations(this.angles(:,1),this.mus(:,1)));
            this.paramMtx{1} = W;
            iParamMtx = 2;
            
            nFreeX = this.ordX-2;
            for iFree=1:nFreeX
                U = double(GivensRotations(this.angles(:,iParamMtx),...
                    this.mus(:,iParamMtx)));
                this.paramMtx{iParamMtx} = U;
                iParamMtx = iParamMtx + 1;
                Uc = U * Uc;
                cx = [ I U * cx ];
                vx = [ a ; vx ]; %#ok<AGROW>
            end
            
            % Ux(Nx-2)
            this.x3x =  cx * vx;
            this.lenx3x = norm( this.x3x );
            lambdax1 = 2*real(asin(this.lenx3x/2));
            lambdax2 = real(acos(this.lenx3x/2));
            lambdax = lambdax1 + lambdax2;
            
            % to be revised
            %this.lambdaxueq = abs(cos(lambdax))...
            %    - abs(prod(cos(this.angles(2:L-1,iParamMtx)))); % <= 0
            cc = cos(lambdax)/prod(cos(this.angles(2:L-1,iParamMtx)));
            this.lambdaxueq = abs(cc) - 1; % <= 0
            %
            %this.angles(1,iParamMtx) = this.sx*real(acos(cos(lambdax)/...
            %    prod(cos(this.angles(2:L-1,iParamMtx)))));
            this.angles(1,iParamMtx) = this.sx*real(acos(cc));
            this.mus(1,iParamMtx) = 1;
            %
            Ax = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            Px = GivensRotations();
            Px = setProjectionOfVector(Px,this.x3x);
            U = Ax*double(Px);
            this.paramMtx{iParamMtx} = U;
            iParamMtx = iParamMtx + 1;
            Uc = U * Uc;
            cx = [ I U * cx ];
            vx = [ a ; vx ];
            
            % Ux(Nx-1)
            % to be revised
            this.angles(1:L-1,iParamMtx) = zeros(L-1,1);
            this.mus(1,iParamMtx) = 1;
            Px = setProjectionOfVector(Px, -a-U*this.x3x);
            this.angles(:,iParamMtx) = this.angles(:,iParamMtx) + getAngles(Px);
            U = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            this.paramMtx{iParamMtx} = U;
            iParamMtx = iParamMtx + 1;
            Uc = U * Uc;
            cx = [ I U * cx ];
            cy = Uc;
            vx = [ a ; vx ];
            
            % UxNx ... Uy(Ny-3)
            nFreeY = this.ordY-2;
            for iFree=1:nFreeY
                U = double(GivensRotations(this.angles(:,iParamMtx),...
                    this.mus(:,iParamMtx)));
                this.paramMtx{iParamMtx} = U;
                iParamMtx = iParamMtx + 1;
                cy = [ I U * cy ];
                vy = [ a ; vy ]; %#ok<AGROW>
            end
            
            % Uy(Ny-2) or UxNx
            this.x3y = cy * vy ;
            this.lenx3y = norm( this.x3y );
            lambday1 = 2*real(asin(this.lenx3y/2));
            lambday2 = real(acos(this.lenx3y/2));
            lambday = lambday1 + lambday2;
            
            % to be revised
            %this.lambdayueq = abs(cos(lambday))...
            %      -abs(prod(cos(this.angles(2:L-1,iParamMtx)))); % <= 0
            %
            cc = cos(lambday)/prod(cos(this.angles(2:L-1,iParamMtx)));
            this.lambdayueq =  abs(cc) - 1; % <= 0
            %this.angles(1,iParamMtx) = this.sy*real(acos(cos(lambday)/...
            %    prod(cos(this.angles(2:L-1,iParamMtx)))));
            this.angles(1,iParamMtx) = this.sy*real(acos(cc));
            this.mus(1,iParamMtx) = 1;
            %
            Ay = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            Py = GivensRotations();
            Py = setProjectionOfVector(Py, this.x3y);
            U = Ay*double(Py);
            this.paramMtx{iParamMtx} = U;
            iParamMtx = iParamMtx + 1;
            cy = [ I U * cy ];
            vy = [ a ; vy ];
            
            % Uy(Ny-1)
            % to be revised
            this.angles(1:L-1,iParamMtx) = zeros(L-1,1);
            this.mus(1,iParamMtx) = 1;
            Py = setProjectionOfVector(Py, -a-U*this.x3y);
            this.angles(:,iParamMtx) = this.angles(:,iParamMtx) + getAngles(Py);
            U = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            this.paramMtx{iParamMtx} = U;
            iParamMtx = iParamMtx + 1;
            cy = [ I U * cy ];
            vy = [ a ; vy ];
            
            % UyNy
            U = double(GivensRotations(this.angles(:,iParamMtx),...
                this.mus(:,iParamMtx)));
            this.paramMtx{iParamMtx} = U;
            
            %
            this.ckVm2(1) = norm( cy * vy )/sqrt(L);
            this.ckVm2(2) = norm( cx * vx )/sqrt(L);
            
        end
        
    end
    
    methods (Access = protected, Static = true)
        function value = getDefaultOrd_()
            value = [2 2];
        end
    end
    
end
