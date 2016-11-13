classdef InverseDirLotTestCase < TestCase
    %INVERSEDIRLOTTESTCASE Test case for InverseDirLot
    %
    % SVN identifier:
    % $Id: InverseDirLotTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        idirlot
    end
    
    methods
            
        function this = tearDown(this)
            delete(this.idirlot);
        end
        
        % Test for default construction
        function this = testInverseBlockDct(this)
            
            dec = 2;
            height = 16;
            width = 16;
            subCoefs  = rand(height,width);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot();
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testInverseBlockDctDec44(this)
            
            dec = 4;
            height = 32;
            width = 32;
            subCoefs = rand(height,width);
            
            % Expected values
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec]);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testInverseDirLotOrd00(this)
            
            dec = 2;
            height = 16;
            width = 16;
            subCoefs = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d();
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            E = double(lppufb);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            fun = @(x) reshape(flipud(E.'*x(:)),dec,dec);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testInverseDirLotOrd00Dec44(this)
            
            dec = 4;
            height = 32;
            width = 32;
            subCoefs = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            E = double(lppufb);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            fun = @(x) reshape(flipud(E.'*x(:)),dec,dec);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testInverseDirLotOrd22(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(dec+1:end-dec,dec+1:end-dec); % ignore border
            imgActual = imgActual(dec+1:end-dec,dec+1:end-dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd22PeriodicExt(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd22Dec44(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(dec+1:end-dec,dec+1:end-dec); % ignore border
            imgActual = imgActual(dec+1:end-dec,dec+1:end-dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd22Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test for boundary operation
        function this = testInverseBlockDctOrd22(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb =LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            coefsExpctd = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefsExpctd = coefsExpctd + upsample(...
                        upsample(...
                        subCoefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = myblkproc(coefsExpctd,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test for boundary operation
        function this = testInverseBlockDctOrd22Dec44(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            coefsExpctd = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefsExpctd = coefsExpctd + upsample(...
                        upsample(...
                        subCoefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = myblkproc(coefsExpctd,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testWaveRec2Ord00Level1(this)
            
            dec = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            subCoefs = rand(1,height*width);
            subCoefsSize = zeros(nLevels+2,2);
            subCoefsSize(1,:) = [ 8  8];
            subCoefsSize(2,:) = [ 8  8];
            subCoefsSize(3,:) = [16 16];
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            %             wname = 'haar';
            %             [Lo_D Hi_D] = wfilters(wname,'r');
            %             ImgExpctd = waverec2(subCoefs,subCoefsSize,Lo_D,Hi_D);
            level1Row = subCoefsSize(2,1);
            level1Col = subCoefsSize(2,2);
            level1coef = zeros(level1Row*dec,level1Col*dec);
            level1coef(1:dec:end,1:dec:end) = reshape(...
                subCoefs(1:level1Row*level1Col),...
                level1Row,level1Col);
            level1coef(2:dec:end,1:dec:end) = reshape(...
                subCoefs(level1Row*level1Col+1:level1Row*level1Col*2),...
                level1Row,level1Col);
            level1coef(1:dec:end,2:dec:end) = reshape(...
                subCoefs(level1Row*level1Col*2+1:level1Row*level1Col*3),...
                level1Row,level1Col);
            level1coef(2:dec:end,2:dec:end) = reshape(...
                subCoefs(level1Row*level1Col*3+1:level1Row*level1Col*4),...
                level1Row,level1Col);
            fun = @(x) idct2(x);
            ImgExpctd = myblkproc(level1coef,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            ImgActual = waverec2(this.idirlot,subCoefs,subCoefsSize);
            
            % Evaluation
            diff = norm(ImgExpctd(:) - ImgActual(:))/numel(ImgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testWaveRec2Ord00level2(this)
            
            dec = 2;
            height = 16;
            width = 16;
            nLevels = 2;
            subCoefs = rand(1,height*width);
            subCoefsSize = zeros(nLevels+2,2);
            subCoefsSize(1,:) = [ 4  4];
            subCoefsSize(2,:) = [ 4  4];
            subCoefsSize(3,:) = [ 8  8];
            subCoefsSize(4,:) = [16 16];
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            %             wname = 'haar';
            %             [Lo_D Hi_D] = wfilters(wname,'r');
            %             ImgExpctd = waverec2(subCoefs,subCoefsSize,Lo_D,Hi_D);
            level2Row = subCoefsSize(2,1);
            level2Col = subCoefsSize(2,2);
            level2coef = zeros(level2Row*dec,level2Col*dec);
            level2coef(1:dec:end,1:dec:end) = reshape(...
                subCoefs(1:level2Row*level2Col),...
                level2Row,level2Col);
            level2coef(2:dec:end,1:dec:end) = reshape(...
                subCoefs(level2Row*level2Col+1:level2Row*level2Col*2),...
                level2Row,level2Col);
            level2coef(1:dec:end,2:dec:end) = reshape(...
                subCoefs(level2Row*level2Col*2+1:level2Row*level2Col*3),...
                level2Row,level2Col);
            level2coef(2:dec:end,2:dec:end) = reshape(...
                subCoefs(level2Row*level2Col*3+1:level2Row*level2Col*4),...
                level2Row,level2Col);
            fun = @(x) idct2(x);
            level2coef = myblkproc(level2coef,[dec dec],fun);
            level2subCoefs = [level2coef(:).' subCoefs(level2Row*level2Col*4+1:end)];
            level1Row = subCoefsSize(3,1);
            level1Col = subCoefsSize(3,2);
            level1coef = zeros(level1Row*dec,level1Col*dec);
            level1coef(1:dec:end,1:dec:end) = reshape(...
                level2subCoefs(1:level1Row*level1Col),...
                level1Row,level1Col);
            level1coef(2:dec:end,1:dec:end) = reshape(...
                level2subCoefs(level1Row*level1Col+1:level1Row*level1Col*2),...
                level1Row,level1Col);
            level1coef(1:dec:end,2:dec:end) = reshape(...
                level2subCoefs(level1Row*level1Col*2+1:level1Row*level1Col*3),...
                level1Row,level1Col);
            level1coef(2:dec:end,2:dec:end) = reshape(...
                level2subCoefs(level1Row*level1Col*3+1:level1Row*level1Col*4),...
                level1Row,level1Col);
            ImgExpctd = myblkproc(level1coef,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            ImgActual = waverec2(this.idirlot,subCoefs,subCoefsSize);
            
            % Evaluation
            diff = norm(ImgExpctd(:) - ImgActual(:))/numel(ImgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testWaveRec2Ord22Level1(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nLevels = 1;
            subCoefs = rand(1,height*width);
            subCoefsSize = zeros(nLevels+2,2);
            subCoefsSize(1,:) = [ 8  8];
            subCoefsSize(2,:) = [ 8  8];
            subCoefsSize(3,:) = [16 16];
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level1subCoefs = cell(nDecs,1);
            level1Row = subCoefsSize(2,1);
            level1Col = subCoefsSize(2,2);
            level1subCoefs{1} = reshape(...
                subCoefs(1:level1Row*level1Col),...
                level1Row,level1Col);
            level1subCoefs{3} = reshape(...
                subCoefs(level1Row*level1Col+1:level1Row*level1Col*2),...
                level1Row,level1Col);
            level1subCoefs{4} = reshape(...
                subCoefs(level1Row*level1Col*2+1:level1Row*level1Col*3),...
                level1Row,level1Col);
            level1subCoefs{2} = reshape(...
                subCoefs(level1Row*level1Col*3+1:level1Row*level1Col*4),...
                level1Row,level1Col);
            ImgExpctd = zeros(level1Row*dec,level1Col*dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(level1subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                ImgExpctd = ImgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            ImgActual = waverec2(this.idirlot,subCoefs,subCoefsSize);
            
            % Evaluation
            ImgExpctd = ImgExpctd(dec+1:end-dec,dec+1:end-dec); % ignore border
            ImgActual = ImgActual(dec+1:end-dec,dec+1:end-dec); % ignore border
            diff = norm(ImgExpctd(:) - ImgActual(:))/numel(ImgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testWaveRec2Ord22Level2(this)
            
            dec = 2;
            ord = 2;
            height = 32;
            width = 32;
            nLevels = 2;
            subCoefs = rand(1,height*width);
            subCoefsSize = zeros(nLevels+2,2);
            subCoefsSize(1,:) = [ 8  8];
            subCoefsSize(2,:) = [ 8  8];
            subCoefsSize(3,:) = [16 16];
            subCoefsSize(4,:) = [32 32];
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            nDecs = dec*dec;
            level2subCoefs = cell(nDecs,1);
            level2Row = subCoefsSize(2,1);
            level2Col = subCoefsSize(2,2);
            level2subCoefs{1} = reshape(...
                subCoefs(1:level2Row*level2Col),...
                level2Row,level2Col);
            level2subCoefs{3} = reshape(...
                subCoefs(level2Row*level2Col+1:level2Row*level2Col*2),...
                level2Row,level2Col);
            level2subCoefs{4} = reshape(...
                subCoefs(level2Row*level2Col*2+1:level2Row*level2Col*3),...
                level2Row,level2Col);
            level2subCoefs{2} = reshape(...
                subCoefs(level2Row*level2Col*3+1:level2Row*level2Col*4),...
                level2Row,level2Col);
            level2coef = zeros(level2Row*dec,level2Col*dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level2SubbandCoef = imfilter(...
                    upsample(...
                    upsample(level2subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                level2coef = level2coef + level2SubbandCoef;
            end
            level2subCoefs = ...
                [level2coef(:).' subCoefs(level2Row*level2Col*4+1:end)];
            level1subCoefs = cell(nDecs,1);
            level1Row = subCoefsSize(3,1);
            level1Col = subCoefsSize(3,2);
            level1subCoefs{1} = reshape(...
                level2subCoefs(1:level1Row*level1Col),...
                level1Row,level1Col);
            level1subCoefs{3} = reshape(...
                level2subCoefs(level1Row*level1Col+1:level1Row*level1Col*2),...
                level1Row,level1Col);
            level1subCoefs{4} = reshape(...
                level2subCoefs(level1Row*level1Col*2+1:level1Row*level1Col*3),...
                level1Row,level1Col);
            level1subCoefs{2} = reshape(...
                level2subCoefs(level1Row*level1Col*3+1:level1Row*level1Col*4),...
                level1Row,level1Col);
            ImgExpctd = zeros(level1Row*dec,level1Col*dec);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                level1SubbandCoef = imfilter(...
                    upsample(...
                    upsample(level1subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                ImgExpctd = ImgExpctd + level1SubbandCoef;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            ImgActual = waverec2(this.idirlot,subCoefs,subCoefsSize);
            
            % Evaluation
            ImgExpctd = ImgExpctd(3*dec+1:end-3*dec,3*dec+1:end-3*dec); % ignore border
            ImgActual = ImgActual(3*dec+1:end-3*dec,3*dec+1:end-3*dec); % ignore border
            diff = norm(ImgExpctd(:) - ImgActual(:))/numel(ImgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test
        function this = testInverseDirLotOrd44(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(2*dec+1:end-2*dec,2*dec+1:end-2*dec); % ignore border
            imgActual = imgActual(2*dec+1:end-2*dec,2*dec+1:end-2*dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd44PeriodicExt(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd44Dec44(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(2*dec+1:end-2*dec,2*dec+1:end-2*dec); % ignore border
            imgActual = imgActual(2*dec+1:end-2*dec,2*dec+1:end-2*dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd44Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseBlockDctOrd44(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            coefsExpctd = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefsExpctd = coefsExpctd + upsample(...
                        upsample(...
                        subCoefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = myblkproc(coefsExpctd,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test for boundary operation
        function this = testInverseBlockDctOrd44Dec44(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            coefsExpctd = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefsExpctd = coefsExpctd + upsample(...
                        upsample(...
                        subCoefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = myblkproc(coefsExpctd,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd66(this)
            
            dec = 2;
            ord = 6;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(3*dec+1:end-3*dec,3*dec+1:end-3*dec); % ignore border
            imgActual = imgActual(3*dec+1:end-3*dec,3*dec+1:end-3*dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd66PeriodicExt(this)
            
            dec = 2;
            ord = 6;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd66Dec44(this)
            
            dec = 4;
            ord = 6;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(3*dec+1:end-3*dec,3*dec+1:end-3*dec); % ignore border
            imgActual = imgActual(3*dec+1:end-3*dec,3*dec+1:end-3*dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd66Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 6;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        % Test
        function this = testInverseBlockDctOrd66(this)
            
            dec = 2;
            ord = 6;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            coefsExpctd = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefsExpctd = coefsExpctd + upsample(...
                        upsample(...
                        subCoefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            E0 = double(LpPuFb2dFactory.createLpPuFb2d());
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = myblkproc(coefsExpctd,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test for boundary operation
        function this = testInverseBlockDctOrd66Dec44(this)
            
            dec = 4;
            ord = 6;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord ord]);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            coefsExpctd = zeros(height,width);
            for iCol = 1:dec
                for iRow = 1:dec
                    iSubband = (iCol-1)*dec + iRow;
                    coefsExpctd = coefsExpctd + upsample(...
                        upsample(...
                        subCoefs{iSubband}.',dec,iCol-1).',dec,iRow-1);
                end
            end
            E0 = double(LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]));
            fun = @(x) reshape(flipud(E0.'*x(:)),dec,dec);
            imgExpctd = myblkproc(coefsExpctd,[dec dec],fun);
            
            % Instantiation of target class
            this.idirlot = InverseDirLot([dec dec],paramMtx);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd - imgActual)/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd02(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(:,dec+1:end-dec); % ignore border
            imgActual = imgActual(:,dec+1:end-dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd02Dec44(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(:,dec+1:end-dec); % ignore border
            imgActual = imgActual(:,dec+1:end-dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd04(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(:,2*dec+1:end-2*dec); % ignore border
            imgActual = imgActual(:,2*dec+1:end-2*dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd04Dec44(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(:,2*dec+1:end-2*dec); % ignore border
            imgActual = imgActual(:,2*dec+1:end-2*dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd20(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(dec+1:end-dec,:); % ignore border
            imgActual = imgActual(dec+1:end-dec,:); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd20Dec44(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(dec+1:end-dec,:); % ignore border
            imgActual = imgActual(dec+1:end-dec,:); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd40(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(2*dec+1:end-2*dec,:); % ignore border
            imgActual = imgActual(2*dec+1:end-2*dec,:); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd40Dec44(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(2*dec+1:end-2*dec,:); % ignore border
            imgActual = imgActual(2*dec+1:end-2*dec,:); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd02PeriodicExt(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd02Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd04PeriodicExt(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd04Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[0 ord]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd20PeriodicExt(this)
            
            dec = 2;
            ord = 2;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd20Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 2;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd40PeriodicExt(this)
            
            dec = 2;
            ord = 4;
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd40Dec44PeriodicExt(this)
            
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],[ord 0]);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd24(this)
            
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(dec+1:end-dec,2*dec+1:end-2*dec); % ignore border
            imgActual = imgActual(dec+1:end-dec,2*dec+1:end-2*dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd24Dec44(this)
            
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(dec+1:end-dec,2*dec+1:end-2*dec); % ignore border
            imgActual = imgActual(dec+1:end-dec,2*dec+1:end-2*dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd24PeriodicExt(this)
            
            dec = 2;
            ord = [2 4];
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd24Dec44PeriodicExt(this)
            
            dec = 4;
            ord = [2 4];
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd42(this)
            
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(2*dec+1:end-2*dec,dec+1:end-dec); % ignore border
            imgActual = imgActual(2*dec+1:end-2*dec,dec+1:end-dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd42Dec44(this)
            
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb);
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            imgExpctd = imgExpctd(2*dec+1:end-2*dec,dec+1:end-dec); % ignore border
            imgActual = imgActual(2*dec+1:end-2*dec,dec+1:end-dec); % ignore border
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd42PeriodicExt(this)
            
            dec = 2;
            ord = [4 2];
            height = 16;
            width = 16;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 1; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test
        function this = testInverseDirLotOrd42Dec44PeriodicExt(this)
            
            dec = 4;
            ord = [4 2];
            height = 32;
            width = 32;
            nDecs = dec*dec;
            subCoefs = cell(nDecs,1);
            for iSubband = 1:nDecs
                subCoefs{iSubband} = rand(height/dec,width/dec);
            end
            
            % Preparation
            lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec],ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            
            % Expected values
            imgExpctd = zeros(height,width);
            phase = 2; % for phase adjustment required experimentaly
            for iSubband = 1:nDecs
                SubbandImg = imfilter(...
                    upsample(...
                    upsample(subCoefs{iSubband}.',dec,phase).',...
                    dec,phase),lppufb(iSubband),'cir');
                imgExpctd = imgExpctd + SubbandImg;
            end
            
            % Instantiation of target class
            this.idirlot = InverseDirLot(lppufb,'circular');
            
            % Actual values
            this.idirlot = inverseTransform(this.idirlot,subCoefs);
            imgActual = getImage(this.idirlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))...
                /numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
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
