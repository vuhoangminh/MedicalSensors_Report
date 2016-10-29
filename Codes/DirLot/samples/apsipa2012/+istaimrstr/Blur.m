classdef Blur < istaimrstr.AbstDegradationProcess
    %BLUR 
    %
    % SVN identifier:
    % $Id: Blur.m 303 2012-03-11 01:39:03Z sho $
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
        blurkernel;
        blurtype;
        sigma;
    end
    
    methods
        
        function this = Blur(varargin)
            if ischar(varargin{1})
                this.blurtype = varargin{1};
                switch this.blurtype
                    case 'gaussian'
                        this.sigma = varargin{2};
                        this.blurkernel = ...
                            fspecial('gaussian',2*round(4*this.sigma)+1,...
                            this.sigma);
                    case 'identical'
                        this.blurkernel = 1;
                    otherwise
                        error('Invalid blur type');
                end
            else
                this.blurkernel = varargin{1};
            end
        end
        
        function output = linearprocess(this,input)
            output = imfilter(input,this.blurkernel,'conv');
        end
        
        function output = reversalprocess(this,input)
            output = imfilter(input,this.blurkernel,'corr');
        end
        
        function str = getString(this)
            switch this.blurtype
                case 'identical'
                    str = 'identical';
                otherwise
                    str = sprintf('blr_%s_s%3.1f',this.blurtype,this.sigma);
            end
        end
        
        function outputdim = getDimension(this,inputdim)
            outputdim = inputdim;
        end
        
        function psf = getPsf(this)
            psf = this.blurkernel;
        end
        
        function [y,s] = typicalReference(this,varargin)
            x = varargin{1};
            estimated_nsr = varargin{2};
            y = deconvwnr(x, this.blurkernel, estimated_nsr);
            s = 'wiener';
        end
        
        function dimu = getDimU(this,nDim)
            dimu = nDim;
        end
    
        function obj = clone(this)
            obj = imrstr.Blur(this.blurtype,this.sigma);   
        end
    end 

    
end