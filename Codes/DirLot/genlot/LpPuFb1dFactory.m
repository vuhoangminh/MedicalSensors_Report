classdef LpPuFb1dFactory
    %LPPUFB1DFACTORY Factory class of several 1-D LPPUFBs
    %
    % SVN identifier:
    % $Id: LpPuFb1dFactory.m 249 2011-11-27 01:55:42Z sho $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2010-2011, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    methods (Static = true)
        
        function value = createLpPuFb1d(vm,varargin)
            if nargin == 0
                vm = 0;
            end
            if nargin == 1 && isa(vm,'AbstLpPuFb1d')
                value = eval(sprintf('%s(vm);',class(vm)));
            else
                if vm == 0
                    value = LpPuFb1dVm0(varargin{:});
                elseif vm == 1
                    value = LpPuFb1dVm1(varargin{:});
                elseif vm == 2
                    value = LpPuFb1dVm2(varargin{:});
                else
                    id = 'GenLOT:IllegalArgumentException';
                    msg = 'Unsupported type of vanishing moments';
                    me = MException(id, msg);
                    throw(me);
                end
            end
        end
        
    end
    
end

