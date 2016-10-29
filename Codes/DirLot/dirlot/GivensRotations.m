classdef GivensRotations < handle
    %GIVENSROTATIONS Givens rotations
    %
    % SVN identifier:
    % $Id: GivensRotations.m 184 2011-08-17 14:13:14Z sho $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2008, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties (SetAccess = private, GetAccess = private)
        angles;
        mus;
        nSize;
        %eyemtx;
    end
    
    methods
        function this = GivensRotations(angles,mus)
            if nargin < 1
                this.nSize = 2;
                this.angles = 0;
                this.mus = ones(this.nSize,1);
            else
                this.angles = angles;
                this.nSize = (1+sqrt(1+8*length(this.angles)))/2;
                if nargin < 2
                    this.mus = ones(this.nSize,1);
                else
                    this.mus = mus;
                end
            end
            %this.eyemtx = eye(this.nSize);
        end
        
        function value = double(this)
            if (isempty(this.angles) || this.nSize == 1 )
                value = diag(this.mus);
            else
                value = eye(this.nSize);
                iAng = 1;
                for iTop=1:this.nSize-1
                    vt = value(iTop,:);
                    for iBtm=iTop+1:this.nSize
                        angle = this.angles(iAng);
                        c = cos(angle); %
                        s = sin(angle); %
                        %
                        vb = value(iBtm,:);
                        u1 = c*vt - s*vb;
                        value(iBtm,:) = s*vt + c*vb;
                        vt = u1;
                        %
                        iAng = iAng + 1;
                    end
                    value(iTop,:) = vt;
                end
                value = diag(this.mus)*value;
            end
        end
        
        function value = char(this)
            value = [];
            g = double(this);
            for iRow = 1:this.nSize
                for iCol = 1:this.nSize
                    value = [value 9 num2str(g(iRow,iCol),'%+8.5f')];
                end
                value = [value 10];
            end
        end
        
        function disp(this)
            disp(['[' 10 char(this) ']' 10]);
        end
        
        function this = setMus(this,mus)
            if length(mus) ~= this.nSize
                id = 'Dir2dDwt:IllegalArgumentException';
                msg = sprintf(...
                    '%d: Length of mus must be %d', this.nSize);
                me = MException(id, msg);
                throw(me);
            else
                this.mus = mus;
            end
        end
        
        function this = setAngles(this,angles)
            this.angles = angles;
        end
        
        function value = getAngles(this)
            value = this.angles;
        end
        
        function value = getMus(this)
            value = this.mus;
        end
        
        function this = setMatrix(this,matrix)
            T = matrix.';
            this.nSize = size(T,2);
            iAng = 1;
            this.angles = zeros(this.nSize*(this.nSize-1)/2,1);
            this.mus = ones(this.nSize,1);
            for iCol = 1:this.nSize-1
                v = T(iCol:end,iCol);
                for idx = 2:length(v)
                    x = [ v(1) ; v(idx) ];
                    [G,y] = planerot(x);
                    this.angles(iAng) = atan2(G(2,1),G(1,1));
                    v(1) = y(1);
                    v(idx) = y(2);
                    R = eye(this.nSize);
                    iRow = iCol+idx-1;
                    R(iCol,iCol) = G(1,1);
                    R(iRow,iCol) = G(2,1);
                    R(iCol,iRow) = G(1,2);
                    R(iRow,iRow) = G(2,2);
                    T = R*T;
                    iAng = iAng + 1;
                end
            end
            this.mus = diag(T);
            %this.eyemtx = eye(this.nSize);
        end
        
        function this = setProjectionOfVector(this,v)
            this.nSize = length(v);
            P = eye(this.nSize);
            this.angles = zeros(this.nSize*(this.nSize-1)/2,1);
            this.mus = ones(this.nSize,1);
            iAng = 1;
            for idx = 2:length(v)
                x = [ v(1) ; v(idx) ];
                [G,y] = planerot(x);
                this.angles(iAng) = atan2(G(2,1),G(1,1));
                v(1) = y(1);
                v(idx) = y(2);
                R = eye(this.nSize);
                iRow = idx;
                R(1,1) = G(1,1);
                R(iRow,1) = G(2,1);
                R(1,iRow) = G(1,2);
                R(iRow,iRow) = G(2,2);
                P = R*P;
                iAng = iAng + 1;
            end
            %this.eyemtx = eye(this.nSize);
        end
    end
end
