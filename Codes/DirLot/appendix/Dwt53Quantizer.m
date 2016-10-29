classdef Dwt53Quantizer
    %DWT53QUANTIZER ECSQ with 5/3 DWT
    %
    % SVN identifier:
    % $Id: Dwt53Quantizer.m 184 2011-08-17 14:13:14Z sho $
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
        fdwt;
        idwt;
        ecsQdq;
        aveRate;
        orgImg;
        subCoefs;
        dqsubCoefs;
        resImg;
    end
    
    methods
        
        function this = Dwt53Quantizer(varargin)
            this.aveRate = varargin{1};
        end
        
        function this = dwt53Quantize(this,srcImg,nLevels)
            this.orgImg = srcImg;
            % Forward Transform
            this.fdwt = ForwardDwt53(this.orgImg,nLevels);
            this.fdwt = forwardtransform(this.fdwt);
            this.subCoefs = getCoefs(this.fdwt);
            % Quantization
            this.ecsQdq = ...
                EcsQuantizerDeQuantizer(this.subCoefs,'dwt53');
            this.dqsubCoefs = ...
                getDeQuantizedCoefs(this.ecsQdq,this.aveRate);
            % Inverse Transform
            this.idwt = InverseDwt53(this.dqsubCoefs);
            this.idwt = inversetransform(this.idwt);
            this.resImg = getImg(this.idwt);
        end
        
        function value = getCoefs(this)
            value = this.subCoefs;
        end
        
        function value = getDqCoefs(this)
            value = this.dqsubCoefs;
        end
        
        function value = getImg(this)
            value = this.resImg;
        end
        
        function value = getPsnr(this)
            value = Psnr_(this);
        end
        
    end
    
    methods ( Access = private )
        
        function value = Psnr_(this)
            % PSNR
            orgimg = im2uint8(this.orgImg);
            resimg = im2uint8(this.resImg);
            value = 10*log10(255.0^2*numel(orgimg) ...
                /sum((int16(orgimg(:))-int16(resimg(:))).^2));
        end
        
    end
    
end