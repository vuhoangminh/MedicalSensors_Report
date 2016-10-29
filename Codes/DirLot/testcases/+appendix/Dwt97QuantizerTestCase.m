classdef Dwt97QuantizerTestCase < TestCase
    %DWT97QUANTIZERTESTCASE Test case for Dwt97Quantizer
    %
    % SVN identifier:
    % $Id: Dwt97QuantizerTestCase.m 249 2011-11-27 01:55:42Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit_2008a
    %
    % Copyright (c) 2008-2009, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties
        dwt97quantizer;
        ecsQdq;
        analysisLowFilter = [ ...
            0.02674875741080976 ;
            -0.01686411844287495 ;
            -0.07822326652898785 ;
            0.2668641184428723 ;
            0.6029490182363579 ;
            0.2668641184428723 ;
            -0.07822326652898785 ;
            -0.01686411844287495 ;
            0.02674875741080976 ];
        analysisHighFilter = [ ...
            0.09127176311424948 ;
            -0.05754352622849957 ;
            -0.5912717631142470 ;
            1.115087052456994 ;
            -0.5912717631142470 ;
            -0.05754352622849957 ;
            0.09127176311424948 ];
        synthesisLowFilter = [ ...
            -0.09127176311424948 ;
            -0.05754352622849957 ;
            0.5912717631142470 ;
            1.115087052456994 ;
            0.5912717631142470 ;
            -0.05754352622849957 ;
            -0.09127176311424948 ];
        synthesisHighFilter = [ ...
            0.02674875741080976 ;
            0.01686411844287495 ;
            -0.07822326652898785 ;
            -0.2668641184428723 ;
            0.6029490182363579 ;
            -0.2668641184428723 ;
            -0.07822326652898785 ;
            0.01686411844287495 ;
            0.02674875741080976 ];
    end
    
    methods

        % Test
        function this = testDwt97QuantizeGetCoefsLevel1(this)
            
            % Preperation
            nLevels = 1;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            coefsExpctd = forwardtransform_(this,srcImg);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            coefsActual = getCoefs(this.dwt97quantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDwt97QuantizeGetCoefsLevel2(this)
            
            % Preperation
            nLevels = 2;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            coefsExpctd = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            coefsExpctd{1} = coefsLv2{1};
            coefsExpctd{2} = coefsLv2{2};
            coefsExpctd{3} = coefsLv2{3};
            coefsExpctd{4} = coefsLv2{4};
            coefsExpctd{5} = coefsLv1{2};
            coefsExpctd{6} = coefsLv1{3};
            coefsExpctd{7} = coefsLv1{4};
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            coefsActual = getCoefs(this.dwt97quantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDwt97QuantizeGetCoefsLevel3(this)
            
            % Preperation
            nLevels = 3;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Expected value
            coefsExpctd = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            coefsLv3 = forwardtransform_(this,coefsLv2{1});
            coefsExpctd{1} = coefsLv3{1};
            coefsExpctd{2} = coefsLv3{2};
            coefsExpctd{3} = coefsLv3{3};
            coefsExpctd{4} = coefsLv3{4};
            coefsExpctd{5} = coefsLv2{2};
            coefsExpctd{6} = coefsLv2{3};
            coefsExpctd{7} = coefsLv2{4};
            coefsExpctd{8} = coefsLv1{2};
            coefsExpctd{9} = coefsLv1{3};
            coefsExpctd{10} = coefsLv1{4};
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            coefsActual = getCoefs(this.dwt97quantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDwt97QuantizeGetDqCoefsLevel1Rate0_2(this)
            
            % Preperation
            nLevels = 1;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = forwardtransform_(this,srcImg);
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            deQuantizedCoefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            deQuantizedCoefsActual = getDqCoefs(this.dwt97quantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = deQuantizedCoefsExpctd{iSubband};
                subCoefActual = deQuantizedCoefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDwt97QuantizeGetDqCoefsLevel2Rate0_2(this)
            
            % Preperation
            nLevels = 2;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            subCoefs{1} = coefsLv2{1};
            subCoefs{2} = coefsLv2{2};
            subCoefs{3} = coefsLv2{3};
            subCoefs{4} = coefsLv2{4};
            subCoefs{5} = coefsLv1{2};
            subCoefs{6} = coefsLv1{3};
            subCoefs{7} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            deQuantizedCoefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            deQuantizedCoefsActual = getDqCoefs(this.dwt97quantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = deQuantizedCoefsExpctd{iSubband};
                subCoefActual = deQuantizedCoefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDwt97QuantizeGetDqCoefsLevel3Rate0_2(this)
            
            % Preperation
            nLevels = 3;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            coefsLv3 = forwardtransform_(this,coefsLv2{1});
            subCoefs{1} = coefsLv3{1};
            subCoefs{2} = coefsLv3{2};
            subCoefs{3} = coefsLv3{3};
            subCoefs{4} = coefsLv3{4};
            subCoefs{5} = coefsLv2{2};
            subCoefs{6} = coefsLv2{3};
            subCoefs{7} = coefsLv2{4};
            subCoefs{8} = coefsLv1{2};
            subCoefs{9} = coefsLv1{3};
            subCoefs{10} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            deQuantizedCoefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            deQuantizedCoefsActual = getDqCoefs(this.dwt97quantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = deQuantizedCoefsExpctd{iSubband};
                subCoefActual = deQuantizedCoefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDwt97QuantizeGetDqCoefsLevel1Rate1_0(this)
            
            % Preperation
            nLevels = 1;
            nDecs = nLevels*3+1;
            aveRate = 1.0;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = forwardtransform_(this,srcImg);
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            deQuantizedCoefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            deQuantizedCoefsActual = getDqCoefs(this.dwt97quantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = deQuantizedCoefsExpctd{iSubband};
                subCoefActual = deQuantizedCoefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDwt97QuantizeGetDqCoefsLevel2Rate1_0(this)
            
            % Preperation
            nLevels = 2;
            nDecs = nLevels*3+1;
            aveRate = 1.0;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            subCoefs{1} = coefsLv2{1};
            subCoefs{2} = coefsLv2{2};
            subCoefs{3} = coefsLv2{3};
            subCoefs{4} = coefsLv2{4};
            subCoefs{5} = coefsLv1{2};
            subCoefs{6} = coefsLv1{3};
            subCoefs{7} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            deQuantizedCoefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            deQuantizedCoefsActual = getDqCoefs(this.dwt97quantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = deQuantizedCoefsExpctd{iSubband};
                subCoefActual = deQuantizedCoefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDwt97QuantizeGetDqCoefsLevel3Rate1_0(this)
            
            % Preperation
            nLevels = 3;
            nDecs = nLevels*3+1;
            aveRate = 1.0;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            coefsLv3 = forwardtransform_(this,coefsLv2{1});
            subCoefs{1} = coefsLv3{1};
            subCoefs{2} = coefsLv3{2};
            subCoefs{3} = coefsLv3{3};
            subCoefs{4} = coefsLv3{4};
            subCoefs{5} = coefsLv2{2};
            subCoefs{6} = coefsLv2{3};
            subCoefs{7} = coefsLv2{4};
            subCoefs{8} = coefsLv1{2};
            subCoefs{9} = coefsLv1{3};
            subCoefs{10} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            deQuantizedCoefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            deQuantizedCoefsActual = getDqCoefs(this.dwt97quantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = deQuantizedCoefsExpctd{iSubband};
                subCoefActual = deQuantizedCoefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDwt97QuantizerLevel1Rate0_2(this)
            
            % Preperation
            nLevels = 1;
            aveRate = 0.2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = forwardtransform_(this,srcImg);
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            imgExpctd = inversetransform_(this,dqsubCoefs);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            imgActual = getImg(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-14,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97QuantizerLevel1Rate1_0(this)
            
            % Preperation
            nLevels = 1;
            aveRate = 1.0;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = forwardtransform_(this,srcImg);
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            imgExpctd = inversetransform_(this,dqsubCoefs);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            imgActual = getImg(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-14,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97QuantizerLevel2Rate0_2(this)
            
            % Preperation
            nLevels = 2;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            subCoefs{1} = coefsLv2{1};
            subCoefs{2} = coefsLv2{2};
            subCoefs{3} = coefsLv2{3};
            subCoefs{4} = coefsLv2{4};
            subCoefs{5} = coefsLv1{2};
            subCoefs{6} = coefsLv1{3};
            subCoefs{7} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            dqCoefsLv2 = cell(4,1);
            dqCoefsLv2{1} = dqsubCoefs{1};
            dqCoefsLv2{2} = dqsubCoefs{2};
            dqCoefsLv2{3} = dqsubCoefs{3};
            dqCoefsLv2{4} = dqsubCoefs{4};
            dqCoefsLv1 = cell(4,1);
            dqCoefsLv1{1} = inversetransform_(this,dqCoefsLv2);
            dqCoefsLv1{2} = dqsubCoefs{5};
            dqCoefsLv1{3} = dqsubCoefs{6};
            dqCoefsLv1{4} = dqsubCoefs{7};
            imgExpctd = inversetransform_(this,dqCoefsLv1);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            imgActual = getImg(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-14,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97QuantizerLevel2Rate1_0(this)
            
            % Preperation
            nLevels = 2;
            nDecs = nLevels*3+1;
            aveRate = 1.0;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            subCoefs{1} = coefsLv2{1};
            subCoefs{2} = coefsLv2{2};
            subCoefs{3} = coefsLv2{3};
            subCoefs{4} = coefsLv2{4};
            subCoefs{5} = coefsLv1{2};
            subCoefs{6} = coefsLv1{3};
            subCoefs{7} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            dqCoefsLv2 = cell(4,1);
            dqCoefsLv2{1} = dqsubCoefs{1};
            dqCoefsLv2{2} = dqsubCoefs{2};
            dqCoefsLv2{3} = dqsubCoefs{3};
            dqCoefsLv2{4} = dqsubCoefs{4};
            dqCoefsLv1 = cell(4,1);
            dqCoefsLv1{1} = inversetransform_(this,dqCoefsLv2);
            dqCoefsLv1{2} = dqsubCoefs{5};
            dqCoefsLv1{3} = dqsubCoefs{6};
            dqCoefsLv1{4} = dqsubCoefs{7};
            imgExpctd = inversetransform_(this,dqCoefsLv1);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            imgActual = getImg(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-14,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97QuantizerLevel3Rate0_2(this)
            
            % Preperation
            nLevels = 3;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            coefsLv3 = forwardtransform_(this,coefsLv2{1});
            subCoefs{1} = coefsLv3{1};
            subCoefs{2} = coefsLv3{2};
            subCoefs{3} = coefsLv3{3};
            subCoefs{4} = coefsLv3{4};
            subCoefs{5} = coefsLv2{2};
            subCoefs{6} = coefsLv2{3};
            subCoefs{7} = coefsLv2{4};
            subCoefs{8} = coefsLv1{2};
            subCoefs{9} = coefsLv1{3};
            subCoefs{10} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            dqCoefsLv3 = cell(4,1);
            dqCoefsLv3{1} = dqsubCoefs{1};
            dqCoefsLv3{2} = dqsubCoefs{2};
            dqCoefsLv3{3} = dqsubCoefs{3};
            dqCoefsLv3{4} = dqsubCoefs{4};
            dqCoefsLv2 = cell(4,1);
            dqCoefsLv2{1} = inversetransform_(this,dqCoefsLv3);
            dqCoefsLv2{2} = dqsubCoefs{5};
            dqCoefsLv2{3} = dqsubCoefs{6};
            dqCoefsLv2{4} = dqsubCoefs{7};
            dqCoefsLv1 = cell(4,1);
            dqCoefsLv1{1} = inversetransform_(this,dqCoefsLv2);
            dqCoefsLv1{2} = dqsubCoefs{8};
            dqCoefsLv1{3} = dqsubCoefs{9};
            dqCoefsLv1{4} = dqsubCoefs{10};
            imgExpctd = inversetransform_(this,dqCoefsLv1);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            imgActual = getImg(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-14,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97QuantizerLevel3Rate1_0(this)
            
            % Preperation
            nLevels = 3;
            nDecs = nLevels*3+1;
            aveRate = 1.0;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            coefsLv3 = forwardtransform_(this,coefsLv2{1});
            subCoefs{1} = coefsLv3{1};
            subCoefs{2} = coefsLv3{2};
            subCoefs{3} = coefsLv3{3};
            subCoefs{4} = coefsLv3{4};
            subCoefs{5} = coefsLv2{2};
            subCoefs{6} = coefsLv2{3};
            subCoefs{7} = coefsLv2{4};
            subCoefs{8} = coefsLv1{2};
            subCoefs{9} = coefsLv1{3};
            subCoefs{10} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            dqCoefsLv3 = cell(4,1);
            dqCoefsLv3{1} = dqsubCoefs{1};
            dqCoefsLv3{2} = dqsubCoefs{2};
            dqCoefsLv3{3} = dqsubCoefs{3};
            dqCoefsLv3{4} = dqsubCoefs{4};
            dqCoefsLv2 = cell(4,1);
            dqCoefsLv2{1} = inversetransform_(this,dqCoefsLv3);
            dqCoefsLv2{2} = dqsubCoefs{5};
            dqCoefsLv2{3} = dqsubCoefs{6};
            dqCoefsLv2{4} = dqsubCoefs{7};
            dqCoefsLv1 = cell(4,1);
            dqCoefsLv1{1} = inversetransform_(this,dqCoefsLv2);
            dqCoefsLv1{2} = dqsubCoefs{8};
            dqCoefsLv1{3} = dqsubCoefs{9};
            dqCoefsLv1{4} = dqsubCoefs{10};
            imgExpctd = inversetransform_(this,dqCoefsLv1);
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            imgActual = getImg(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-14,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97GetPsnrLevel1Rate0_2(this)
            
            % Preperation
            nLevels = 1;
            aveRate = 0.2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = forwardtransform_(this,srcImg);
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            resImg = inversetransform_(this,dqsubCoefs);
            % PSNR
            srcImgU8 = im2uint8(srcImg);
            resImgU8 = im2uint8(resImg);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImgU8(:))-int16(resImgU8(:))).^2));
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97GetPsnrLevel1Rate1_0(this)
            
            % Preperation
            nLevels = 1;
            aveRate = 0.2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = forwardtransform_(this,srcImg);
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            resImg = inversetransform_(this,dqsubCoefs);
            % PSNR
            srcImgU8 = im2uint8(srcImg);
            resImgU8 = im2uint8(resImg);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImgU8(:))-int16(resImgU8(:))).^2));
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97GetPsnrLevel2Rate0_2(this)
            
            % Preperation
            nLevels = 2;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            subCoefs{1} = coefsLv2{1};
            subCoefs{2} = coefsLv2{2};
            subCoefs{3} = coefsLv2{3};
            subCoefs{4} = coefsLv2{4};
            subCoefs{5} = coefsLv1{2};
            subCoefs{6} = coefsLv1{3};
            subCoefs{7} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            dqCoefsLv2 = cell(4,1);
            dqCoefsLv2{1} = dqsubCoefs{1};
            dqCoefsLv2{2} = dqsubCoefs{2};
            dqCoefsLv2{3} = dqsubCoefs{3};
            dqCoefsLv2{4} = dqsubCoefs{4};
            dqCoefsLv1 = cell(4,1);
            dqCoefsLv1{1} = inversetransform_(this,dqCoefsLv2);
            dqCoefsLv1{2} = dqsubCoefs{5};
            dqCoefsLv1{3} = dqsubCoefs{6};
            dqCoefsLv1{4} = dqsubCoefs{7};
            resImg = inversetransform_(this,dqCoefsLv1);
            % PSNR
            srcImgU8 = im2uint8(srcImg);
            resImgU8 = im2uint8(resImg);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImgU8(:))-int16(resImgU8(:))).^2));
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97GetPsnrLevel2Rate1_0(this)
            
            % Preperation
            nLevels = 2;
            nDecs = nLevels*3+1;
            aveRate = 1.0;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            subCoefs{1} = coefsLv2{1};
            subCoefs{2} = coefsLv2{2};
            subCoefs{3} = coefsLv2{3};
            subCoefs{4} = coefsLv2{4};
            subCoefs{5} = coefsLv1{2};
            subCoefs{6} = coefsLv1{3};
            subCoefs{7} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            dqCoefsLv2 = cell(4,1);
            dqCoefsLv2{1} = dqsubCoefs{1};
            dqCoefsLv2{2} = dqsubCoefs{2};
            dqCoefsLv2{3} = dqsubCoefs{3};
            dqCoefsLv2{4} = dqsubCoefs{4};
            dqCoefsLv1 = cell(4,1);
            dqCoefsLv1{1} = inversetransform_(this,dqCoefsLv2);
            dqCoefsLv1{2} = dqsubCoefs{5};
            dqCoefsLv1{3} = dqsubCoefs{6};
            dqCoefsLv1{4} = dqsubCoefs{7};
            resImg = inversetransform_(this,dqCoefsLv1);
            % PSNR
            srcImgU8 = im2uint8(srcImg);
            resImgU8 = im2uint8(resImg);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImgU8(:))-int16(resImgU8(:))).^2));
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97GetPsnrLevel3Rate0_2(this)
            
            % Preperation
            nLevels = 3;
            nDecs = nLevels*3+1;
            aveRate = 0.2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            coefsLv3 = forwardtransform_(this,coefsLv2{1});
            subCoefs{1} = coefsLv3{1};
            subCoefs{2} = coefsLv3{2};
            subCoefs{3} = coefsLv3{3};
            subCoefs{4} = coefsLv3{4};
            subCoefs{5} = coefsLv2{2};
            subCoefs{6} = coefsLv2{3};
            subCoefs{7} = coefsLv2{4};
            subCoefs{8} = coefsLv1{2};
            subCoefs{9} = coefsLv1{3};
            subCoefs{10} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            dqCoefsLv3 = cell(4,1);
            dqCoefsLv3{1} = dqsubCoefs{1};
            dqCoefsLv3{2} = dqsubCoefs{2};
            dqCoefsLv3{3} = dqsubCoefs{3};
            dqCoefsLv3{4} = dqsubCoefs{4};
            dqCoefsLv2 = cell(4,1);
            dqCoefsLv2{1} = inversetransform_(this,dqCoefsLv3);
            dqCoefsLv2{2} = dqsubCoefs{5};
            dqCoefsLv2{3} = dqsubCoefs{6};
            dqCoefsLv2{4} = dqsubCoefs{7};
            dqCoefsLv1 = cell(4,1);
            dqCoefsLv1{1} = inversetransform_(this,dqCoefsLv2);
            dqCoefsLv1{2} = dqsubCoefs{8};
            dqCoefsLv1{3} = dqsubCoefs{9};
            dqCoefsLv1{4} = dqsubCoefs{10};
            resImg = inversetransform_(this,dqCoefsLv1);
            % PSNR
            srcImgU8 = im2uint8(srcImg);
            resImgU8 = im2uint8(resImg);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImgU8(:))-int16(resImgU8(:))).^2));
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDwt97GetPsnrLevel3Rate1_0(this)
            
            % Preperation
            nLevels = 3;
            nDecs = nLevels*3+1;
            aveRate = 1.0;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Expected value
            subCoefs = cell(nDecs,1);
            coefsLv1 = forwardtransform_(this,srcImg);
            coefsLv2 = forwardtransform_(this,coefsLv1{1});
            coefsLv3 = forwardtransform_(this,coefsLv2{1});
            subCoefs{1} = coefsLv3{1};
            subCoefs{2} = coefsLv3{2};
            subCoefs{3} = coefsLv3{3};
            subCoefs{4} = coefsLv3{4};
            subCoefs{5} = coefsLv2{2};
            subCoefs{6} = coefsLv2{3};
            subCoefs{7} = coefsLv2{4};
            subCoefs{8} = coefsLv1{2};
            subCoefs{9} = coefsLv1{3};
            subCoefs{10} = coefsLv1{4};
            this.ecsQdq = EcsQuantizerDeQuantizer(subCoefs,'dwt97');
            dqsubCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            dqCoefsLv3 = cell(4,1);
            dqCoefsLv3{1} = dqsubCoefs{1};
            dqCoefsLv3{2} = dqsubCoefs{2};
            dqCoefsLv3{3} = dqsubCoefs{3};
            dqCoefsLv3{4} = dqsubCoefs{4};
            dqCoefsLv2 = cell(4,1);
            dqCoefsLv2{1} = inversetransform_(this,dqCoefsLv3);
            dqCoefsLv2{2} = dqsubCoefs{5};
            dqCoefsLv2{3} = dqsubCoefs{6};
            dqCoefsLv2{4} = dqsubCoefs{7};
            dqCoefsLv1 = cell(4,1);
            dqCoefsLv1{1} = inversetransform_(this,dqCoefsLv2);
            dqCoefsLv1{2} = dqsubCoefs{8};
            dqCoefsLv1{3} = dqsubCoefs{9};
            dqCoefsLv1{4} = dqsubCoefs{10};
            resImg = inversetransform_(this,dqCoefsLv1);
            % PSNR
            srcImgU8 = im2uint8(srcImg);
            resImgU8 = im2uint8(resImg);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImgU8(:))-int16(resImgU8(:))).^2));
            
            % Target instantiation
            this.dwt97quantizer = Dwt97Quantizer(aveRate);
            
            % Actual value
            this.dwt97quantizer = ...
                dwt97Quantize(this.dwt97quantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dwt97quantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
    end
    
    methods
        
        function value = forwardtransform_(this,srcImg)
            phase = 1; % for phase adjustment required experimentaly
            value{1} = ...
                downsample(appendix.Dwt97QuantizerTestCase.myimfilter_( ...
                downsample(appendix.Dwt97QuantizerTestCase.myimfilter_(...
                srcImg,this.analysisLowFilter),2).',...
                this.analysisLowFilter),2).';
            value{2} = ...
                downsample(appendix.Dwt97QuantizerTestCase.myimfilter_( ...
                downsample(appendix.Dwt97QuantizerTestCase.myimfilter_(...
                srcImg,this.analysisLowFilter),2).',...
                this.analysisHighFilter),2,phase).';
            value{3} = ...
                downsample(appendix.Dwt97QuantizerTestCase.myimfilter_( ...
                downsample(appendix.Dwt97QuantizerTestCase.myimfilter_(...
                srcImg,this.analysisHighFilter),2,phase).',...
                this.analysisLowFilter),2).';
            value{4} = ...
                downsample(appendix.Dwt97QuantizerTestCase.myimfilter_( ...
                downsample(appendix.Dwt97QuantizerTestCase.myimfilter_(...
                srcImg,this.analysisHighFilter),2,phase).',...
                this.analysisHighFilter),2,phase).';
        end
        
        function value = inversetransform_(this,subCoefs)
            phase = 1; % for phase adjustment required experimentaly
            value = ...
                appendix.Dwt97QuantizerTestCase.myimfilter_( ...
                upsample(appendix.Dwt97QuantizerTestCase.myimfilter_(...
                upsample(subCoefs{1},2),this.synthesisLowFilter).',2),...
                this.synthesisLowFilter).';
            value = value + ...
                appendix.Dwt97QuantizerTestCase.myimfilter_( ...
                upsample(appendix.Dwt97QuantizerTestCase.myimfilter_(...
                upsample(subCoefs{2},2),this.synthesisLowFilter).',...
                2,phase),this.synthesisHighFilter).';
            value = value + ...
                appendix.Dwt97QuantizerTestCase.myimfilter_( ...
                upsample(appendix.Dwt97QuantizerTestCase.myimfilter_(...
                upsample(subCoefs{3},2,phase),this.synthesisHighFilter).',...
                2),this.synthesisLowFilter).';
            value = value + ...
                appendix.Dwt97QuantizerTestCase.myimfilter_( ...
                upsample(appendix.Dwt97QuantizerTestCase.myimfilter_(...
                upsample(subCoefs{4},2,phase),this.synthesisHighFilter).',...
                2,phase),this.synthesisHighFilter).';
        end
        
    end
    
    methods (Access = private, Static = true)
        
        function value = myimfilter_(orgImg,filter)
            verticalSize = size(orgImg,1);
            symImg = appendix.Dwt97QuantizerTestCase.symWS_(orgImg);
            filter = filter(:);
            value = imfilter(symImg,filter,'conv');
            value = appendix.Dwt97QuantizerTestCase.clipping_(value,verticalSize);
        end
        
        function value = symWS_(orgImg)
            imgSize = size(orgImg);
            if mod(imgSize(1),2) == 0
                value = [ ...
                    flipud(orgImg(2:5,:));
                    orgImg;
                    flipud(orgImg(end-4:end-1,:))];
            else
                value = [ ...
                    flipud(orgImg(2:4,:));
                    orgImg;
                    flipud(orgImg(end-3:end-1,:))];
            end
        end
        
        function value = clipping_(symImg,verticalSize)
            if mod(verticalSize(1),2) == 0
                value = symImg(5:end-4,:);
            else
                value = symImg(4:end-3,:);
            end
        end
        
    end
    
end
