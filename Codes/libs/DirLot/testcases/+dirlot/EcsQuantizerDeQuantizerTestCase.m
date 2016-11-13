classdef EcsQuantizerDeQuantizerTestCase < TestCase
    %ECSQUANTIZERDEQUANTIZERTESTCASE Test case for EcsQuantizerDeQuantizer
    %
    % SVN identifier:
    % $Id: EcsQuantizerDeQuantizerTestCase.m 249 2011-11-27 01:55:42Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit_2008a
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
    properties
        ecsQdq;
    end
    
    methods
       
        function this = tearDown(this)
            delete(this.ecsQdq)
        end
        
        % Test for getEtaSetUniformDec4
        function this = testGetEtaSetUniformDec4(this)
            
            % Preperation
            coefs{1} = ones(16,16);
            coefs{2} = ones(16,16);
            coefs{3} = ones(16,16);
            coefs{4} = ones(16,16);
            
            % Expected value
            etaSetExpctd = [ 1 1 1 1 ].'/4;
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            etaSetActual = getEtaSet(this.ecsQdq);
            
            % Evaluation
            diff = norm(etaSetExpctd - etaSetActual)/...
                numel(etaSetExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getEtaSetUniformDec16
        function this = testGetEtaSetUniformDec16(this)
            
            % Preperation
            nDecs = 16;
            coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefs{iSubband} = ones(4,4);
            end
            
            % Expected value
            etaSetExpctd = ones(nDecs,1)/nDecs;
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            etaSetActual = getEtaSet(this.ecsQdq);
            
            % Evaluation
            diff = norm(etaSetExpctd - etaSetActual)/...
                numel(etaSetExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getEtaSetNonUniformDec
        function this = testGetEtaSetNonUniformDec(this)
            
            % Preperation
            coefs{1} = ones(4,4);
            coefs{2} = ones(4,4);
            coefs{3} = ones(4,4);
            coefs{4} = ones(4,4);
            coefs{5} = ones(8,8);
            coefs{6} = ones(8,8);
            coefs{7} = ones(8,8);
            coefs{8} = ones(16,16);
            coefs{9} = ones(16,16);
            coefs{10} = ones(16,16);
            
            % Expected value
            etaSetExpctd = 1./[64 64 64 64 16 16 16 4 4 4 ].';
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            etaSetActual = getEtaSet(this.ecsQdq);
            
            % Evaluation
            diff = norm(etaSetExpctd - etaSetActual)/...
                numel(etaSetExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesUniformDec4 for aveRate 0.2
        function this = testGetBitRatesUniformDec4Rate0_2(this)
            
            % Preperation
            aveRate = .2;
            coefs{1} = ones(16,16);
            coefs{2} = ones(16,16);
            coefs{3} = ones(16,16);
            coefs{4} = ones(16,16);
            
            % Expected value
            bitRatesExpctd = [ 1 1 1 1 ].' * aveRate;
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesUniformDec4 for aveRate 1.0
        function this = testGetBitRatesUniformDec4Rate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            coefs{1} = ones(16,16);
            coefs{2} = ones(16,16);
            coefs{3} = ones(16,16);
            coefs{4} = ones(16,16);
            
            % Expected value
            bitRatesExpctd = [ 1 1 1 1 ].' * aveRate;
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesUniformDec16 for aveRate 0.2
        function this = testGetBitRatesUniformDec16Rate0_2(this)
            
            % Preperation
            aveRate = 0.2;
            nDecs = 16;
            coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefs{iSubband} = ones(4,4);
            end
            
            % Expected value
            bitRatesExpctd = ones(nDecs,1) * aveRate;
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesUniformDec16 for aveRate 1.0
        function this = testGetBitRatesUniformDec16Rate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            nDecs = 16;
            coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefs{iSubband} = ones(4,4);
            end
            
            % Expected value
            bitRatesExpctd = ones(nDecs,1) * aveRate;
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesNonUniformDec for aveRate 0.2
        function this = testGetBitRatesNonUniformDecRate0_2(this)
            
            % Preperation
            aveRate = 0.2;
            coefs{1} = ones(4,4);
            coefs{2} = ones(4,4);
            coefs{3} = ones(4,4);
            coefs{4} = ones(4,4);
            coefs{5} = ones(8,8);
            coefs{6} = ones(8,8);
            coefs{7} = ones(8,8);
            coefs{8} = ones(16,16);
            coefs{9} = ones(16,16);
            coefs{10} = ones(16,16);
            
            % Expected value
            bitRatesExpctd = ones(10,1) * aveRate;
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesNonUniformDec for aveRate 1.0
        function this = testGetBitRatesNonUniformDecRate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            coefs{1} = ones(4,4);
            coefs{2} = ones(4,4);
            coefs{3} = ones(4,4);
            coefs{4} = ones(4,4);
            coefs{5} = ones(8,8);
            coefs{6} = ones(8,8);
            coefs{7} = ones(8,8);
            coefs{8} = ones(16,16);
            coefs{9} = ones(16,16);
            coefs{10} = ones(16,16);
            
            % Expected value
            bitRatesExpctd = ones(10,1) * aveRate;
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getVarianceSetDec4 for biased coefs
        function this = testGetVarianceSetDec4(this)
            
            % Preperation
            coefs{1} = ones(16,16);
            coefs{2} = ones(16,16);
            coefs{3} = ones(16,16);
            coefs{4} = ones(16,16);
            
            % Expected value
            varianceSetExpctd = [ 0 0 0 0 ].';
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            varianceSetActual = getVarianceSet(this.ecsQdq);
            
            % Evaluation
            diff = norm(varianceSetExpctd - varianceSetActual)/...
                numel(varianceSetExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getVarianceSetDec4 for biased coefs
        function this = testGetVarianceSetDec4BiasedCoefs(this)
            
            % Preperation
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            varianceSetExpctd = [ 16 8 4 2 ].';
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            varianceSetActual = getVarianceSet(this.ecsQdq);
            
            % Evaluation
            diff = norm(varianceSetExpctd - varianceSetActual)/...
                numel(varianceSetExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getVarianceSetDec8 for biased coefs
        function this = testGetVarianceSetDec16BiasedCoefs(this)
            
            % Preperation
            nDecs = 16;
            coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                variance = iSubband;
                coefs{iSubband} = [ones(8,4) zeros(8,4)] ...
                    *2*sqrt(63/64*variance);
            end
            
            % Expected value
            varianceSetExpctd = (1:nDecs).';
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            varianceSetActual = getVarianceSet(this.ecsQdq);
            
            % Evaluation
            diff = norm(varianceSetExpctd - varianceSetActual)/...
                numel(varianceSetExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getVarianceSetNonUniformDec for biased coefs
        function this = testGetVarianceSetNonUniformDec(this)
            
            % Preperation
            nDecs = 5;
            coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                variance = iSubband;
                coefs{iSubband} = ...
                    [ones(iSubband,iSubband) zeros(iSubband,iSubband)] ...
                    *2*sqrt((2*iSubband^2-1)/(2*iSubband^2)*variance);
            end
            
            % Expected value
            varianceSetExpctd = (1:nDecs).';
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            varianceSetActual = getVarianceSet(this.ecsQdq);
            
            % Evaluation
            diff = norm(varianceSetExpctd - varianceSetActual)/...
                numel(varianceSetExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesUniformDec4 for biased coefs
        function this = testGetBitRatesUniformDec4BiasedCoefsRate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [ 1.75 1.25 0.75 0.25 ].';
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesUniformDec4 for biased coefs
        function this = testGetBitRatesUniformDec4BiasedCoefsRate0_2(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [ 0.65 0.15 0 0 ].';
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesUniformDec16 for biased coefs
        function this = testGetBitRatesUniformDec16BiasedCoefsRate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            nDecs = 16;
            coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                variance = 2+iSubband;
                coefs{iSubband} = [ones(8,4) zeros(8,4)] ...
                    *2*sqrt(63/64*(variance));
            end
            
            % Expected value
            bitRatesExpctd = [
                0.182870990592601
                0.390389740232023
                0.551353787675704
                0.682870990592601
                0.794067201260825
                0.890389740232023
                0.975352240953179
                1.051353787675704
                1.120105549550671
                1.182870990592601
                1.240609599302569
                1.294067201260825
                1.343835038036282
                1.390389740232023
                1.434121160857192
                1.475352240953179 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesUniformDec16 for biased coefs
        function this = testGetBitRatesUniformDec16BiasedCoefsRate0_2(this)
            
            % Preperation
            aveRate = 0.2;
            nDecs = 16;
            coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                variance = 2+iSubband;
                coefs{iSubband} = [ones(8,4) zeros(8,4)] ...
                    *2*sqrt(63/64*(variance));
            end
            
            % Expected value
            bitRatesExpctd = [
                0
                0
                0
                0
                0
                0
                0.044546486011757
                0.120548032734282
                0.189299794609249
                0.252065235651179
                0.309803844361147
                0.363261446319403
                0.413029283094860
                0.459583985290601
                0.503315405915770
                0.544546486011757 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesNonUniformDec for biased coefs
        function this=testGetBitRatesNonUniformDecBiasedCoefsRate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            bitRatesExpctd = [
                2.025915841097120
                1.949914294374595
                1.864951793653439
                1.768629254682241
                1.657433044014017
                1.525915841097120
                1.364951793653439
                1.157433044014017
                0.864951793653439
                0.364951793653439 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesNonUniformDec for biased coefs
        function this=testGetBitRatesNonUniformDecBiasedCoefsRate0_2(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            bitRatesExpctd = [
                1.040867634750559
                0.964866088028034
                0.879903587306877
                0.783581048335680
                0.672384837667455
                0.540867634750559
                0.379903587306877
                0.172384837667455
                0
                0 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableUniformDec4 for biased coefs
        function this = testGetQTableUniformDec4BiasedCoefsRate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [
                4.119534287814235
                4.119534287814235
                4.119534287814235
                4.119534287814235 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableUniformDec4 for biased coefs
        function this = testGetQTableUniformDec4BiasedCoefsRate0_2(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [
                8.830415055375292
                8.830415055375291
                6.928203230275509
                4.898979485566356 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableUniformDec16 for biased coefs
        function this = testGetQTableUniformDec16BiasedCoefsRate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            nDecs = 16;
            coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                variance = 2+iSubband;
                coefs{iSubband} = [ones(8,4) zeros(8,4)] ...
                    *2*sqrt(63/64*(variance));
            end
            
            % Expected value
            qTableExpctd = [
                5.285688883180484
                5.285688883180484
                5.285688883180485
                5.285688883180484
                5.285688883180485
                5.285688883180484
                5.285688883180485
                5.285688883180484
                5.285688883180485
                5.285688883180484
                5.285688883180485
                5.285688883180485
                5.285688883180484
                5.285688883180484
                5.285688883180485
                5.285688883180484 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableUniformDec16 for biased coefs
        function this = testGetQTableUniformDec16BiasedCoefsRate0_2(this)
            
            % Preperation
            aveRate = 0.2;
            nDecs = 16;
            coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                variance = 2+iSubband;
                coefs{iSubband} = [ones(8,4) zeros(8,4)] ...
                    *2*sqrt(63/64*(variance));
            end
            
            % Expected value
            qTableExpctd = [
                6.000000000000000
                6.928203230275509
                7.745966692414834
                8.485281374238570
                9.165151389911680
                9.797958971132712
                10.076322274817763
                10.076322274817763
                10.076322274817763
                10.076322274817763
                10.076322274817763
                10.076322274817763
                10.076322274817764
                10.076322274817763
                10.076322274817766
                10.076322274817763 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableNonUniformDec for biased coefs
        function this=testGetQTableNonUniformDecBiasedCoefsRate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            qTableExpctd = [
                2.689856961624920
                2.689856961624920
                2.689856961624920
                2.689856961624920
                2.689856961624920
                2.689856961624920
                2.689856961624920
                2.689856961624920
                2.689856961624920
                2.689856961624920 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-3,sprintf('%g',diff));
            
        end
        
        % Test for getQTableNonUniformDec for biased coefs
        function this=testGetQTableNonUniformDecBiasedCoefsRate0_2(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            qTableExpctd = [
                5.324247595686943
                5.324247595686943
                5.324247595686943
                5.324247595686942
                5.324247595686943
                5.324247595686943
                5.324247595686943
                5.324247595686943
                4.898979485566356
                3.464101615137754 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-3,sprintf('%g',diff));
            
        end
        
        % Test for getDeQuantizedCoefsDec4
        function this = testGetDeQuantizedCoefsDec4BiasedCoefsRate1_0(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            deQuantizedCoefsExpctd{1}(:,1:3) = [
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                ];
            deQuantizedCoefsExpctd{1}(:,4:8) = [
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                ];
            deQuantizedCoefsExpctd{2}(:,1:3) = [
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                6.179301431721353   6.179301431721353   6.179301431721353
                ];
            deQuantizedCoefsExpctd{2}(:,4:8) = [
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                6.179301431721353   0   0   0   0
                ];
            deQuantizedCoefsExpctd{3} = zeros(8,8);
            deQuantizedCoefsExpctd{4} = zeros(8,8);
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            deQuantizedCoefsActual = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Evaluation
            for iSubband = 1:4
                diff = norm(deQuantizedCoefsExpctd{iSubband}(:) ...
                    - deQuantizedCoefsActual{iSubband}(:))/...
                    numel(deQuantizedCoefsExpctd{iSubband});
                this.assert(diff<1e-15,sprintf('%d: %g',iSubband,diff));
            end
            
        end
        
        % Test for
        function this = ...
                testGetDeQuantizedCoefsNonUniformDecBiasedCoefsRate0_2(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            deQuantizedCoefsExpctd{1} = [
                7.986371393530415   7.986371393530415   0   0
                7.986371393530415   7.986371393530415   0   0
                7.986371393530415   7.986371393530415   0   0
                7.986371393530415   7.986371393530415   0   0
                ];
            deQuantizedCoefsExpctd{2} = [
                7.986371393530415   7.986371393530415   0   0
                7.986371393530415   7.986371393530415   0   0
                7.986371393530415   7.986371393530415   0   0
                7.986371393530415   7.986371393530415   0   0
                ];
            deQuantizedCoefsExpctd{3} = [
                7.986371393530415   7.986371393530415   0   0
                7.986371393530415   7.986371393530415   0   0
                7.986371393530415   7.986371393530415   0   0
                7.986371393530415   7.986371393530415   0   0
                ];
            deQuantizedCoefsExpctd{4} = zeros(4,4);
            deQuantizedCoefsExpctd{5} = zeros(8,8);
            deQuantizedCoefsExpctd{6} = zeros(8,8);
            deQuantizedCoefsExpctd{7} = zeros(8,8);
            deQuantizedCoefsExpctd{8} = zeros(16,16);
            deQuantizedCoefsExpctd{9} = zeros(16,16);
            deQuantizedCoefsExpctd{10} = zeros(16,16);
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            deQuantizedCoefsActual = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Evaluation
            for iSubband = 1:10
                diff = norm(deQuantizedCoefsExpctd{iSubband}(:) ...
                    - deQuantizedCoefsActual{iSubband}(:))/...
                    numel(deQuantizedCoefsExpctd{iSubband});
                this.assert(diff<1e-15,sprintf('%d: %g',iSubband,diff));
            end
        end
        
        % Following test for Dwt 9/7
        % Test for getGainSetsUniformDec4
        function this = testGetGainSetsUniformDec4(this)
            
            % Preperation
            coefs{1} = ones(16,16);
            coefs{2} = ones(16,16);
            coefs{3} = ones(16,16);
            coefs{4} = ones(16,16);
            
            % Expected value
            gainSetsExpctd = [ 1 1 1 1 ].';
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs);
            
            % Actual value
            gainSetsActual = getGainSets(this.ecsQdq);
            
            % Evaluation
            diff = norm(gainSetsExpctd - gainSetsActual)/...
                numel(gainSetsExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getGainSetsUniformDec4
        function this = testDwt97GetGainSetsDec4Level1(this)
            
            % Preperation
            coefs{1} = ones(16,16);
            coefs{2} = ones(16,16);
            coefs{3} = ones(16,16);
            coefs{4} = ones(16,16);
            
            % Expected value
            gainSetsExpctd = [ ...
                1.965907314575303;
                1.011286475626873;
                1.011286475626873;
                0.520217981897461 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            gainSetsActual = getGainSets(this.ecsQdq);
            
            
            % Evaluation
            diff = norm(gainSetsExpctd - gainSetsActual)/...
                numel(gainSetsExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getGainSetsUniformDec4
        function this = testDwt97GetGainSetsDec4Level2(this)
            
            % Preperation
            coefs{1} = ones(8,8);
            coefs{2} = ones(8,8);
            coefs{3} = ones(8,8);
            coefs{4} = ones(8,8);
            coefs{5} = ones(16,16);
            coefs{6} = ones(16,16);
            coefs{7} = ones(16,16);
            
            % Expected value
            gainSetsExpctd = [ ...
                4.122409873969057;
                1.996812457154978;
                1.996812457154979;
                0.967215806032981;
                1.011286475626873;
                1.011286475626873;
                0.520217981897461 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            gainSetsActual = getGainSets(this.ecsQdq);
            
            
            % Evaluation
            diff = norm(gainSetsExpctd - gainSetsActual)/...
                numel(gainSetsExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getGainSetsUniformDec4
        function this = testDwt97GetGainSetsDec4Level3(this)
            
            % Preperation
            coefs{1} = ones(8,8);
            coefs{2} = ones(8,8);
            coefs{3} = ones(8,8);
            coefs{4} = ones(8,8);
            coefs{5} = ones(16,16);
            coefs{6} = ones(16,16);
            coefs{7} = ones(16,16);
            coefs{8} = ones(32,32);
            coefs{9} = ones(32,32);
            coefs{10} = ones(32,32);
            
            % Expected value
            gainSetsExpctd = [ ...
                8.416744177952849;
                4.183367334450827;
                4.183367334450828;
                2.079255574951640;
                1.996812457154978;
                1.996812457154979;
                0.967215806032981;
                1.011286475626873;
                1.011286475626873;
                0.520217981897461 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            gainSetsActual = getGainSets(this.ecsQdq);
            
            
            % Evaluation
            diff = norm(gainSetsExpctd - gainSetsActual)/...
                numel(gainSetsExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt97GetBitRatesDec4BiasedCoefsRate0_2Level1(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [0.8 0 0 0].';
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt97GetBitRatesDec4BiasedCoefsRate1_0Level1(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [...
                2.153001188642370;
                1.173499405678815;
                0.673499405678815;
                0.000000000000000];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt97GetBitRatesDec4BiasedCoefsRate0_2Level2(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [...
                1.512291328079679;
                0.878200560652313;
                0.746683357735416;
                0.062824753532593;
                0.000000000000000;
                0.000000000000000;
                0.000000000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt97GetBitRatesDec4BiasedCoefsRate1_0Level2(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [...
                2.751487071140121;
                2.117396303712755;
                1.985879100795859;
                1.302020496593035;
                1.126642753650067;
                0.834161503289489;
                0.000000000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt97GetBitRatesDec4BiasedCoefsRate0_2Level3(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            bitRatesExpctd = [...
                2.248387095290775;
                1.668086756590190;
                1.583124255869034;
                0.982502924919777;
                0.842122583956391;
                0.710605381039494;
                0.026746776836671;
                0.000000000000000;
                0.000000000000000;
                0.000000000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt97GetBitRatesDec4BiasedCoefsRate1_0Level3(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            bitRatesExpctd = [...
                3.511634822815164;
                2.931334484114581;
                2.846371983393425;
                2.245750652444168;
                2.105370311480781;
                1.973853108563885;
                1.289994504361061;
                1.114616761418093;
                0.822135511057515;
                0.000000000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt97GetQTableDec4BiasedCoefsRate0_2Level1(this)
            
            % Preperation
            aveRate = .2;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [
                7.958415653702621;
                9.797958971132712;
                6.928203230275509;
                4.898979485566356 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt97GetQTableDec4BiasedCoefsRate1_0Level1(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [
                3.115535296827510;
                4.343872760314016;
                4.343872760314016;
                4.898979485566356 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt97GetQTableDec4BiasedCoefsRate0_2Level2(this)
            
            % Preperation
            aveRate = .2;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [ ...
                3.212880636196431;
                4.616379855743646;
                4.616379855743645;
                6.632976878264832;
                6.000000000000000;
                4.898979485566356;
                3.464101615137754 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt97GetQTableDec4BiasedCoefsRate1_0Level2(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [
                1.361004314437282;
                1.955538848833951;
                1.955538848833950;
                2.809786970352060;
                2.747881417227351;
                2.747881417227350;
                3.464101615137754 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt97GetQTableDec4BiasedCoefsRate0_2Level3(this)
            
            % Preperation
            aveRate = .2;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            qTableExpctd = [ ...
                2.305465700912577;
                3.270150411664522;
                3.270150411664521;
                4.638491785272128;
                4.733278847365085;
                4.733278847365084;
                6.800941459332126;
                6.000000000000000;
                4.898979485566356;
                3.464101615137754 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt97GetQTableDec4BiasedCoefsRate1_0Level3(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            qTableExpctd = [
                0.960468680117566;
                1.362361213369637;
                1.362361213369636;
                1.932419155476055;
                1.971907925308809;
                1.971907925308809;
                2.833306634931047;
                2.770882893822539;
                2.770882893822539;
                3.464101615137754 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getDeQuantizedCoefsDec4
        function this = ...
                testDwt97GetDeQuantizedCoefsDec4BiasedCoefsRate1_0Level1(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            deQuantizedCoefsExpctd{1}(:,1:3) = [
                7.788838242068776   7.788838242068776   7.788838242068776
                7.788838242068776   7.788838242068776   7.788838242068776
                7.788838242068776   7.788838242068776   7.788838242068776
                7.788838242068776   7.788838242068776   7.788838242068776
                7.788838242068776   7.788838242068776   7.788838242068776
                7.788838242068776   7.788838242068776   7.788838242068776
                7.788838242068776   7.788838242068776   7.788838242068776
                7.788838242068776   7.788838242068776   7.788838242068776
                ];
            deQuantizedCoefsExpctd{1}(:,4:8) = [
                7.788838242068776   0   0   0   0
                7.788838242068776   0   0   0   0
                7.788838242068776   0   0   0   0
                7.788838242068776   0   0   0   0
                7.788838242068776   0   0   0   0
                7.788838242068776   0   0   0   0
                7.788838242068776   0   0   0   0
                7.788838242068776   0   0   0   0
                ];
            deQuantizedCoefsExpctd{2}(:,1:3) = [
                6.515809140471024   6.515809140471024   6.515809140471024
                6.515809140471024   6.515809140471024   6.515809140471024
                6.515809140471024   6.515809140471024   6.515809140471024
                6.515809140471024   6.515809140471024   6.515809140471024
                6.515809140471024   6.515809140471024   6.515809140471024
                6.515809140471024   6.515809140471024   6.515809140471024
                6.515809140471024   6.515809140471024   6.515809140471024
                6.515809140471024   6.515809140471024   6.515809140471024
                ];
            deQuantizedCoefsExpctd{2}(:,4:8) = [
                6.515809140471024   0   0   0   0
                6.515809140471024   0   0   0   0
                6.515809140471024   0   0   0   0
                6.515809140471024   0   0   0   0
                6.515809140471024   0   0   0   0
                6.515809140471024   0   0   0   0
                6.515809140471024   0   0   0   0
                6.515809140471024   0   0   0   0
                ];
            deQuantizedCoefsExpctd{3} = zeros(8,8);
            deQuantizedCoefsExpctd{4} = zeros(8,8);
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            deQuantizedCoefsActual = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Evaluation
            for iSubband = 1:4
                diff = norm(deQuantizedCoefsExpctd{iSubband}(:) ...
                    - deQuantizedCoefsActual{iSubband}(:))/...
                    numel(deQuantizedCoefsExpctd{iSubband});
                this.assert(diff<1e-15,sprintf('%d: %g',iSubband,diff));
            end
            
        end
        
        % Test for getDeQuantizedCoefsDec4
        function this = ...
                testDwt97GetDeQuantizedCoefsDec4BiasedCoefsRate1_0Level2(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            deQuantizedCoefsExpctd{1}(:,:) = [
                4.763515100530487   4.763515100530487   0   0;
                4.763515100530487   4.763515100530487   0   0;
                4.763515100530487   4.763515100530487   0   0;
                4.763515100530487   4.763515100530487   0   0;
                ];
            deQuantizedCoefsExpctd{2}(:,:) = [
                4.888847122084876   4.888847122084876   0   0;
                4.888847122084876   4.888847122084876   0   0;
                4.888847122084876   4.888847122084876   0   0;
                4.888847122084876   4.888847122084876   0   0;
                ];
            deQuantizedCoefsExpctd{3}(:,:) = [
                4.888847122084876   4.888847122084876   0   0;
                4.888847122084876   4.888847122084876   0   0;
                4.888847122084876   4.888847122084876   0   0;
                4.888847122084876   4.888847122084876   0   0;
                ];
            deQuantizedCoefsExpctd{4}(:,:) = [
                4.214680455528090   4.214680455528090   0   0;
                4.214680455528090   4.214680455528090   0   0;
                4.214680455528090   4.214680455528090   0   0;
                4.214680455528090   4.214680455528090   0   0;
                ];
            deQuantizedCoefsExpctd{5}(:,1:3) = [
                4.121822125841026   4.121822125841026   4.121822125841026
                4.121822125841026   4.121822125841026   4.121822125841026
                4.121822125841026   4.121822125841026   4.121822125841026
                4.121822125841026   4.121822125841026   4.121822125841026
                4.121822125841026   4.121822125841026   4.121822125841026
                4.121822125841026   4.121822125841026   4.121822125841026
                4.121822125841026   4.121822125841026   4.121822125841026
                4.121822125841026   4.121822125841026   4.121822125841026
                ];
            deQuantizedCoefsExpctd{5}(:,4:8) = [
                4.121822125841026   0   0   0   0
                4.121822125841026   0   0   0   0
                4.121822125841026   0   0   0   0
                4.121822125841026   0   0   0   0
                4.121822125841026   0   0   0   0
                4.121822125841026   0   0   0   0
                4.121822125841026   0   0   0   0
                4.121822125841026   0   0   0   0
                ];
            deQuantizedCoefsExpctd{6}(:,1:3) = [
                4.121822125841025   4.121822125841025   4.121822125841025
                4.121822125841025   4.121822125841025   4.121822125841025
                4.121822125841025   4.121822125841025   4.121822125841025
                4.121822125841025   4.121822125841025   4.121822125841025
                4.121822125841025   4.121822125841025   4.121822125841025
                4.121822125841025   4.121822125841025   4.121822125841025
                4.121822125841025   4.121822125841025   4.121822125841025
                4.121822125841025   4.121822125841025   4.121822125841025
                ];
            deQuantizedCoefsExpctd{6}(:,4:8) = [
                4.121822125841025   0   0   0   0
                4.121822125841025   0   0   0   0
                4.121822125841025   0   0   0   0
                4.121822125841025   0   0   0   0
                4.121822125841025   0   0   0   0
                4.121822125841025   0   0   0   0
                4.121822125841025   0   0   0   0
                4.121822125841025   0   0   0   0
                ];
            deQuantizedCoefsExpctd{7}(:,:) = zeros(16,16);
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            deQuantizedCoefsActual = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Evaluation
            for iSubband = 1:4
                diff = norm(deQuantizedCoefsExpctd{iSubband}(:) ...
                    - deQuantizedCoefsActual{iSubband}(:))/...
                    numel(deQuantizedCoefsExpctd{iSubband});
                this.assert(diff<1e-15,sprintf('%d: %g',iSubband,diff));
            end
            
        end
        
        % Test for getDeQuantizedCoefsDec4
        function this = ...
                testDwt97GetDeQuantizedCoefsDec4BiasedCoefsRate1_0Level3(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            deQuantizedCoefsExpctd{1}(:,:) = [
                6.243046420764182   6.243046420764182   0   0;
                6.243046420764182   6.243046420764182   0   0;
                6.243046420764182   6.243046420764182   0   0;
                6.243046420764182   6.243046420764182   0   0;
                ];
            deQuantizedCoefsExpctd{2}(:,:) = [
                6.130625460163365   6.130625460163365   0   0;
                6.130625460163365   6.130625460163365   0   0;
                6.130625460163365   6.130625460163365   0   0;
                6.130625460163365   6.130625460163365   0   0;
                ];
            deQuantizedCoefsExpctd{3}(:,:) = [
                6.130625460163364   6.130625460163364   0   0;
                6.130625460163364   6.130625460163364   0   0;
                6.130625460163364   6.130625460163364   0   0;
                6.130625460163364   6.130625460163364   0   0;
                ];
            deQuantizedCoefsExpctd{4}(:,:) = [
                4.831047888690138   4.831047888690138   0   0;
                4.831047888690138   4.831047888690138   0   0;
                4.831047888690138   4.831047888690138   0   0;
                4.831047888690138   4.831047888690138   0   0;
                ];
            deQuantizedCoefsExpctd{5}(:,1:3) = [
                4.929769813272022   4.929769813272022   4.929769813272022
                4.929769813272022   4.929769813272022   4.929769813272022
                4.929769813272022   4.929769813272022   4.929769813272022
                4.929769813272022   4.929769813272022   4.929769813272022
                4.929769813272022   4.929769813272022   4.929769813272022
                4.929769813272022   4.929769813272022   4.929769813272022
                4.929769813272022   4.929769813272022   4.929769813272022
                4.929769813272022   4.929769813272022   4.929769813272022
                ];
            deQuantizedCoefsExpctd{5}(:,4:8) = [
                4.929769813272022   0   0   0   0
                4.929769813272022   0   0   0   0
                4.929769813272022   0   0   0   0
                4.929769813272022   0   0   0   0
                4.929769813272022   0   0   0   0
                4.929769813272022   0   0   0   0
                4.929769813272022   0   0   0   0
                4.929769813272022   0   0   0   0
                ];
            deQuantizedCoefsExpctd{6}(:,1:3) = [
                4.929769813272021   4.929769813272021   4.929769813272021
                4.929769813272021   4.929769813272021   4.929769813272021
                4.929769813272021   4.929769813272021   4.929769813272021
                4.929769813272021   4.929769813272021   4.929769813272021
                4.929769813272021   4.929769813272021   4.929769813272021
                4.929769813272021   4.929769813272021   4.929769813272021
                4.929769813272021   4.929769813272021   4.929769813272021
                4.929769813272021   4.929769813272021   4.929769813272021
                ];
            deQuantizedCoefsExpctd{6}(:,4:8) = [
                4.929769813272021   0   0   0   0
                4.929769813272021   0   0   0   0
                4.929769813272021   0   0   0   0
                4.929769813272021   0   0   0   0
                4.929769813272021   0   0   0   0
                4.929769813272021   0   0   0   0
                4.929769813272021   0   0   0   0
                4.929769813272021   0   0   0   0
                ];
            deQuantizedCoefsExpctd{7}(:,1:3) = [
                4.249959952396570   4.249959952396570   4.249959952396570
                4.249959952396570   4.249959952396570   4.249959952396570
                4.249959952396570   4.249959952396570   4.249959952396570
                4.249959952396570   4.249959952396570   4.249959952396570
                4.249959952396570   4.249959952396570   4.249959952396570
                4.249959952396570   4.249959952396570   4.249959952396570
                4.249959952396570   4.249959952396570   4.249959952396570
                4.249959952396570   4.249959952396570   4.249959952396570
                ];
            deQuantizedCoefsExpctd{7}(:,4:8) = [
                4.249959952396570   0   0   0   0
                4.249959952396570   0   0   0   0
                4.249959952396570   0   0   0   0
                4.249959952396570   0   0   0   0
                4.249959952396570   0   0   0   0
                4.249959952396570   0   0   0   0
                4.249959952396570   0   0   0   0
                4.249959952396570   0   0   0   0
                ];
            deQuantizedCoefsExpctd{8}(:,1:3) = [
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                ];
            deQuantizedCoefsExpctd{8}(:,4:6) = [
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                4.156324340733809   4.156324340733809   4.156324340733809
                ];
            deQuantizedCoefsExpctd{8}(:,7:9) = [
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                4.156324340733809   4.156324340733809   0
                ];
            deQuantizedCoefsExpctd{8}(:,10:16) = [
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                ];
            deQuantizedCoefsExpctd{9}(:,1:3) = [
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                ];
            deQuantizedCoefsExpctd{9}(:,4:6) = [
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                4.156324340733808   4.156324340733808   4.156324340733808
                ];
            deQuantizedCoefsExpctd{9}(:,7:9) = [
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                4.156324340733808   4.156324340733808   0
                ];
            deQuantizedCoefsExpctd{9}(:,10:16) = [
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                ];
            deQuantizedCoefsExpctd{10}(:,:) = zeros(16,16);
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt97');
            
            % Actual value
            deQuantizedCoefsActual = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Evaluation
            for iSubband = 1:4
                diff = norm(deQuantizedCoefsExpctd{iSubband}(:) ...
                    - deQuantizedCoefsActual{iSubband}(:))/...
                    numel(deQuantizedCoefsExpctd{iSubband});
                this.assert(diff<1e-15,sprintf('%d: %g',iSubband,diff));
            end
            
        end
        
        % Following test for Dwt 5/3
        % Test for getGainSetsUniformDec4
        function this = testDwt53GetGainSetsDec4Level1(this)
            
            % Preperation
            coefs{1} = ones(16,16);
            coefs{2} = ones(16,16);
            coefs{3} = ones(16,16);
            coefs{4} = ones(16,16);
            
            % Expected value
            gainSetsExpctd = [ ...
                1.500000000000000 ;
                1.038327982864759 ;
                1.038327982864759 ;
                0.718750000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            gainSetsActual = getGainSets(this.ecsQdq);
            
            % Evaluation
            diff = norm(gainSetsExpctd - gainSetsActual)/...
                numel(gainSetsExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getGainSetsUniformDec4
        function this = testDwt53GetGainSetsDec4Level2(this)
            
            % Preperation
            coefs{1} = ones(8,8);
            coefs{2} = ones(8,8);
            coefs{3} = ones(8,8);
            coefs{4} = ones(8,8);
            coefs{5} = ones(16,16);
            coefs{6} = ones(16,16);
            coefs{7} = ones(16,16);
            
            % Expected value
            gainSetsExpctd = [ ...
                2.750000000000000 ;
                1.592217400357125 ;
                1.592217400357125 ;
                0.921875000000000 ;
                1.038327982864759 ;
                1.038327982864759 ;
                0.718750000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            gainSetsActual = getGainSets(this.ecsQdq);
            
            
            % Evaluation
            diff = norm(gainSetsExpctd - gainSetsActual)/...
                numel(gainSetsExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getGainSetsUniformDec4
        function this = testDwt53GetGainSetsDec4Level3(this)
            
            % Preperation
            coefs{1} = ones(8,8);
            coefs{2} = ones(8,8);
            coefs{3} = ones(8,8);
            coefs{4} = ones(8,8);
            coefs{5} = ones(16,16);
            coefs{6} = ones(16,16);
            coefs{7} = ones(16,16);
            coefs{8} = ones(32,32);
            coefs{9} = ones(32,32);
            coefs{10} = ones(32,32);
            
            % Expected value
            gainSetsExpctd = [ ...
                5.375000000000000 ;
                2.919659922405347 ;
                2.919659922405347 ;
                1.585937500000000 ;
                1.592217400357125 ;
                1.592217400357125 ;
                0.921875000000000 ;
                1.038327982864759 ;
                1.038327982864759 ;
                0.718750000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            gainSetsActual = getGainSets(this.ecsQdq);
            
            
            % Evaluation
            diff = norm(gainSetsExpctd - gainSetsActual)/...
                numel(gainSetsExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt53GetBitRatesDec4BiasedCoefsRate0_2Level1(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [...
                0.782675068083018 ;
                0.017324931916982 ;
                0.000000000000000 ;
                0.000000000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt53GetBitRatesDec4BiasedCoefsRate1_0Level1(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [...
                2.010233424110691 ;
                1.244883287944655 ;
                0.744883287944655 ;
                0.000000000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt53GetBitRatesDec4BiasedCoefsRate0_2Level2(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [...
                1.348687409715865 ;
                0.843294056728777 ;
                0.711776853811880 ;
                0.156615664049335 ;
                0.034906503923535 ;
                0.000000000000000 ;
                0.000000000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt53GetBitRatesDec4BiasedCoefsRate1_0Level2(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            bitRatesExpctd = [...
                2.468812316975896 ;
                1.963418963988808 ;
                1.831901761071911 ;
                1.276740571309366 ;
                1.155031411183566 ;
                0.862550160822987 ;
                0.097200024656952 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt53GetBitRatesDec4BiasedCoefsRate0_2Level3(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            bitRatesExpctd = [...
                2.067277076672798 ;
                1.551043320571043 ;
                1.466080819849887 ;
                0.929526071499458 ;
                0.821180569238431 ;
                0.689663366321534 ;
                0.134502176558989 ;
                0.012793016433188 ;
                0.000000000000000 ;
                0.000000000000000 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getBitRatesDec4 for biased coefs
        function this = ...
                testDwt53GetBitRatesDec4BiasedCoefsRate1_0Level3(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            bitRatesExpctd = [...
                3.198458727678001 ;
                2.682224971576246 ;
                2.597262470855090 ;
                2.060707722504661 ;
                1.952362220243634 ;
                1.820845017326737 ;
                1.265683827564192 ;
                1.143974667438391 ;
                0.851493417077814 ;
                0.086143280911779 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            % Evaluation
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt53GetQTableDec4BiasedCoefsRate0_2Level1(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [ ...
                8.054562243980392 ;
                9.681001609798777 ;
                6.928203230275511 ;
                4.898979485566356 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt53GetQTableDec4BiasedCoefsRate1_0Level1(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [ ...
                3.439616751820097 ;
                4.134170710065254 ;
                4.134170710065255 ;
                4.898979485566356 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt53GetQTableDec4BiasedCoefsRate0_2Level2(this)
            
            % Preperation
            aveRate = 0.2;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [ ...
                3.598688681335364 ;
                4.729436970526870 ;
                4.729436970526871 ;
                6.215479036626878 ;
                5.856570096413875 ;
                4.898979485566356 ;
                3.464101615137755 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt53GetQTableDec4BiasedCoefsRate1_0Level2(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            qTableExpctd = [ ...
                1.655591095686804 ;
                2.175796360665124 ;
                2.175796360665124 ;
                2.859455946227902 ;
                2.694338455331594 ;
                2.694338455331594 ;
                3.238400068594891 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt53GetQTableDec4BiasedCoefsRate0_2Level3(this)
            
            % Preperation
            aveRate = .2;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            qTableExpctd = [ ...
                2.613835268445918 ;
                3.546511020134425 ;
                3.546511020134424 ;
                4.811986649569210 ;
                4.802487741870791 ;
                4.802487741870792 ;
                6.311483178499813 ;
                5.947030539303575 ;
                4.898979485566358 ;
                3.464101615137758 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getQTableDec4 for biased coefs
        function this = ...
                testDwt53GetQTableDec4BiasedCoefsRate1_0Level3(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            qTableExpctd = [ ...
                1.193324634465245 ;
                1.619129949702276 ;
                1.619129949702276 ;
                2.196872266194089 ;
                2.192535619315888 ;
                2.192535619315888 ;
                2.881454867427375 ;
                2.715067062618496 ;
                2.715067062618496 ;
                3.263314356229002 ];
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            qTableActual = getQTable(this.ecsQdq,aveRate);
            
            % Evaluation
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getDeQuantizedCoefsDec4
        function this = ...
                testDwt53GetDeQuantizedCoefsDec4BiasedCoefsRate1_0Level1(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 16;
            coefs{1} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 8;
            coefs{2} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{3} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{4} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            deQuantizedCoefsExpctd{1}(:,1:3) = [
                8.599041879550244   8.599041879550244   8.599041879550244
                8.599041879550244   8.599041879550244   8.599041879550244
                8.599041879550244   8.599041879550244   8.599041879550244
                8.599041879550244   8.599041879550244   8.599041879550244
                8.599041879550244   8.599041879550244   8.599041879550244
                8.599041879550244   8.599041879550244   8.599041879550244
                8.599041879550244   8.599041879550244   8.599041879550244
                8.599041879550244   8.599041879550244   8.599041879550244
                ];
            deQuantizedCoefsExpctd{1}(:,4:8) = [
                8.599041879550244   0   0   0   0
                8.599041879550244   0   0   0   0
                8.599041879550244   0   0   0   0
                8.599041879550244   0   0   0   0
                8.599041879550244   0   0   0   0
                8.599041879550244   0   0   0   0
                8.599041879550244   0   0   0   0
                8.599041879550244   0   0   0   0
                ];
            deQuantizedCoefsExpctd{2}(:,1:3) = [
                6.201256065097881   6.201256065097881   6.201256065097881
                6.201256065097881   6.201256065097881   6.201256065097881
                6.201256065097881   6.201256065097881   6.201256065097881
                6.201256065097881   6.201256065097881   6.201256065097881
                6.201256065097881   6.201256065097881   6.201256065097881
                6.201256065097881   6.201256065097881   6.201256065097881
                6.201256065097881   6.201256065097881   6.201256065097881
                6.201256065097881   6.201256065097881   6.201256065097881
                ];
            deQuantizedCoefsExpctd{2}(:,4:8) = [
                6.201256065097881   0   0   0   0
                6.201256065097881   0   0   0   0
                6.201256065097881   0   0   0   0
                6.201256065097881   0   0   0   0
                6.201256065097881   0   0   0   0
                6.201256065097881   0   0   0   0
                6.201256065097881   0   0   0   0
                6.201256065097881   0   0   0   0
                ];
            deQuantizedCoefsExpctd{3} = zeros(8,8);
            deQuantizedCoefsExpctd{4} = zeros(8,8);
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            deQuantizedCoefsActual = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Evaluation
            for iSubband = 1:4
                diff = norm(deQuantizedCoefsExpctd{iSubband}(:) ...
                    - deQuantizedCoefsActual{iSubband}(:))/...
                    numel(deQuantizedCoefsExpctd{iSubband});
                this.assert(diff<1e-15,sprintf('%d: %g',iSubband,diff));
            end
            
        end
        
        % Test for getDeQuantizedCoefsDec4
        function this = ...
                testDwt53GetDeQuantizedCoefsDec4BiasedCoefsRate1_0Level2(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 7;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 5;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 4;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 3;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 2;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 1;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            
            % Expected value
            deQuantizedCoefsExpctd{1}(:,:) = [
                5.794568834903815   5.794568834903815   0   0;
                5.794568834903815   5.794568834903815   0   0;
                5.794568834903815   5.794568834903815   0   0;
                5.794568834903815   5.794568834903815   0   0;
                ];
            deQuantizedCoefsExpctd{2}(:,:) = [
                5.439490901662810   5.439490901662810   0   0;
                5.439490901662810   5.439490901662810   0   0;
                5.439490901662810   5.439490901662810   0   0;
                5.439490901662810   5.439490901662810   0   0;
                ];
            deQuantizedCoefsExpctd{3}(:,:) = [
                3.263694540997685   3.263694540997685   0   0;
                3.263694540997685   3.263694540997685   0   0;
                3.263694540997685   3.263694540997685   0   0;
                3.263694540997685   3.263694540997685   0   0;
                ];
            deQuantizedCoefsExpctd{4}(:,:) = [
                4.289183919341853   4.289183919341853   0   0;
                4.289183919341853   4.289183919341853   0   0;
                4.289183919341853   4.289183919341853   0   0;
                4.289183919341853   4.289183919341853   0   0;
                ];
            deQuantizedCoefsExpctd{5}(:,1:3) = [
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                ];
            deQuantizedCoefsExpctd{5}(:,4:8) = [
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                ];
            deQuantizedCoefsExpctd{6}(:,1:3) = [
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                4.041507682997391   4.041507682997391   4.041507682997391
                ];
            deQuantizedCoefsExpctd{6}(:,4:8) = [
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                4.041507682997391   0   0   0   0
                ];
            deQuantizedCoefsExpctd{7}(:,:) = zeros(16,16);
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            deQuantizedCoefsActual = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Evaluation
            for iSubband = 1:4
                diff = norm(deQuantizedCoefsExpctd{iSubband}(:) ...
                    - deQuantizedCoefsActual{iSubband}(:))/...
                    numel(deQuantizedCoefsExpctd{iSubband});
                this.assert(diff<1e-15,sprintf('%d: %g',iSubband,diff));
            end
            
        end
        
        % Test for getDeQuantizedCoefsDec4
        function this = ...
                testDwt53GetDeQuantizedCoefsDec4BiasedCoefsRate1_0Level3(this)
            
            % Preperation
            aveRate = 1.0;
            variance = 10;
            coefs{1} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 9;
            coefs{2} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 8;
            coefs{3} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 7;
            coefs{4} = [ones(4,2) zeros(4,2)]*2*sqrt(15/16*variance);
            variance = 6;
            coefs{5} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 5;
            coefs{6} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 4;
            coefs{7} = [ones(8,4) zeros(8,4)]*2*sqrt(63/64*variance);
            variance = 3;
            coefs{8} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 2;
            coefs{9} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            variance = 1;
            coefs{10} = [ones(16,8) zeros(16,8)]*2*sqrt(255/256*variance);
            
            % Expected value
            deQuantizedCoefsExpctd{1}(:,:) = [
                6.563285489558848   6.563285489558848   0   0;
                6.563285489558848   6.563285489558848   0   0;
                6.563285489558848   6.563285489558848   0   0;
                6.563285489558848   6.563285489558848   0   0;
                ];
            deQuantizedCoefsExpctd{2}(:,:) = [
                5.666954823957966   5.666954823957966   0   0;
                5.666954823957966   5.666954823957966   0   0;
                5.666954823957966   5.666954823957966   0   0;
                5.666954823957966   5.666954823957966   0   0;
                ];
            deQuantizedCoefsExpctd{3}(:,:) = [
                5.666954823957966   5.666954823957966   0   0;
                5.666954823957966   5.666954823957966   0   0;
                5.666954823957966   5.666954823957966   0   0;
                5.666954823957966   5.666954823957966   0   0;
                ];
            deQuantizedCoefsExpctd{4}(:,:) = [
                5.492180665485221   5.492180665485221   0   0;
                5.492180665485221   5.492180665485221   0   0;
                5.492180665485221   5.492180665485221   0   0;
                5.492180665485221   5.492180665485221   0   0;
                ];
            deQuantizedCoefsExpctd{5}(:,1:3) = [
                5.481339048289719   5.481339048289719   5.481339048289719
                5.481339048289719   5.481339048289719   5.481339048289719
                5.481339048289719   5.481339048289719   5.481339048289719
                5.481339048289719   5.481339048289719   5.481339048289719
                5.481339048289719   5.481339048289719   5.481339048289719
                5.481339048289719   5.481339048289719   5.481339048289719
                5.481339048289719   5.481339048289719   5.481339048289719
                5.481339048289719   5.481339048289719   5.481339048289719
                ];
            deQuantizedCoefsExpctd{5}(:,4:8) = [
                5.481339048289719   0   0   0   0
                5.481339048289719   0   0   0   0
                5.481339048289719   0   0   0   0
                5.481339048289719   0   0   0   0
                5.481339048289719   0   0   0   0
                5.481339048289719   0   0   0   0
                5.481339048289719   0   0   0   0
                5.481339048289719   0   0   0   0
                ];
            deQuantizedCoefsExpctd{6}(:,1:3) = [
                5.481339048289721   5.481339048289721   5.481339048289721
                5.481339048289721   5.481339048289721   5.481339048289721
                5.481339048289721   5.481339048289721   5.481339048289721
                5.481339048289721   5.481339048289721   5.481339048289721
                5.481339048289721   5.481339048289721   5.481339048289721
                5.481339048289721   5.481339048289721   5.481339048289721
                5.481339048289721   5.481339048289721   5.481339048289721
                5.481339048289721   5.481339048289721   5.481339048289721
                ];
            deQuantizedCoefsExpctd{6}(:,4:8) = [
                5.481339048289721   0   0   0   0
                5.481339048289721   0   0   0   0
                5.481339048289721   0   0   0   0
                5.481339048289721   0   0   0   0
                5.481339048289721   0   0   0   0
                5.481339048289721   0   0   0   0
                5.481339048289721   0   0   0   0
                5.481339048289721   0   0   0   0
                ];
            deQuantizedCoefsExpctd{7}(:,1:3) = [
                4.322182301141063   4.322182301141063   4.322182301141063
                4.322182301141063   4.322182301141063   4.322182301141063
                4.322182301141063   4.322182301141063   4.322182301141063
                4.322182301141063   4.322182301141063   4.322182301141063
                4.322182301141063   4.322182301141063   4.322182301141063
                4.322182301141063   4.322182301141063   4.322182301141063
                4.322182301141063   4.322182301141063   4.322182301141063
                4.322182301141063   4.322182301141063   4.322182301141063
                ];
            deQuantizedCoefsExpctd{7}(:,4:8) = [
                4.322182301141063   0   0   0   0
                4.322182301141063   0   0   0   0
                4.322182301141063   0   0   0   0
                4.322182301141063   0   0   0   0
                4.322182301141063   0   0   0   0
                4.322182301141063   0   0   0   0
                4.322182301141063   0   0   0   0
                4.322182301141063   0   0   0   0
                ];
            deQuantizedCoefsExpctd{8}(:,1:3) = [
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                ];
            deQuantizedCoefsExpctd{8}(:,4:6) = [
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                ];
            deQuantizedCoefsExpctd{8}(:,7:9) = [
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                ];
            deQuantizedCoefsExpctd{8}(:,10:16) = [
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                ];
            deQuantizedCoefsExpctd{9}(:,1:3) = [
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                ];
            deQuantizedCoefsExpctd{9}(:,4:6) = [
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                4.072600593927744   4.072600593927744   4.072600593927744
                ];
            deQuantizedCoefsExpctd{9}(:,7:9) = [
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                4.072600593927744   4.072600593927744   0
                ];
            deQuantizedCoefsExpctd{9}(:,10:16) = [
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                0   0   0   0   0   0   0
                ];
            deQuantizedCoefsExpctd{10}(:,:) = zeros(16,16);
            
            % Target instantiation
            this.ecsQdq = EcsQuantizerDeQuantizer(coefs,'dwt53');
            
            % Actual value
            deQuantizedCoefsActual = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Evaluation
            for iSubband = 1:4
                diff = norm(deQuantizedCoefsExpctd{iSubband}(:) ...
                    - deQuantizedCoefsActual{iSubband}(:))/...
                    numel(deQuantizedCoefsExpctd{iSubband});
                this.assert(diff<1e-15,sprintf('%d: %g',iSubband,diff));
            end
            
        end
        
        function this = testHaarCosWave90(this)
            
            % Setup
            aveRate = 1;
            nLevels = 1;
            haar = LpPuFb2dFactory.createLpPuFb2d();
            
            % Expected values
            varianceSetExpctd = [
                0.481440039416311;
                0.000000000000000;
                0.019048719136960;
                0.000000000000000 ];
            
            bitRatesExpctd = [
                3.164897558169777;
                0;
                0.835102441830223;
                0 ];
            
            qTableExpctd = [
                0.267998663231257;
                0.000000000000000;
                0.267998663231257;
                0.000000000000000 ];
            
            % Load original image
            orgImg = DirLotUtility.coswave(90,4,[64 64]);
            
            % Forward transform
            fdirlot = ForwardDirLot(haar);
            subbandCoefs = waveletDirLot(fdirlot,orgImg,nLevels);
            
            % Quantizatizer
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            
            % Evaluation
            varianceSetActual = getVarianceSet(this.ecsQdq);
            diff = norm(varianceSetExpctd - varianceSetActual)/...
                numel(varianceSetExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
            bitRatesActual = getBitRates(this.ecsQdq,aveRate);
            diff = norm(bitRatesExpctd - bitRatesActual)/...
                numel(bitRatesExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
            qTableActual = getQTable(this.ecsQdq,aveRate);
            diff = norm(qTableExpctd - qTableActual)/...
                numel(qTableExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
    end
end
