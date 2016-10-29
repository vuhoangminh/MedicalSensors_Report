classdef ForwardDwt53
    %FORWARDDWT53 2-D forward 5/3 DWT
    %
    % SVN identifier:
    % $Id: ForwardDwt53.m 184 2011-08-17 14:13:14Z sho $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2008-2009, Shogo MURAMATSU, Tomoya KOBAYASHI
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties ( GetAccess = private, SetAccess = private )
        a = -1/2;
        b = 1/4;
        srcImg;
        nLevels;
        subbandCoefs
        nDecs;
    end
    
    methods
        
        function this = ForwardDwt53(varargin)
            this.srcImg = varargin{1};
            if nargin < 2
                this.nLevels = 1;
                this.nDecs = 4;
            else
                this.nLevels = varargin{2};
                this.nDecs = this.nLevels*3+1;
            end
        end
        
        function this = forwardtransform(this)
            this.subbandCoefs = cell(this.nDecs,1);
            tmp{1} = this.srcImg;
            for idx = 3*(this.nLevels-1)+1:-3:1
                tmp = forwardDwt53_(this,tmp{1});
                this.subbandCoefs{idx} = tmp{1};
                this.subbandCoefs{idx+1} = tmp{2};
                this.subbandCoefs{idx+2} = tmp{3};
                this.subbandCoefs{idx+3} = tmp{4};
            end
        end
        
        function value = getCoefs(this)
            value = this.subbandCoefs;
        end
        
    end
    
    methods
        
        function value = forwardDwt53_(this,srcImg)
            % Vertical transform
            coef = ForwardDwt53.predictionStep_(srcImg,this.a);
            coef = ForwardDwt53.updateStep_(coef,this.b);
            
            % Horizontal transform
            coef = ForwardDwt53.predictionStep_(coef.',this.a);
            coef = ForwardDwt53.updateStep_(coef,this.b).';
            
            value = cell(4,1);
            value{1} = coef(1:2:end,1:2:end);
            value{2} = coef(1:2:end,2:2:end);
            value{3} = coef(2:2:end,1:2:end);
            value{4} = coef(2:2:end,2:2:end);
        end
        
    end
    
    methods (Access = private, Static = true)
        
        function value = updateStep_(value,u)
            value(1:2:end,:) = imlincomb(...
                u, [value(2,:); value(2:2:end-1,:)], ...
                1, value(1:2:end,:), ...
                u, value(2:2:end,:) ...
                );
        end
        
        function value = predictionStep_(value,p)
            value(2:2:end,:) = imlincomb(...
                p, value(1:2:end,:), ...
                1, value(2:2:end,:), ...
                p, [value(3:2:end,:); value(end-1,:)] ...
                );
        end
        
    end
    
end