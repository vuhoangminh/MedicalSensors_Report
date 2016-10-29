classdef LpPuFb2dFactory
    %LPPUFB2DFACTORY Factory class of several 2-D LPPUFBs
    %
    % SVN identifier:
    % $Id: LpPuFb2dFactory.m 184 2011-08-17 14:13:14Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit-2.0-beta1
    %
    % Copyright (c) 2010, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    
    methods (Static = true)
        
        function value = createLpPuFb2d(vm,varargin)
            if nargin == 0
                vm = 0;
            end
            if nargin == 1 && isa(vm,'AbstLpPuFb2d')
                value = eval(sprintf('%s(vm);',class(vm)));
            else
                if vm == 0
                    value = LpPuFb2dVm0(varargin{:});
                elseif vm == 1
                    value = LpPuFb2dVm1(varargin{:});
                elseif vm == 2
                    value = LpPuFb2dVm2(varargin{:});
                elseif ischar(vm) && vm(1)=='d'
                    phi = sscanf(vm,'d%f');
                    value = LpPuFb2dTvm(phi,varargin{:});
                else
                    id = 'DirLOT:IllegalArgumentException';
                    msg = 'Unsupported type of vanishing moments';
                    me = MException(id, msg);
                    throw(me);
                end
            end
        end
        
    end
    
end

