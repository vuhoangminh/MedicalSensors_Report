classdef LpPuFb2dDesignerFr < AbstDirLotDesigner
    %LPPUFB2DDESIGNERFR Design class of 2-D LPPUFB with frequency specifications
    %
    % SVN identifier:
    % $Id: LpPuFb2dDesignerFr.m 184 2011-08-17 14:13:14Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit-2.0-beta1
    %
    % Copyright (c) 2009-2010, Shogo MURAMATSU
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
        function this = LpPuFb2dDesignerFr(varargin)
            this = this@AbstDirLotDesigner(varargin{:});
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
            nPoints = 8*this.nDecs;
            spp = SubbandSpecification();
            psa = getPassStopAssignment(spp,nPoints,1);
            specBand{1} = psa;
            spec = PassBandErrorStopBandEnergy(specBand);
        end

    end
end