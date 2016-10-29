classdef DirectionalDwtQuantizer < handle
    %DIRECTIONALDWTQUANTIZER ECSQ with directional DWT
    %
    % SVN identifier:
    % $Id: DirectionalDwtQuantizer.m 316 2012-04-24 07:07:44Z harashin $
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
        aveRate;
        dqSubbandCoefs;
        outputImg;
        orgImg;
        psnr;
        isPeriodicExt;
        lppufb;
        isEquivalentOrder;
    end
    
    methods

        % constractor
        function this = DirectionalDwtQuantizer(varargin)
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
        
        function this = dirDwtQuantize(this,orgImg,nLevels)
            
            if this.isEquivalentOrder == true
                if this.isPeriodicExt == false
                    trnsEquivalentOrderTerminationMode_(this,nLevels,orgImg);
                else
                    trnsEquivalentOrderPeriodicExtMode_(this,nLevels,orgImg);
                end
            else
                if this.isPeriodicExt == false
                    trnsVariantOrderTerminationMode_(this,nLevels,orgImg);
                else
                    trnsVariantOrderPeriodicExtMode_(this,nLevels,orgImg);
                end
            end
            
            % PSNR
            this.orgImg = orgImg;
            this.psnr = Psnr_(this);
            
        end
        
        function value = getdqDirDwtSubbandCoefs(this)
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
        
        function this = ...
                trnsEquivalentOrderTerminationMode_(this,nLevels,orgImg)
            % Forward transform
            fdirlot = ...
                ForwardDirLot([this.decX this.decY],this.paramMtx);
            subbandCoefs = waveletDirLot(fdirlot,orgImg,nLevels);
            % Quantization
            ecsQdq = ...
                EcsQuantizerDeQuantizer(subbandCoefs);
            this.dqSubbandCoefs = ...
                getDeQuantizedCoefs(ecsQdq,this.aveRate);
            % Inverse transform
            idirlot = ...
                InverseDirLot([this.decX this.decY],this.paramMtx);
            this.outputImg = ...
                iwaveletDirLot(idirlot,this.dqSubbandCoefs,nLevels);
        end
        
        function this = ...
                trnsEquivalentOrderPeriodicExtMode_(this,nLevels,orgImg)
            % Forward transform
            fdirlot = ...
                ForwardDirLot(...
                [this.decX this.decY],this.paramMtx,'circular');
            subbandCoefs = waveletDirLot(fdirlot,orgImg,nLevels);
            % Quantization
            ecsQdq = ...
                EcsQuantizerDeQuantizer(subbandCoefs);
            this.dqSubbandCoefs = ...
                getDeQuantizedCoefs(ecsQdq,this.aveRate);
            % Inverse transform
            idirlot = ...
                InverseDirLot(...
                [this.decX this.decY],this.paramMtx,'circular');
            this.outputImg = ...
                iwaveletDirLot(idirlot,this.dqSubbandCoefs,nLevels);
        end
        
        function this = ...
                trnsVariantOrderTerminationMode_(this,nLevels,orgImg)
            % Forward transform
            fdirlot = ForwardDirLot(this.lppufb);
            subbandCoefs = waveletDirLot(fdirlot,orgImg,nLevels);
            % Quantization
            ecsQdq = ...
                EcsQuantizerDeQuantizer(subbandCoefs);
            this.dqSubbandCoefs = ...
                getDeQuantizedCoefs(ecsQdq,this.aveRate);
            % Inverse transform
            idirlot = InverseDirLot(this.lppufb);
            this.outputImg = ...
                iwaveletDirLot(idirlot,this.dqSubbandCoefs,nLevels);
        end
        
        function this = ...
                trnsVariantOrderPeriodicExtMode_(this,nLevels,orgImg)
            % Forward transform
            fdirlot = ForwardDirLot(this.lppufb,'circular');
            subbandCoefs = waveletDirLot(fdirlot,orgImg,nLevels);
            % Quantization
            ecsQdq = ...
                EcsQuantizerDeQuantizer(subbandCoefs);
            this.dqSubbandCoefs = ...
                getDeQuantizedCoefs(ecsQdq,this.aveRate);
            % Inverse transform
            idirlot = InverseDirLot(this.lppufb,'circular');
            this.outputImg = ...
                iwaveletDirLot(idirlot,this.dqSubbandCoefs,nLevels);
        end
        
    end
    
end