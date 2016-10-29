classdef DirectionalDwtQuantizerTestCase < TestCase
    %DIRECTIONALDWTQUANTIZERTESTCASE Test case for DirectionalDwtQuantizer
    %
    % SVN identifier:
    % $Id: DirectionalDwtQuantizerTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        dirdwtquantizer
        lppufb
        ecsQdq
    end
    
    methods
        
        function this = tearDown(this)
            delete(this.dirdwtquantizer);
            delete(this.ecsQdq);
            delete(this.lppufb);
        end
        
        % Test
        function this = testCoefQuantizerBlockDctOrd22Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    subbandCoefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerBlockDctOrd22Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    subbandCoefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerBlockDctOrd22Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            nDecs = dec*dec;
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            level1Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level2Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level2Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerBlockDctOrd22Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            nDecs = dec*dec;
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            level1Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level2Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level2Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd22Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,dec+1:end-dec) = ...   % ignore border
                rand(height-2*dec,width-2*dec);
            
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd22Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,dec+1:end-dec) = ...   % ignore border
                rand(height-2*dec,width-2*dec);
            
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd22Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(3*dec+1:end-3*dec,3*dec+1:end-3*dec) = ...   % ignore border
                rand(height-6*dec,width-6*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd22Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(3*dec+1:end-3*dec,3*dec+1:end-3*dec) = ...   % ignore border
                rand(height-6*dec,width-6*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerBlockDctOrd22Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerBlockDctOrd22Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerBlockDctOrd22Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            nDecs = dec*dec;
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            level1Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level2Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level2Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{1} = level1Coefs{1} + upsample(...
                        upsample(...
                        level2Coefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            level1Coefs{1} = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            coefs = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefs = coefs + upsample(...
                        upsample(...
                        level1Coefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = DirLotUtility.blockproc(coefs,[dec dec],fun);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerBlockDctOrd22Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            nDecs = dec*dec;
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(srcImg,[dec dec],fun);
            level1Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level2Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level2Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{1} = level1Coefs{1} + upsample(...
                        upsample(...
                        level2Coefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            level1Coefs{1} = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            coefs = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefs = coefs + upsample(...
                        upsample(...
                        level1Coefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = DirLotUtility.blockproc(coefs,[dec dec],fun);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerDirLotOrd22Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerDirLotOrd22Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerDirLotOrd22Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(7*dec+1:end-7*dec,7*dec+1:end-7*dec) = ...  % ignore border
                rand(height-14*dec,width-14*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerDirLotOrd22Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(7*dec+1:end-7*dec,7*dec+1:end-7*dec) = ...  % ignore border
                rand(height-14*dec,width-14*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerGetPsnrLevel1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            % PSNR
            imgExpctd = im2uint8(imgExpctd);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImg(:))-int16(imgExpctd(:))).^2));
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerGetPsnrLevel1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            % PSNR
            imgExpctd = im2uint8(imgExpctd);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImg(:))-int16(imgExpctd(:))).^2));
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerGetPsnrLevel2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = im2uint8(rand(height,width));
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            nDecs = dec*dec;
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(im2double(srcImg),[dec dec],fun);
            level1Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level2Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level2Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{1} = level1Coefs{1} + upsample(...
                        upsample(...
                        level2Coefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            level1Coefs{1} = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            coefs = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefs = coefs + upsample(...
                        upsample(...
                        level1Coefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = DirLotUtility.blockproc(coefs,[dec dec],fun);
            % PSNR
            imgExpctd = im2uint8(imgExpctd);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImg(:))-int16(imgExpctd(:))).^2));
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testDirectionalDwtQuantizerGetPsnrLevel2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = im2uint8(rand(height,width));
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            nDecs = dec*dec;
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(im2double(srcImg),[dec dec],fun);
            level1Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level2Coefs = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level2Coefs{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    level1Coefs{1} = level1Coefs{1} + upsample(...
                        upsample(...
                        level2Coefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            level1Coefs{1} = DirLotUtility.blockproc(level1Coefs{1},[dec dec],fun);
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            coefs = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefs = coefs + upsample(...
                        upsample(...
                        level1Coefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = DirLotUtility.blockproc(coefs,[dec dec],fun);
            % PSNR
            imgExpctd = im2uint8(imgExpctd);
            psnrExpctd = 10*log10(255.0^2*numel(srcImg) ...
                /sum((int16(srcImg(:))-int16(imgExpctd(:))).^2));
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            psnrActual = getPsnr(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(psnrExpctd - psnrActual);
            this.assert(diff==0,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd22Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd22Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd22Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd22Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd44Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,2*dec+1:end-2*dec) = ...   % ignore border
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd44Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,2*dec+1:end-2*dec) = ...   % ignore border
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd44Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(6*dec+1:end-6*dec,6*dec+1:end-6*dec) = ...   % ignore border
                rand(height-12*dec,width-12*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd44Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(6*dec+1:end-6*dec,6*dec+1:end-6*dec) = ...   % ignore border
                rand(height-12*dec,width-12*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd44Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd44Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd44Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd44Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd22Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd22Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd22Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd22Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd44Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height-8*dec,width-8*dec);
            
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd44Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height-8*dec,width-8*dec);
            
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd44Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(15*dec+1:end-15*dec,15*dec+1:end-15*dec) = ...  % ignore border
                rand(height-30*dec,width-30*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd44Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(15*dec+1:end-15*dec,15*dec+1:end-15*dec) = ...  % ignore border
                rand(height-30*dec,width-30*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd44Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd44Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd44Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd44Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            paramMtx = getParameterMatrices(this.lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                [dec dec],paramMtx,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd02Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(:,dec+1:end-dec) = ...   % ignore border
                rand(height,width-2*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd02Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(:,dec+1:end-dec) = ...   % ignore border
                rand(height,width-2*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd02Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(:,3*dec+1:end-3*dec) = ...   % ignore border
                rand(height,width-6*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd02Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(:,3*dec+1:end-3*dec) = ...   % ignore border
                rand(height,width-6*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd02Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd02Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd02Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd02Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd04Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(:,2*dec+1:end-2*dec) = ...   % ignore border
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd04Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(:,2*dec+1:end-2*dec) = ...   % ignore border
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd04Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(:,6*dec+1:end-6*dec) = ...   % ignore border
                rand(height,width-12*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd04Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(:,6*dec+1:end-6*dec) = ...   % ignore border
                rand(height,width-12*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd04Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd04Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd04Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd04Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd20Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,:) = ...   % ignore border
                rand(height-2*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd20Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,:) = ...   % ignore border
                rand(height-2*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd20Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(3*dec+1:end-3*dec,:) = ...   % ignore border
                rand(height-6*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd20Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(3*dec+1:end-3*dec,:) = ...   % ignore border
                rand(height-6*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd20Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd20Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd20Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd20Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd40Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,:) = ...   % ignore border
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd40Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,:) = ...   % ignore border
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd40Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(6*dec+1:end-6*dec,:) = ...   % ignore border
                rand(height-12*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd40Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(6*dec+1:end-6*dec,:) = ...   % ignore border
                rand(height-12*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd40Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd40Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd40Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd40Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd24Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,2*dec+1:end-2*dec) = ...   % ignore border
                rand(height-2*dec,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd24Level1Rate0_1(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(dec+1:end-dec,2*dec+1:end-2*dec) = ...   % ignore border
                rand(height-2*dec,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd24Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = [2 4];
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(3*dec+1:end-3*dec,6*dec+1:end-6*dec) = ...   % ignore border
                rand(height-6*dec,width-12*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd24Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [2 4];
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(3*dec+1:end-3*dec,6*dec+1:end-6*dec) = ...   % ignore border
                rand(height-6*dec,width-12*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd24Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd24Level1Rate0_1PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd24Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = [2 4];
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd24Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [2 4];
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd42Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,dec+1:end-dec) = ...   % ignore border
                rand(height-4*dec,width-2*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd42Level1Rate0_1(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,dec+1:end-dec) = ...   % ignore border
                rand(height-4*dec,width-2*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd42Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = [4 2];
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(6*dec+1:end-6*dec,3*dec+1:end-3*dec) = ...   % ignore border
                rand(height-12*dec,width-6*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testCoefQuantizerDirLotOrd42Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [4 2];
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(6*dec+1:end-6*dec,3*dec+1:end-3*dec) = ...   % ignore border
                rand(height-12*dec,width-6*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd42Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd42Level1Rate0_1PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = ...
                dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd42Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = [4 2];
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testCoefQuantizerDirLotOrd42Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [4 2];
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            coefsExpctd = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            coefsActual = getdqDirDwtSubbandCoefs(this.dirdwtquantizer);
            
            % Evaluation
            for iSubband = 1:nDecs+3
                subCoefExpctd = coefsExpctd{iSubband};
                subCoefActual = coefsActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd02Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd02Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd02Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(:,7*dec+1:end-7*dec) = ...  % ignore border
                rand(height,width-14*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd02Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(:,7*dec+1:end-7*dec) = ...  % ignore border
                rand(height,width-14*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd02Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd02Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd02Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd02Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd04Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd04Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd04Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(:,15*dec+1:end-15*dec) = ...  % ignore border
                rand(height,width-30*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd04Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(:,15*dec+1:end-15*dec) = ...  % ignore border
                rand(height,width-30*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd04Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd04Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd04Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd04Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd20Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd20Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd20Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(7*dec+1:end-7*dec,:) = ...  % ignore border
                rand(height-14*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd20Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 32;
            width = 32;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(7*dec+1:end-7*dec,:) = ...  % ignore border
                rand(height-14*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd20Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd20Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd20Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd20Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd40Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd40Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 32;
            width = 32;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd40Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(15*dec+1:end-15*dec,:) = ...  % ignore border
                rand(height-30*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd40Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(15*dec+1:end-15*dec,:) = ...  % ignore border
                rand(height-30*dec,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd40Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd40Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 1;
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
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd40Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd40Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd24Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = [2 4];
            height = 32;
            width = 32;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height-4*dec,width-8*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd24Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [2 4];
            height = 32;
            width = 32;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(2*dec+1:end-2*dec,4*dec+1:end-4*dec) = ...  % ignore border
                rand(height-4*dec,width-8*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd24Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = [2 4];
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(7*dec+1:end-7*dec,15*dec+1:end-15*dec) = ...  % ignore border
                rand(height-14*dec,width-30*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd24Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [2 4];
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(7*dec+1:end-7*dec,15*dec+1:end-15*dec) = ...  % ignore border
                rand(height-14*dec,width-30*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd24Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd24Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd24Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd24Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd42Level1Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = [4 2];
            height = 32;
            width = 32;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,2*dec+1:end-2*dec) = ...  % ignore border
                rand(height-8*dec,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd42Level1Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [4 2];
            height = 32;
            width = 32;
            nLevels = 1;
            srcImg = zeros(height,width);
            srcImg(4*dec+1:end-4*dec,2*dec+1:end-2*dec) = ...  % ignore border
                rand(height-8*dec,width-4*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd42Level2Rate0_2(this)
            
            aveRate = .2;
            dec = 2;
            ord = [4 2];
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(15*dec+1:end-15*dec,7*dec+1:end-7*dec) = ...  % ignore border
                rand(height-30*dec,width-14*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd42Level2Rate1_0(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [4 2];
            height = 64;
            width = 64;
            nLevels = 2;
            srcImg = zeros(height,width);
            srcImg(15*dec+1:end-15*dec,7*dec+1:end-7*dec) = ...  % ignore border
                rand(height-30*dec,width-14*dec);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate);
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd42Level1Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd42Level1Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nLevels = 1;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expcted values
            % Forward transform
            nDecs = dec*dec;
            subbandCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subbandCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(dQsubbandCoefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd42Level2Rate0_2PeriodicExt(this)
            
            aveRate = .2;
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = ...
                testDirectionalDwtQuantizerDirLotOrd42Level2Rate1_0PeriodicExt(this)
            
            aveRate = 1.0;
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nLevels = 2;
            srcImg = rand(height,width);
            
            % Preparation
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(this.lppufb);
            angs = randn(size(angs));
            this.lppufb = setAngles(this.lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            level1Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            level2Coefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2Coefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1Coefs{1},...
                    this.lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            subbandCoefs = [level2Coefs;
                level1Coefs{2};
                level1Coefs{3};
                level1Coefs{4}];
            % Quantization
            this.ecsQdq = EcsQuantizerDeQuantizer(subbandCoefs);
            dQsubbandCoefs = getDeQuantizedCoefs(this.ecsQdq,aveRate);
            % Inverse transform
            level2Coefs = cell(nDecs,1);
            level2Coefs{1} = dQsubbandCoefs{1};
            level2Coefs{2} = dQsubbandCoefs{2};
            level2Coefs{3} = dQsubbandCoefs{3};
            level2Coefs{4} = dQsubbandCoefs{4};
            level1Coefs = cell(nDecs,1);
            level1Coefs{1} = zeros(height/dec,width/dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1Coef = imfilter(...
                    upsample(...
                    upsample(level2Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                level1Coefs{1} = level1Coefs{1} + level1Coef;
            end
            level1Coefs{2} = dQsubbandCoefs{5};
            level1Coefs{3} = dQsubbandCoefs{6};
            level1Coefs{4} = dQsubbandCoefs{7};
            imgExpctd = zeros(height,width);
            for iSubband = 1:nDecs
                subbandImgExpctd = imfilter(...
                    upsample(...
                    upsample(level1Coefs{iSubband}.',dec,phase).',...
                    dec,phase),this.lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + subbandImgExpctd;
            end
            
            % Instantiation of target class
            this.dirdwtquantizer = DirectionalDwtQuantizer(...
                this.lppufb,aveRate,'circular');
            
            % Actual values
            this.dirdwtquantizer = dirDwtQuantize(this.dirdwtquantizer,srcImg,nLevels);
            imgActual = getImg(this.dirdwtquantizer);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
    end
end
