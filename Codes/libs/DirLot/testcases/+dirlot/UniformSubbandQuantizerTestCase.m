classdef UniformSubbandQuantizerTestCase < TestCase
    %UNIFORMSUBBANDQUANTIZERTESTCASE Test case for UniformSubbandQuantizer
    %
    % SVN identifier:
    % $Id: UniformSubbandQuantizerTestCase.m 249 2011-11-27 01:55:42Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit_2008a
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
    properties
        uniformsubbandquantizer
        lppufb
        ecsQdq
    end
    
    methods
        
        function this = tearDown(this)
            delete(this.uniformsubbandquantizer);
            delete(this.ecsQdq);
            delete(this.lppufb);
        end
        
        % Test
        function this = testCoefQuantizerBlockDctOrd22Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    subbandCoefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerBlockDctOrd22Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    subbandCoefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd22Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,dec+1:end-dec) = rand(...  % ignore border
                height-2*dec,width-2*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd22Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd22Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,dec+1:end-dec) = rand(...  % ignore border
                height-2*dec,width-2*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd22Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerBlockDctOrd22Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    subbandCoefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            dctCoefs = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    dctCoefs = dctCoefs + upsample(...
                        upsample(...
                        dQsubbandCoefs{iSubband}.',...
                        dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = DirLotUtility.blockproc(dctCoefs,[dec dec],fun);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerBlockDctOrd22Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    subbandCoefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            dctCoefs = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    dctCoefs = dctCoefs + upsample(...
                        upsample(...
                        dQsubbandCoefs{iSubband}.',...
                        dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = DirLotUtility.blockproc(dctCoefs,[dec dec],fun);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd22Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,2*dec+1:end-2*dec) = ...  % ignore border
                rand(height-4*dec,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd22Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd22Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,2*dec+1:end-2*dec) = ...  % ignore border
                rand(height-4*dec,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd22Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerGetPsnrRate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = im2uint8(rand(height,width));
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(im2double(srcImg),[dec dec],fun);
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    subbandCoefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            dQdctCoefs = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    dQdctCoefs = dQdctCoefs + upsample(...
                        upsample(...
                        dQsubbandCoefs{iSubband}.',...
                        dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = DirLotUtility.blockproc(dQdctCoefs,[dec dec],fun);
            % PSNR
            imgExpctd = im2uint8(imgExpctd);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImg(:))-int16(imgExpctd(:))).^2));
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            psnrActual = getPsnr(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerGetPsnrRate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = im2uint8(rand(height,width));
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expcted values
            % Forward transform
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(im2double(srcImg),[dec dec],fun);
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    subbandCoefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            dQdctCoefs = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    dQdctCoefs = dQdctCoefs + upsample(...
                        upsample(...
                        dQsubbandCoefs{iSubband}.',...
                        dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = DirLotUtility.blockproc(dQdctCoefs,[dec dec],fun);
            % PSNR
            imgExpctd = im2uint8(imgExpctd);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImg(:))-int16(imgExpctd(:))).^2));
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            psnrActual = getPsnr(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd02Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(:,dec+1:end-dec) = rand(...  % ignore border
                height,width-2*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd02Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(:,dec+1:end-dec) = rand(...  % ignore border
                height,width-2*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd04Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(:,2*dec+1:end-2*dec) = rand(...  % ignore border
                height,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd04Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(:,2*dec+1:end-2*dec) = rand(...  % ignore border
                height,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd20Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,:) = rand(...  % ignore border
                height-2*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd20Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,:) = rand(...  % ignore border
                height-2*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd40Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,:) = rand(...  % ignore border
                height-4*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd40Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,:) = rand(...  % ignore border
                height-4*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd24Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,2*dec+1:end-2*dec) = rand(...  % ignore border
                height-2*dec,width-4*dec);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd24Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,2*dec+1:end-2*dec) = rand(...  % ignore border
                height-2*dec,width-4*dec);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd42Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,dec+1:end-dec) = rand(...  % ignore border
                height-4*dec,width-2*dec);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd42Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,dec+1:end-dec) = rand(...  % ignore border
                height-4*dec,width-2*dec);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd02Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(:,2*dec+1:end-2*dec) = ...  % ignore border
                rand(height,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd02Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(:,2*dec+1:end-2*dec) = ...  % ignore border
                rand(height,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd04Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(:,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height,width-8*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd04Rate1_0(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(:,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height,width-8*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd20Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,:) = ...  % ignore border
                rand(height-4*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd20Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,:) = ...  % ignore border
                rand(height-4*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd40Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,:) = ...  % ignore border
                rand(height-8*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd40Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,:) = ...  % ignore border
                rand(height-8*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd24Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = [2 4];
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height-4*dec,width-8*dec);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd24Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = [2 4];
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height-4*dec,width-8*dec);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd42Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = [4 2];
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,2*dec+1:end-2*dec) = ...  % ignore border
                rand(height-8*dec,width-4*dec);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd42Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = [4 2];
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,2*dec+1:end-2*dec) = ...  % ignore border
                rand(height-8*dec,width-4*dec);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd44Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,2*dec+1:end-2*dec) = rand(...  % ignore border
                height-4*dec,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd44Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,2*dec+1:end-2*dec) = rand(...  % ignore border
                height-4*dec,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd44Rate0_2(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height-8*dec,width-8*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testUniformSubbandQuantizerDirLotOrd44Rate1_0(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 64;
            width = 64;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height-8*dec,width-8*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate);
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd02Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd02Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd04Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd04Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd20Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd20Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd40Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd40Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd24Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd24Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd42Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd42Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd02Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd02Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd04Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd04Rate1_0PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd20Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd20Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd40Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd40Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd24Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd24Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd42Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd42Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd44Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd44Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            coefActual = getdqSubbandCoefs(this.uniformsubbandquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd44Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testUniformSubbandQuantizerDirLotOrd44Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase+1).',...
                    dec,phase+1),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.uniformsubbandquantizer = ...
                UniformSubbandQuantizer(this.lppufb,aveRate,'circular');
            
            % Actual values
            this.uniformsubbandquantizer = uniformSubbandQuantize(...
                this.uniformsubbandquantizer,srcImg);
            imgActual = getImg(this.uniformsubbandquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
    end
    
end


