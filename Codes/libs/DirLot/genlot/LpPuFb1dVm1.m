classdef LpPuFb1dVm1 < AbstLpPuFb1d
    %LPPUFB1DVM1 1-D LPPUFB with 1-order vanishing moments
    %   This class generates a 1-D LPPUFB by a set of
    %   controling parameters.
    %
    % SVN identifier:
    % $Id: LpPuFb1dVm1.m 249 2011-11-27 01:55:42Z sho $
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
        function this = LpPuFb1dVm1(varargin)
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

            this.angles(1:this.nHalfDec-1,1) = ...
                zeros(this.nHalfDec-1,1);
            this.mus(1,1) = 1;
            
            for iParamMtx = 1:this.nStages+1
                this.paramMtx{iParamMtx} = double(...
                    GivensRotations(this.angles(:,iParamMtx),...
                    this.mus(:,iParamMtx)));
            end
        end
        
    end
end


