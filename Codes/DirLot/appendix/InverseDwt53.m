classdef InverseDwt53
    %INVERSEDWT53 2-D inverse 5/3 DWT
    %
    % SVN identifier:
    % $Id: InverseDwt53.m 184 2011-08-17 14:13:14Z sho $
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
        coefs;
        resImg;
        nLevels;
    end
    
    methods
        
        function this = InverseDwt53(varargin)
            this.coefs = varargin{1};
            this.nLevels = (length(this.coefs)-1)/3;
        end
        
        function this = inversetransform(this)
            subCoefs = cell(4,1);
            tmp = this.coefs{1};
            iSubband = 2;
            for iLevel = 1:this.nLevels
                subCoefs{1} = tmp;
                subCoefs{2} = this.coefs{iSubband};
                subCoefs{3} = this.coefs{iSubband+1};
                subCoefs{4} = this.coefs{iSubband+2};
                tmp = inverseDwt53_(this,subCoefs);
                iSubband = iSubband+3;
            end
            this.resImg = tmp;
        end
        
        function value = getImg(this)
            value = this.resImg;
        end
        
    end
    
    methods
        
        function value = inverseDwt53_(this,subCoefs)
            subCoefsSize = size(subCoefs{1});
            value = zeros(subCoefsSize(1)*2,subCoefsSize(2)*2);
            value(1:2:end,1:2:end) = subCoefs{1};
            value(1:2:end,2:2:end) = subCoefs{2};
            value(2:2:end,1:2:end) = subCoefs{3};
            value(2:2:end,2:2:end) = subCoefs{4};
            % Horizontal transform
            value = InverseDwt53.updateStep_(value,-this.b);
            value = InverseDwt53.predictionStep_(value,-this.a).';
            % Vertical transform
            value = InverseDwt53.updateStep_(value,-this.b);
            value = InverseDwt53.predictionStep_(value,-this.a).';
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