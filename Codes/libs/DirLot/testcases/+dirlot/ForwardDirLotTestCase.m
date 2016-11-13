classdef ForwardDirLotTestCase < TestCase
    %FORWARDDIRLOTTESTCASE Test case for ForwardDirLot
    %
    % SVN identifier:
    % $Id: ForwardDirLotTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        fdirlot
    end
    
    methods
       
        function this = tearDown(this)
            delete(this.fdirlot);
        end
        % Test for default construction
        function this = testForwardBlockDct(this)
            
            dec = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected values
            lppufb = LpPuFb2dFactory.createLpPuFb2d();
            E0 = double(lppufb);
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot();
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getCoefs(this.fdirlot);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testForwardBlockDctDec44(this)
            
            dec = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Expected values
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);
            E0 = double(lppufb);
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec]);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getCoefs(this.fdirlot);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testForwardDirLotOrd00(this)
            
            dec = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            E = double(lppufb);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            fun = @(x) reshape(E*flipud(x(:)),dec,dec);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getCoefs(this.fdirlot);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testForwardDirLotOrd00Dec44(this)
            
            dec = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            E = double(lppufb);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            fun = @(x) reshape(E*flipud(x(:)),dec,dec);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getCoefs(this.fdirlot);
            
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testForwardDirLotOrd22(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(2:end-1,2:end-1); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(2:end-1,2:end-1); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test for default construction
        function this = testForwardDirLotOrd22PeriodicExt(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test for default construction
        function this = testForwardDirLotOrd22Dec44(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(2:end-1,2:end-1); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(2:end-1,2:end-1); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test for default construction
        function this = testForwardDirLotOrd22Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test for forward Block Dct with termination
        function this = testForwardBlockDctOrd22(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = myblkproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefExpctd{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test for forward Block Dct with termination (4x4)
        function this = testForwardBlockDctOrd22Dec44(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = myblkproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefExpctd{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testWaveDec2Ord00Level1(this)
            
            dec = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            nLevels = 1;
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            %             wname = 'haar';
            %             [Lo_D Hi_D] = wfilters(wname,'d');
            %             [coefsExpctd sizeExpctd] = wavedec2(srcImg,nLevels,Lo_D,Hi_D);
            fun = @(x) dct2(x);
            coefs = myblkproc(srcImg,[dec dec],fun);
            level1subCoef1 = coefs(1:dec:end,1:dec:end);
            level1subCoef2 = coefs(2:dec:end,1:dec:end);
            level1subCoef3 = coefs(1:dec:end,2:dec:end);
            level1subCoef4 = coefs(2:dec:end,2:dec:end);
            coefsExpctd = ...
                [level1subCoef1(:).' level1subCoef2(:).'...
                level1subCoef3(:).' level1subCoef4(:).'];
            sizeExpctd = [ 8  8;
                8  8;
                16 16];
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            [coefsActual sizeActual] = wavedec2(this.fdirlot,srcImg,nLevels);
            
            % Evaluation
            diffCoefs = norm(coefsExpctd - coefsActual)/numel(coefsExpctd);
            this.assert(diffCoefs<1e-15,sprintf('C:%g',diffCoefs));
            diffSize = norm(sizeExpctd - sizeActual);
            this.assert(diffSize<1e-15,sprintf('S:%d',diffSize));
            
        end
        
        % Test
        function this = testWaveDec2Ord00Level2(this)
            
            dec = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            nLevels = 2;
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            %             wname = 'haar';
            %             [Lo_D Hi_D] = wfilters(wname,'d');
            %             [coefsExpctd sizeExpctd] = wavedec2(srcImg,nLevels,Lo_D,Hi_D);
            fun = @(x) dct2(x);
            coefs = myblkproc(srcImg,[dec dec],fun);
            level1subCoef1 = coefs(1:dec:end,1:dec:end);
            level1subCoef2 = coefs(2:dec:end,1:dec:end);
            level1subCoef3 = coefs(1:dec:end,2:dec:end);
            level1subCoef4 = coefs(2:dec:end,2:dec:end);
            coefsExpctd = ...
                [level1subCoef2(:).' ...
                level1subCoef3(:).' level1subCoef4(:).'];
            coefs = myblkproc(level1subCoef1,[dec dec],fun);
            level2subCoef1 = coefs(1:dec:end,1:dec:end);
            level2subCoef2 = coefs(2:dec:end,1:dec:end);
            level2subCoef3 = coefs(1:dec:end,2:dec:end);
            level2subCoef4 = coefs(2:dec:end,2:dec:end);
            coefsExpctd = ...
                [level2subCoef1(:).' level2subCoef2(:).'...
                level2subCoef3(:).' level2subCoef4(:).' coefsExpctd];
            sizeExpctd = [ 4  4;
                4  4;
                8  8;
                16 16];
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            [coefsActual sizeActual] = wavedec2(this.fdirlot,srcImg,nLevels);
            
            % Evaluation
            diffCoefs = norm(coefsExpctd - coefsActual)/numel(coefsExpctd);
            this.assert(diffCoefs<1e-15,sprintf('C:%g',diffCoefs));
            diffSize = norm(sizeExpctd - sizeActual);
            this.assert(diffSize<1e-15,sprintf('S:%d',diffSize));
            
        end
        
        % Test
        function this = testWaveDec2Ord22Level1(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = zeros(height,width);
            srcImg(dec+1:height-dec,dec+1:width-dec) = ...  % ignore border
                rand(height-2*dec,width-2*dec);
            nLevels = 1;
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1subCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            coefsExpctd = ...
                [level1subCoefs{1}(:).' level1subCoefs{3}(:).' ...
                level1subCoefs{4}(:).' level1subCoefs{2}(:).'];
            sizeExpctd = [ 8  8;
                8  8;
                16 16];
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            [coefsActual sizeActual] = wavedec2(this.fdirlot,srcImg,nLevels);
            
            % Evaluation
            diffCoefs = norm(coefsExpctd - coefsActual)/numel(coefsExpctd);
            this.assert(diffCoefs<1e-15,sprintf('C:%g',diffCoefs));
            diffSize = norm(sizeExpctd - sizeActual);
            this.assert(diffSize<1e-15,sprintf('S:%d',diffSize));
            
        end
        
        % Test
        function this = testWaveDec2Ord22Level2(this)
            
            dec = 2;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = zeros(height,width);
            srcImg(3*dec+1:height-3*dec,3*dec+1:width-3*dec) = ...  % ignore border
                rand(height-6*dec,width-6*dec);
            nLevels = 2;
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level1subCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,...
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            coefsExpctd = ...
                [level1subCoefs{3}(:).' ...
                level1subCoefs{4}(:).' level1subCoefs{2}(:).'];
            level2subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                level2subCoefs{iSubband} = downsample(...
                    downsample(...
                    imfilter(level1subCoefs{1},...
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            coefsExpctd = ...
                [level2subCoefs{1}(:).' level2subCoefs{3}(:).' ...
                level2subCoefs{4}(:).' level2subCoefs{2}(:).' coefsExpctd];
            sizeExpctd = [ ...
                8  8;
                8  8;
                16 16;
                32 32];
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            [coefsActual sizeActual] = wavedec2(this.fdirlot,srcImg,nLevels);
            
            % Evaluation
            diffCoefs = norm(coefsExpctd - coefsActual)/numel(coefsExpctd);
            this.assert(diffCoefs<1e-15,sprintf('C:%g',diffCoefs));
            diffSize = norm(sizeExpctd - sizeActual);
            this.assert(diffSize<1e-15,sprintf('S:%d',diffSize));
            
        end
        
        % Test
        function this = testForwardDirLotOrd44(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(3:end-2,3:end-2); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(3:end-2,3:end-2); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd44Dec44(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(3:end-2,3:end-2); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(3:end-2,3:end-2); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardBlockDctOrd44(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = myblkproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefExpctd{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardBlockDctOrd44Dec44(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = myblkproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefExpctd{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd66(this)
            
            dec = 2;
            ord = 6;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(4:end-3,4:end-3); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(4:end-3,4:end-3); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        
        % Test
        function this = testForwardDirLotOrd66PeriodicExt(this)
            
            dec = 2;
            ord = 6;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd66Dec44(this)
            
            dec = 4;
            ord = 6;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(4:end-3,4:end-3); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(4:end-3,4:end-3); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd66Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 6;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardBlockDctOrd66(this)
            
            dec = 2;
            ord = 6;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = myblkproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefExpctd{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardBlockDctOrd66Dec44(this)
            
            dec = 4;
            ord = 6;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(E0*flipud(x(:)),dec,dec);
            dctCoefs = myblkproc(srcImg,[dec dec],fun);
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iCol=1:dec
                for iRow=1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefExpctd{iSubband} = downsample(...
                        downsample(dctCoefs.',dec,iCol-1).',dec,iRow-1);
                end
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot([dec dec],paramMtx);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd02(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(:,2:end-1); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(:,2:end-1); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd02Dec44(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(:,2:end-1); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(:,2:end-1); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd04(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(:,3:end-2); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(:,3:end-2); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd04Dec44(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(:,3:end-2); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(:,3:end-2); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd20(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(2:end-1,:); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(2:end-1,:); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd20Dec44(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(2:end-1,:); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(2:end-1,:); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd40(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(3:end-2,:); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(3:end-2,:); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd40Dec44(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(3:end-2,:); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(3:end-2,:); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd02PeriodicExt(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd02Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd04PeriodicExt(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd04Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd20PeriodicExt(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd20Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd40PeriodicExt(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd40Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd24(this)
            
            dec = 2;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(2:end-1,3:end-2); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(2:end-1,3:end-2); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd24Dec44(this)
            
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(2:end-1,3:end-2); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(2:end-1,3:end-2); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd24PeriodicExt(this)
            
            dec = 2;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd24Dec44PeriodicExt(this)
            
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd42(this)
            
            dec = 2;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(3:end-2,2:end-1); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(3:end-2,2:end-1); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd42Dec44(this)
            
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb);
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefExpctd = subCoefExpctd(3:end-2,2:end-1); % ignore border
                subCoefActual = coefActual{iSubband};
                subCoefActual = subCoefActual(3:end-2,2:end-1); % ignore border
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd42PeriodicExt(this)
            
            dec = 2;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec).',dec);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test
        function this = testForwardDirLotOrd42Dec44PeriodicExt(this)
            
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            nDecs = dec*dec;
            phase = 1; % for phase adjustment required experimentaly
            coefExpctd = cell(nDecs,1);
            for iSubband = 1:nDecs
                coefExpctd{iSubband} = downsample(...
                    downsample(...
                    imfilter(srcImg,... %
                    lppufb(iSubband),...
                    'conv','circ').',dec,phase).',dec,phase);
            end
            
            % Instantiation of target class
            this.fdirlot = ForwardDirLot(lppufb,'circular');
            
            % Actual values
            this.fdirlot = forwardTransform(this.fdirlot,srcImg);
            coefActual = getSubbandCoefs(this.fdirlot);
            
            % Evaluation
            for iSubband=1:nDecs
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-15,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
    end
    
end

function value = myblkproc(varargin)
if exist('blockproc','file') == 2
    fun = @(x) varargin{end}(x.data);
    varargin{end} = fun;
    value = blockproc(varargin{:});
else
    value = blkproc(varargin{:});
end
end

