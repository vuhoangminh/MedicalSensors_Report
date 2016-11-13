classdef Decimation < istaimrstr.AbstDegradationProcess
    %DECIMATION
    %   
    % SVN identifier:
    % $Id: Decimation.m 303 2012-03-11 01:39:03Z sho $
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
        dfactor;
        blurtype;
        blurkernel;
        offset;
    end
    
    methods
        
        function this = Decimation(varargin)
            this.dfactor = varargin{1};
            this.blurtype = varargin{2};
            if ischar(this.blurtype)
                switch this.blurtype
                    case {'identical'}
                        this.blurkernel = 1;
                    case {'average','box'}
                        this.blurkernel = fspecial('average',this.dfactor);
                    case {'gaussian_wide'}
                        width = 4*this.dfactor+1;
                        sigma = this.dfactor;
                        this.blurkernel = fspecial('gaussian',width,sigma);
                    case {'gaussian'}
                        width = 4*this.dfactor+1;
                        sigma = (this.dfactor/pi)*sqrt(2*log(2));
                        this.blurkernel = fspecial('gaussian',width,sigma);                        
                    otherwise
                        error('Invalid blur type');
                end
            else
                this.blurkernel = this.blurtype;
            end
            this.offset = mod(size(this.blurkernel)+1,2);
        end
        
        function output = linearprocess(this,input)
            v = imfilter(input,this.blurkernel,'conv'); % Bluring with zero padding
            output = downsample(downsample(v,this.dfactor).',...
                this.dfactor).'; % Downsampling
        end
        
        function output = reversalprocess(this,input)
            v = upsample(upsample(input,this.dfactor,this.offset(1)).',...
                this.dfactor,this.offset(2)).'; % Upsampling
            output = imfilter(v,this.blurkernel,'corr'); %  Back bluring with zero padding
        end
        
        function str = getString(this)
            str = sprintf('dec_%s_d%d',this.blurtype,this.dfactor);
        end
        
        function outputdim = getDimension(this,inputdim)
            outputdim = this.dfactor*inputdim;
        end
        
        function [y,s] = typicalReference(this,varargin)
            x = varargin{1};
            y = imresize(x,this.dfactor,'bicubic');
            s = 'bicubic';
        end
        
        function dimu = getDimU(this,nDim)
            dimu = this.dfactor*nDim;
        end

        function obj = clone(this)
              obj = imrstr.Decimation(this.dfactor,this.blurtype);
        end
    end 

    
end

