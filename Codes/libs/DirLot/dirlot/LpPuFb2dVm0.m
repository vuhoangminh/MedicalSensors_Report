classdef LpPuFb2dVm0 < AbstLpPuFb2d
    %LPPUFB2DVM0 2-D LPPUFB without any vanishing moment
    %   This class generates a 2-D LPPUFB by a set of
    %   controling parameters.
    %
    % SVN identifier:
    % $Id: LpPuFb2dVm0.m 184 2011-08-17 14:13:14Z sho $
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
    methods
        
        function this = LpPuFb2dVm0(varargin)
            this = this@AbstLpPuFb2d(varargin{:});
            this = update_(this);
            this.isInitialized = true;
        end
    end
    
    methods (Access = protected, Static = true)
        function value = getDefaultOrd_()
            value = [0 0];
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
