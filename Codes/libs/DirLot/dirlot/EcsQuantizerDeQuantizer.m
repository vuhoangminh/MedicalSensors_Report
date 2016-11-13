classdef EcsQuantizerDeQuantizer < handle
    %ECSQUANTIZERDEQUANTIZER Entropy coded scalar quantizer (ECSQ)
    %
    % SVN identifier:
    % $Id: EcsQuantizerDeQuantizer.m 184 2011-08-17 14:13:14Z sho $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2008-2011, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties ( GetAccess = private, SetAccess = private )
        coefs;
        nDecs;
        varianceSet;
        etaSet;
        ebsqrd =1;
        cb = 1/12;
        isFilterBankType;
        gainSets;
    end
    
    methods
        
        function this = EcsQuantizerDeQuantizer(varargin)
            this.coefs = varargin{1};
            this.nDecs = length(this.coefs);
            this = calcEtaSet_(this);
            this.varianceSet = zeros(this.nDecs,1);
            for iSubband = 1:this.nDecs
                ithcoef = this.coefs{iSubband};
                this.varianceSet(iSubband) = var(ithcoef(:));
            end
            this.isFilterBankType = 'orthogonal';
            this = setGainSets(this);
            if nargin > 1
                switch varargin{2}
                    case 'dwt97'
                        this.isFilterBankType = 'dwt97';
                        this = setGainSets(this);
                    case 'dwt53'
                        this.isFilterBankType = 'dwt53';
                        this = setGainSets(this);
                end
            end
        end
        
        function value = getEtaSet(this)
            value = this.etaSet;
        end
        
        function value = getVarianceSet(this)
            value = this.varianceSet;
        end
        
        function value = getGainSets(this)
            value = this.gainSets;
        end
        
        function this = setGainSets(this)
            switch this.isFilterBankType
                case 'orthogonal'
                    this.gainSets = ones(this.nDecs,1);
                case 'dwt97'
                    basisImg = getBasisImgsDwt97_(this);
                    this.gainSets = ...
                        EcsQuantizerDeQuantizer.computeNorm_(basisImg);
                case 'dwt53'
                    basisImg = getBasisImgsDwt53_(this);
                    this.gainSets = ...
                        EcsQuantizerDeQuantizer.computeNorm_(basisImg);
            end
        end
        
        function value = getBitRates(this,aveRate)

            bitRates = aveRate * ones(this.nDecs,1);

            % Initial assignment of average rate
            aveRateOrg = aveRate;
            
            % Initial subband occupation
            etaSetOrg = this.etaSet;
            etaSetSig = this.etaSet;

            elementSet = this.varianceSet.*this.gainSets;
            
            % Significant subband index set
            sigSubbands = 1:this.nDecs;
            elementSet(elementSet == 0) = 1e-323;            
            while true
                
                % Calculation of denominator
                denom = prod(...
                    elementSet(sigSubbands) ...
                    .^etaSetSig(sigSubbands));
                if denom == 0
                    id = 'DirLot:ArithmeticException';
                    msg = 'denom becomes null.';
                    me = MException(id, msg);                    throw(me);
                end
                % Calculation of initial bitrates
                bitRates(sigSubbands) = aveRate ...
                    + 0.5*log2(elementSet(sigSubbands)/denom);
                % Search for insignificant subband index set
                insigSubbands = find(bitRates < 0);
                if isempty(insigSubbands)
                    break
                else
                    % Update of insignificant subbands
                    bitRates(insigSubbands) = 0 * bitRates(insigSubbands);
                    % Update of significant subband index set
                    sigSubbands = setdiff(sigSubbands, insigSubbands);
                    % Update of average bit rate
                    zeta = sum(etaSetOrg(sigSubbands));
                    aveRate = aveRateOrg / zeta;
                    % Update ob subband occupation
                    denom = sum(etaSetSig(sigSubbands));
                    etaSetSig(sigSubbands) = etaSetSig(sigSubbands)/denom;
                end
            end
            value = bitRates;
        end
        
        function value = getQTable(this,aveRate)
            bitRates = getBitRates(this,aveRate);
            qTable = zeros(this.nDecs,1);
            for iSubband = 1:this.nDecs
                qTable(iSubband) = sqrt(this.ebsqrd ...
                    * this.varianceSet(iSubband)/this.cb)...
                    * 2^(-bitRates(iSubband));
            end
            value = qTable;
        end
        
        function value = getDeQuantizedCoefs(this,aveRate)
            value = cell(this.nDecs,1);
            qTable = getQTable(this,aveRate);
            for iSubband = 1:this.nDecs
                s = this.coefs{iSubband};
                % Quantization
                if qTable(iSubband) == 0
                    q = 0;
                else
                    q = sign(s).*floor(abs(s/qTable(iSubband)));
                end
                % Dequantization
                if qTable(iSubband) == 0
                    value{iSubband} = 0;
                else
                    value{iSubband} = sign(q).*(abs(q)+0.5)*qTable(iSubband);
                end                
                
            end
        end
        
    end
    
    methods ( Access = private )
        
        function this = calcEtaSet_(this)
            etas = zeros(this.nDecs,1);
            totalCoefs = 0;
            for iSubband = 1:this.nDecs
                nSubCoefs = numel(this.coefs{iSubband});
                totalCoefs = totalCoefs + nSubCoefs;
                etas(iSubband) = nSubCoefs;
            end
            this.etaSet = etas/totalCoefs;
        end
        
        function value = getBasisImgsDwt97_(this)
            
            subbands = cell(this.nDecs,1);
            nLevels = (this.nDecs-1)/3;
            sizeOfSubband = 8;
            subbands{1} = zeros(sizeOfSubband,sizeOfSubband);
            for iLevel = 1:nLevels
                idx = 3*iLevel-1;
                for idec = idx:idx+2
                    subbands{idec} = ...
                        zeros(sizeOfSubband,sizeOfSubband);
                end
                sizeOfSubband = sizeOfSubband*2;
            end
            value = cell(this.nDecs,1);
            subbandCoefs = cell(4,1);
            for impulseIdx = 1:this.nDecs
                sizeOfSubband = size(subbands{impulseIdx},1);
                subbands{impulseIdx}(sizeOfSubband/2,sizeOfSubband/2) = 1;   
                subbandCoefs{1} = subbands{1};
                for iLevel = 1:nLevels
                    idx = 3*iLevel-1;
                    subbandCoefs{2} = subbands{idx};
                    subbandCoefs{3} = subbands{idx+1};
                    subbandCoefs{4} = subbands{idx+2};
                    subbandCoefs{1} = ...
                        EcsQuantizerDeQuantizer.getAnalysisFilterBankDwt97_...
                        (subbandCoefs);
                end
                value{impulseIdx} = subbandCoefs{1};
                subbands{impulseIdx} = zeros(sizeOfSubband,sizeOfSubband);
            end

        end
        
        function value = getBasisImgsDwt53_(this)
            
            subbands = cell(this.nDecs,1);
            nLevels = (this.nDecs-1)/3;
            sizeOfSubband = 8;
            subbands{1} = zeros(sizeOfSubband,sizeOfSubband);
            for iLevel = 1:nLevels
                idx = 3*iLevel-1;
                for idec = idx:idx+2
                    subbands{idec} = ...
                        zeros(sizeOfSubband,sizeOfSubband);
                end
                sizeOfSubband = sizeOfSubband*2;
            end
            value = cell(this.nDecs,1);
            subbandCoefs = cell(4,1);
            for impulseIdx = 1:this.nDecs
                sizeOfSubband = size(subbands{impulseIdx},1);
                subbands{impulseIdx}(sizeOfSubband/2,sizeOfSubband/2) = 1;   
                subbandCoefs{1} = subbands{1};
                for iLevel = 1:nLevels
                    idx = 3*iLevel-1;
                    subbandCoefs{2} = subbands{idx};
                    subbandCoefs{3} = subbands{idx+1};
                    subbandCoefs{4} = subbands{idx+2};
                    subbandCoefs{1} = ...
                        EcsQuantizerDeQuantizer.getAnalysisFilterBankDwt53_...
                        (subbandCoefs);
                end
                value{impulseIdx} = subbandCoefs{1};
                subbands{impulseIdx} = zeros(sizeOfSubband,sizeOfSubband);
            end

        end
        
    end
    
    methods (Access = private, Static = true)
        
        function value = getAnalysisFilterBankDwt97_(impulse)
            
            % Rifting parameter
            a = -1.586134342059924;
            b = -0.052980118572961;
            g =  0.882911075530934;
            d =  0.443506852043971;
            K =  1.230174104914001;
            % Preparation of arrays
            value = zeros(size(impulse{1},1)*2,size(impulse{1},2)*2);
            value(1:2:end,1:2:end) = impulse{1};
            value(1:2:end,2:2:end) = impulse{2};
            value(2:2:end,1:2:end) = impulse{3};
            value(2:2:end,2:2:end) = impulse{4};
            % Horizontal transform (inplace computation)
            value(:,1:2:end) = value(:,1:2:end)*K;
            value(:,2:2:end) = value(:,2:2:end)/K;
            value = ...
                EcsQuantizerDeQuantizer.updateStep_(value.',-d);
            value = ...
                EcsQuantizerDeQuantizer.predictionStep_(value,-g);
            value = ...
                EcsQuantizerDeQuantizer.updateStep_(value,-b);
            value = ...
                EcsQuantizerDeQuantizer.predictionStep_(value,-a).';
            % Vertical transform (inplace computation)
            value(1:2:end,:) = value(1:2:end,:)*K;
            value(2:2:end,:) = value(2:2:end,:)/K;
            value = ...
                EcsQuantizerDeQuantizer.updateStep_(value,-d);
            value = ...
                EcsQuantizerDeQuantizer.predictionStep_(value,-g);
            value = ...
                EcsQuantizerDeQuantizer.updateStep_(value,-b);
            value = ...
                EcsQuantizerDeQuantizer.predictionStep_(value,-a);
            
        end
        
        function value = getAnalysisFilterBankDwt53_(impulse)
            
            % Rifting parameter
            a = -1/2;
            b = 1/4;
            % Preparation of arrays
            value = zeros(size(impulse{1},1)*2,size(impulse{1},2)*2);
            value(1:2:end,1:2:end) = impulse{1};
            value(1:2:end,2:2:end) = impulse{2};
            value(2:2:end,1:2:end) = impulse{3};
            value(2:2:end,2:2:end) = impulse{4};
            
            % Horizontal transform
            value = EcsQuantizerDeQuantizer.updateStep_(value,-b);
            value = EcsQuantizerDeQuantizer.predictionStep_(value,-a).';
            % Vertical transform
            value = EcsQuantizerDeQuantizer.updateStep_(value,-b);
            value = EcsQuantizerDeQuantizer.predictionStep_(value,-a).';
        end
        
        function value = updateStep_(value,rifParam)
            value(1:2:end,:) = imlincomb(...
                rifParam, [value(2,:); value(2:2:end-1,:)], ...
                1, value(1:2:end,:), ...
                rifParam, value(2:2:end,:) ...
                );
        end
        
        function value = predictionStep_(value,rifParam)
            value(2:2:end,:) = imlincomb(...
                rifParam, value(1:2:end,:), ...
                1, value(2:2:end,:), ...
                rifParam, [value(3:2:end,:); value(end-1,:)] ...
                );
        end
        
        function value = computeNorm_(basisImg)
            nSubbands = length(basisImg);
            value = zeros(nSubbands,1);
            for iSubband = 1:nSubbands
                value(iSubband) = ...
                    sqrt(sum(sum(basisImg{iSubband}.^2).'));
            end
        end
        
    end
    
end

