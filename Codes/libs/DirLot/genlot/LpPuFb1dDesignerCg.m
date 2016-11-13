classdef LpPuFb1dDesignerCg < AbstGenLotDesigner
    %LPPUFB1DDESIGNERCG Design class of 1-D LPPUFB for maximizing coding gain
    %
    % SVN identifier:
    % $Id: LpPuFb1dDesignerCg.m 249 2011-11-27 01:55:42Z sho $
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
    properties (GetAccess = private, SetAccess = private)
        %spec;
        nTaps;
        %filters;
    end
    
    methods
        
        function this = LpPuFb1dDesignerCg(varargin)
            this = this@AbstGenLotDesigner(varargin{:});
            this.nTaps = this.nDec .* (this.nOrd+1);
            if nargin < 3
                this.spec = defaultSpec_(this);
            else
                this.spec = varargin{3};
            end
        end

        %TODO: to be tested
        function value = getCost(this,lppufb_) 
            if nargin < 2
                lppufb_ = this.lppufb;
            end
            filters_ = zeros(this.nDec,this.nTaps);
            for iBand = 1:this.nDec
                filter = lppufb_(iBand);
                filters_(iBand,:) = filter(:).';
            end
            value = getCost(this.spec,filters_);
        end

    end
    
    methods (Access = private)
        
        function spec = defaultSpec_(this)
            rho = 0.95;
            spec = CodingGain1d(this.nTaps,rho);
        end
        
    end
end