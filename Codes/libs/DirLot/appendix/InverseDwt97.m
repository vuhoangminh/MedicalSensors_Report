classdef InverseDwt97
    %INVERSEDWT97 2-D inverse 9/7 DWT
    %
    % SVN identifier:
    % $Id: InverseDwt97.m 184 2011-08-17 14:13:14Z sho $
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
        a = -1.586134342059924;
        b = -0.052980118572961;
        g =  0.882911075530934;
        d =  0.443506852043971;
        K =  1.230174104914001;
        coefs;
        resImg;
        nLevels;
    end
    
    methods
        
        function this = InverseDwt97(varargin)
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
                tmp = inverseDwt97_(this,subCoefs);
                iSubband = iSubband+3;
            end
            this.resImg = tmp;
        end
            
        function value = getImg(this)
            value = this.resImg;
        end
        
    end
    
    methods
        
        function value = inverseDwt97_(this,subCoefs)
            subCoefsSize = size(subCoefs{1});
            value = zeros(subCoefsSize(1)*2,subCoefsSize(2)*2);
            value(1:2:end,1:2:end) = subCoefs{1};
            value(1:2:end,2:2:end) = subCoefs{2};
            value(2:2:end,1:2:end) = subCoefs{3};
            value(2:2:end,2:2:end) = subCoefs{4};
            % Horizontal transform
            value(:,1:2:end) = value(:,1:2:end)*this.K;
            value(:,2:2:end) = value(:,2:2:end)/this.K;
            value = InverseDwt97.updateStep_(value.',-this.d);
            value = InverseDwt97.predictionStep_(value,-this.g);
            value = InverseDwt97.updateStep_(value,-this.b);
            value = InverseDwt97.predictionStep_(value,-this.a).';
            % Vertical transform
            value(1:2:end,:) = value(1:2:end,:)*this.K;
            value(2:2:end,:) = value(2:2:end,:)/this.K;
            value = InverseDwt97.updateStep_(value,-this.d);
            value = InverseDwt97.predictionStep_(value,-this.g);
            value = InverseDwt97.updateStep_(value,-this.b);
            value = InverseDwt97.predictionStep_(value,-this.a);
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