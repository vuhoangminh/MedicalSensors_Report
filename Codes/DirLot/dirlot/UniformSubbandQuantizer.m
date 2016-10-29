classdef UniformSubbandQuantizer < handle
    %UNIFORMSUBBANDQUANTIZER Uniform subband quantizer
    %
    % SVN identifier:
    % $Id: UniformSubbandQuantizer.m 316 2012-04-24 07:07:44Z harashin $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2008-2011, Shogo MURAMATSU, Tomoya KOBAYASHI
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties (GetAccess = private, SetAccess = private)
        decX;
        decY;
        paramMtx;
        lppufb;
        aveRate;
        dqSubbandCoefs;
        outputImg;
        orgImg;
        psnr;
        isPeriodicExt;
        isEquivalentOrder;
    end
    
    methods
        
        % constractor
        function this = UniformSubbandQuantizer(varargin)
            if ~isa(varargin{1},'LpPuFb2d') && ...
                    ~isa(varargin{1},'AbstLpPuFb2d')
                dec = varargin{1};
                this.decX = dec(Direction.HORIZONTAL);
                this.decY = dec(Direction.VERTICAL);
                this.paramMtx = varargin{2};
                this.aveRate = varargin{3};
                this.isEquivalentOrder = true;
                if nargin < 4
                    this.isPeriodicExt = false; % Termination mode
                else
                    validStrings = { 'termination' 'circular' };
%                     string = iptcheckstrs(varargin{4},validStrings,...
%                         mfilename,'EXTENTION SCHEME',3);
                    string = validatestring(varargin{4},validStrings,...
                        mfilename,'EXTENTION SCHEME',3);
                    switch string
                        case 'termination'
                            this.isPeriodicExt = false; % Termination mode
                        case 'circular'
                            this.isPeriodicExt = true; % Periodic mode
                        otherwise
                            error('DirLot:InverseDirLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
            else
                this.lppufb = varargin{1};
                this.aveRate = varargin{2};
                this.isEquivalentOrder = false;
                if nargin < 3
                    this.isPeriodicExt = false; % Termination mode
                else
                    validStrings = { 'termination' 'circular' };
%                     string = iptcheckstrs(varargin{3},validStrings,...
%                         mfilename,'EXTENTION SCHEME',3);
                    string = validatestring(varargin{3},validStrings,...
                        mfilename,'EXTENTION SCHEME',3);
                    switch string
                        case 'termination'
                            this.isPeriodicExt = false; % Termination mode
                        case 'circular'
                            this.isPeriodicExt = true; % Periodic mode
                        otherwise
                            error('DirLot:InverseDirLot:unexpectedError', ...
                                '%s', 'Unexpected logic error.')
                    end
                end
            end
        end
        
        function this = uniformSubbandQuantize(this,orgImg)
            
            if this.isEquivalentOrder == true
                if this.isPeriodicExt == false
                    trnsEquivalentOrderTerminationMode_(this,orgImg);
                else
                    trnsEquivalentOrderPeriodicExtMode_(this,orgImg);
                end
            else
                if this.isPeriodicExt == false
                    trnsVariantOrderTerminationMode_(this,orgImg);
                else
                    trnsVariantOrderPeriodicExtMode_(this,orgImg);
                end
            end
            
            % PSNR
            this.orgImg = orgImg;
            this.psnr = Psnr_(this);
            
        end
        
        function value = getdqSubbandCoefs(this)
            value = this.dqSubbandCoefs;
        end
        
        function value = getImg(this)
            value = this.outputImg;
        end
        
        function value = getPsnr(this)
            value = this.psnr;
        end
        
    end
    
    methods ( Access = private )
        
        function value = Psnr_(this)
            % PSNR
            orgimg = im2uint8(this.orgImg);
            img = im2uint8(this.outputImg);
            value = 10*log10(255.0^2*numel(orgimg) ...
                /sum((int16(orgimg(:))-int16(img(:))).^2));
        end
        
        function this = trnsEquivalentOrderTerminationMode_(this,orgImg)
            % Forward transform
            fdirlot = ...
                ForwardDirLot([this.decY this.decX],this.paramMtx);
            fdirlot = forwardTransform(fdirlot,orgImg);
            subbandCoefs = getSubbandCoefs(fdirlot);
            % Quantization
            ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            this.dqSubbandCoefs = ...
                getDeQuantizedCoefs(ecsQdq,this.aveRate);
            % Inverse transform
            idirlot = ...
                InverseDirLot([this.decY this.decX],this.paramMtx);
            idirlot = inverseTransform(idirlot,this.dqSubbandCoefs);
            this.outputImg = getImage(idirlot);
        end
        
        function this = trnsEquivalentOrderPeriodicExtMode_(this,orgImg)
            % Forward transform
            fdirlot = ForwardDirLot(...
                [this.decY this.decX],this.paramMtx,'circular');
            fdirlot = forwardTransform(fdirlot,orgImg);
            subbandCoefs = getSubbandCoefs(fdirlot);
            % Quantization
            ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            this.dqSubbandCoefs = ...
                getDeQuantizedCoefs(ecsQdq,this.aveRate);
            % Inverse transform
            idirlot = InverseDirLot(...
                [this.decY this.decX],this.paramMtx,'circular');
            idirlot = inverseTransform(idirlot,this.dqSubbandCoefs);
            this.outputImg = getImage(idirlot);
        end
        
        function this = trnsVariantOrderTerminationMode_(this,orgImg)
            % Forward transform
            fdirlot = ForwardDirLot(this.lppufb);
            fdirlot = forwardTransform(fdirlot,orgImg);
            subbandCoefs = getSubbandCoefs(fdirlot);
            % Quantization
            ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            this.dqSubbandCoefs = ...
                getDeQuantizedCoefs(ecsQdq,this.aveRate);
            % Inverse transform
            idirlot = InverseDirLot(this.lppufb);
            idirlot = inverseTransform(idirlot,this.dqSubbandCoefs);
            this.outputImg = getImage(idirlot);
        end
        
        function this = trnsVariantOrderPeriodicExtMode_(this,orgImg)
            % Forward transform
            fdirlot = ForwardDirLot(this.lppufb,'circular');
            fdirlot = forwardTransform(fdirlot,orgImg);
            subbandCoefs = getSubbandCoefs(fdirlot);
            % Quantization
            ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            this.dqSubbandCoefs = ...
                getDeQuantizedCoefs(ecsQdq,this.aveRate);
            % Inverse transform
            idirlot = InverseDirLot(this.lppufb,'circular');
            idirlot = inverseTransform(idirlot,this.dqSubbandCoefs);
            this.outputImg = getImage(idirlot);
        end
        
    end
    
end