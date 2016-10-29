classdef LpPuFb2dDesignerCg < AbstDirLotDesigner
    %LPPUFB2DDESIGNERCG Design class of 2-D LPPUFB for maximizing coding gain
    %
    % SVN identifier:
    % $Id: LpPuFb2dDesignerCg.m 184 2011-08-17 14:13:14Z sho $
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
    properties (GetAccess = private, SetAccess = private)
        %spec;
        nTaps;
        nBands;
        %filters;
    end
    
    methods
        
        function this = LpPuFb2dDesignerCg(varargin)
            this = this@AbstDirLotDesigner(varargin{:});
            this.nTaps = this.nDecs .* (this.nOrds+1);
            this.nBands = prod(this.nDecs);
            if nargin < 3
                this.spec = defaultSpec_(this);
            else
                this.spec = varargin{3};
            end
            %this.filters = zeros(this.nBands, prod(this.nTaps));
        end

        %TODO: to be tested
        function value = getCost(this,lppufb_) 
            if nargin < 2
                lppufb_ = this.lppufb;
            end
            filters_ = zeros(this.nBands,prod(this.nTaps));
            for iBand = 1:this.nBands
                filter = lppufb_(iBand);
                filters_(iBand,:) = filter(:).';
            end
            value = getCost(this.spec,filters_);
        end

    end
    
    methods (Access = private)
        
        function spec = defaultSpec_(this)
            rho = 0.95;
            omega = 1.0;
            theta = 0.0;
            spec = CodingGain(this.nTaps,rho,omega,theta);
        end
        
    end
end