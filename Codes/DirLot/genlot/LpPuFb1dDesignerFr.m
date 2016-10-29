classdef LpPuFb1dDesignerFr < AbstGenLotDesigner
    %LPPUFB1DDESIGNERFR Design class of 1-D LPPUFB with frequency specifications
    %
    % SVN identifier:
    % $Id: LpPuFb1dDesignerFr.m 249 2011-11-27 01:55:42Z sho $
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
        nSpecs;
    end
    
    methods
        function this = LpPuFb1dDesignerFr(varargin)
            this = this@AbstGenLotDesigner(varargin{:});
            if nargin < 3
                this.spec = defaultSpec_(this);
            else
                this.spec = varargin{3};
            end
            this.nSpecs = getNumberOfSpecs(this.spec);
        end
        
        function value = getCost(this,lppufb_)
            if nargin > 1
                value = getCost(this.spec,lppufb_);
            else
                value = getCost(this.spec,this.lppufb);
            end
        end

    end
    
    methods (Access = private)
        
        function spec = defaultSpec_(this)
            nPoints = 8*this.nDec;
            spp = SubbandSpecification1d();
            psa = getPassStopAssignment(spp,nPoints,1);
            specBand{1} = psa;
            spec = PassBandErrorStopBandEnergy1d(specBand);
        end

    end
end