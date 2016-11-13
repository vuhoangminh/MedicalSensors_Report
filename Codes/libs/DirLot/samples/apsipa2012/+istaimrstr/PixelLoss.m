classdef PixelLoss < istaimrstr.AbstDegradationProcess
    %PIXELMISS
    %
    % SVN identifier:
    % $Id: PixelLoss.m 307 2012-03-11 15:08:48Z sho $
    %
    % Requirements: MATLAB R2011b
    %
    % Copyright (c) 2012, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %    
    properties (GetAccess = public, SetAccess = protected)
        losstype;
        density;
        mask;
        seed;
    end
    
    methods
        
        function this = PixelLoss(varargin)
            if ischar(varargin{1})
                this.losstype = varargin{1};
                this.density = varargin{2};
                if nargin < 3
                    this.seed = 0;
                else
                    this.seed = varargin{3};
                end
            else
                this.losstype = 'specified';
                this.mask = varargin{1};
                this.density = sum(this.mask(:))/numel(this.mask);
            end
        end
        
        function picture = linearprocess(this,picture)
            if isempty(this.mask)
                this = generatemask(this,size(picture));
            end
            picture(this.mask==0)=0;
        end
        
        function picture = reversalprocess(this,picture)
            picture = linearprocess(this,picture);
        end
        
        function this = generatemask(this,ndim)
            switch this.losstype
                case 'random'
                    rng(this.seed);
                    this.mask = rand(ndim) > this.density;
                otherwise
                    error('Invalid misstype.');
            end
        end
        
        function str = getString(this)
            str = sprintf('pls_%s_d%3.1f_sd%d',this.losstype,...
                this.density,this.seed);
        end
        
        function outputdim = getDimension(this,inputdim)
            outputdim = inputdim;
        end
        
        function [y,s] = typicalReference(this,varargin)
            x = varargin{1};
            y = medfilt2(x);
            s = 'median';
        end
        
        function dimu = getDimU(this,nDim)
            dimu = nDim;
        end
        
            
        function obj = clone(this)
          obj = imrstr.PixelLoss(this.losstype,this.density,this.seed);
          obj = setMask_(obj,this.mask);
        end
    end
    
    methods (Access = private)
        function obj = setMask_(obj,mask_)
          obj.mask = mask_;
        end
    end 
   
end

