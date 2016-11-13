classdef CodingGain1d < handle
    %CODINGGAIN1D 1-D Coding gain
    %
    % SVN identifier:
    % $Id: CodingGain1d.m 237 2011-11-15 00:20:02Z sho $
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
        nTaps = 4;
        Rxx;
    end
    
    methods
        function this = CodingGain1d(varargin)
            
            
            if nargin > 0 && ~isempty(varargin{1})
                this.nTaps = varargin{1};
            end
            
            if nargin > 1 && ~isempty(varargin{2})
                this.rho = varargin{2};
            end
            this.Rxx = getCorrelationMatrix(this);
        end
        
        function value = getCorrelationMatrix(this)
            coefs = zeros(this.nTaps,1);
            for dist=1:this.nTaps
                coefs(dist) = this.rho^(dist-1);
            end
            value = toeplitz(coefs);
        end
        
        function value = getCost(this,obj)
            if isa(obj,'AbstLpPuFb1d')
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
            Ryy = P*this.Rxx*P.';
            value = -10*log10(...
                (1/nBands*trace(Ryy))/(prod(diag(Ryy))^(1/nBands)));
        end
        
    end
    
end
