classdef CodingGain < handle
    %CODINGGAIN Coding gain
    %
    % SVN identifier:
    % $Id: CodingGain.m 184 2011-08-17 14:13:14Z sho $
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
    properties  (GetAccess = private, SetAccess = private)
        rho = 0.95;
        omega = 1.0;
        theta = 0.0;
        nTaps = [ 2 2 ];
        wMtx;
        rMtx;
        Lxx;
        Rxx;
    end
    
    methods
        function this = CodingGain(varargin)
            if nargin > 0 && ~isempty(varargin{1})
                this.nTaps = varargin{1};
            end
            
            if nargin > 1 && ~isempty(varargin{2})
                this.rho = varargin{2};
            end
            
            if nargin > 2 && ~isempty(varargin{3})
                this.omega = varargin{3};
            end
            
            if nargin > 3 && ~isempty(varargin{4})
                this.theta = varargin{4};
            end
            
            this.wMtx = diag([1/this.omega this.omega]);
            this.rMtx = [
                cos(this.theta) -sin(this.theta) ;
                sin(this.theta) cos(this.theta) ];
            this.Rxx = getCorrelationMatrix(this);
            %this.Lxx = chol(Rxx,'lower');
        end
        
        function value = getCorrelationMatrix(this)
            nTapsY = this.nTaps(1);
            nTapsX = this.nTaps(2);
            coefs = zeros(this.nTaps);
            for iRow=1:nTapsY
                for iCol=1:nTapsX
                    coefs(iRow,iCol) = this.rho^(...
                        distance(this,iRow-1,iCol-1));
                end
            end
            coefVecs = coefs(:);
            value = [];
            for iBlk=1:nTapsY
                subCorMtx = [];
                for jBlk=1:nTapsY
                    if iBlk<jBlk
                        k = rem(jBlk-iBlk,nTapsY);
                    else
                        k = rem(iBlk-jBlk,nTapsY);
                    end
                    subCorMtx = [subCorMtx ;
                        toeplitz(coefVecs(k*nTapsX+1:(k+1)*nTapsX))];
                end
                value = [ value subCorMtx ];
            end
        end
        
        function value = getCost(this,obj)
            if isa(obj,'LpPuFb2d') || isa(obj,'AbstLpPuFb2d')
                nBands = prod(getDec(obj));
                P = zeros(nBands,numel(obj(1)));
                for iBand=1:nBands
                    filter = obj(iBand);
                    P(iBand,:) = filter(:).';
                end
            elseif (isnumeric(obj))
                nBands = size(obj,1);
                P = obj;
            else
                nBands = length(obj);
                P = zeros(nBands,numel(obj{1}));
                for iBand=1:nBands
                    filter = obj{iBand};
                    P(iBand,:) = filter(:).';
                end
            end
            %Lyy = P*this.Lxx;
            %Ryy = Lyy * Lyy.';
            Ryy = P*this.Rxx*P.';
            value = -10*log10(...
                (1/nBands*trace(Ryy))/(prod(diag(Ryy))^(1/nBands)));
        end
        
        function value = getCorrelationMap(this)
            nRows = 128;
            nCols = 128;
            value = zeros(nRows,nCols);
            for iRow = 1:nRows
                for iCol = 1:nCols
                    value(iRow,iCol) = this.rho^(...
                        distance(this,(iRow-nRows/2),(iCol-nCols/2)));
                end
            end
        end
        
    end
    
    methods(Access=private)
        function value = distance(this,y,x)
            value = norm(this.wMtx * this.rMtx * [ y x ].');
        end
    end
    
end
