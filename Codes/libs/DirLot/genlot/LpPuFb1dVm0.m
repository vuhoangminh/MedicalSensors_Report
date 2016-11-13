classdef LpPuFb1dVm0 < AbstLpPuFb1d
    %LPPUFB1DVM0 2-D LPPUFB without any vanishing moment
    %   This class generates a 1-D LPPUFB by a set of
    %   controling parameters.
    %
    % SVN identifier:
    % $Id: LpPuFb1dVm0.m 249 2011-11-27 01:55:42Z sho $
    %
    % Requirements: MATLAB R2008a
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
    methods
        
        function this = LpPuFb1dVm0(varargin)
            this = this@AbstLpPuFb1d(varargin{:});
            this = update_(this);
            this.isInitialized = true;
        end
        
    end
    
    methods (Access = protected, Static = true)
        function value = getDefaultOrd_()
            value = 0;
        end
    end
    
    methods (Access = protected)

        function this = update_(this)
            for iParamMtx = 1:this.nStages+1
                this.paramMtx{iParamMtx} = double(...
                    GivensRotations(this.angles(:,iParamMtx),...
                    this.mus(:,iParamMtx)));
            end
        end

    end
end