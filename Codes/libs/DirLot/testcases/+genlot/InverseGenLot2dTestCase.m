classdef InverseGenLot2dTestCase < TestCase
    %INVERSEGENLOT2DTESTCASE Test case for InverseGenLot2d
    %
    % SVN identifier:
    % $Id: InverseGenLot2dTestCase.m 249 2011-11-27 01:55:42Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit_2008a
    %
    % Copyright (c) 2011, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties
        igenlot
    end
    
    methods
    
        function this = tearDown(this)
            delete(this.igenlot);
        end
          
        % Test for default construction
        function this = testInverseBlockDct(this)
            
            dec = 4;
            height = 16;
            width = 16;
            subCoefs  = rand(height,width);
            
            % Expected values
            P = [ 1 0 0 0 ; 0 0 1 0 ; 0 1 0 0 ; 0 0 0 1];
            fun = @(x) idct2(P.'*x*P);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot2d();
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
                % Test for default construction
        function this = testInverseBlockDctNaturalOrder(this)
            
            dec = 4;
            height = 16;
            width = 16;
            subCoefs  = rand(height,width);
            
            % Expected values
            fun = @(x) idct2(x);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot2d();
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        
        % Test for dec=8
        function this = testInverseBlockDctDec8(this)
            
            dec = 8;
            height = 32;
            width = 32;
            subCoefs  = rand(height,width);
            vm = 0;
            
            % Expected values
            I = eye(dec);
            P = [ downsample(I,2,0); downsample(I,2,1) ];
            fun = @(x) idct2(P.'*x*P);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            this.igenlot = InverseGenLot2d(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end    
        
                % Test for dec=8
        function this = testInverseBlockDctDec8NaturalOrder(this)
            
            dec = 8;
            height = 32;
            width = 32;
            subCoefs  = rand(height,width);
            vm = 0;
            
            % Expected values
            fun = @(x) idct2(x);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            this.igenlot = InverseGenLot2d(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end  
        
        % Test for cell, dec=4, ord=0
        function this = testInverseBlockWithCellDec4Ord0(this)
            
            dec = 4;
            height = 16;
            width = 16;
            ord = 0;
            vm = 0;
            
            % Preparation
            subCoefs = rand(height,width);
            subCoefCell = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    subCoefCell{iSubband,jSubband} = ...
                        subCoefs(iSubband:dec:end,jSubband:dec:end);
                end
            end
              
            % Expected values
            I = eye(dec);
            P = [ downsample(I,2,0); downsample(I,2,1) ];
            fun = @(x) idct2(P.'*x*P);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            this.igenlot = InverseGenLot2d(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefCell);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end    
        
        % Test for cell, dec=8, ord=0
        function this = testInverseBlockWithCellDec8Ord0(this)
            
            dec = 8;
            height = 32;
            width = 32;
            ord = 0;
            vm = 0;
            
            % Preparation
            subCoefs = rand(height,width);
            subCoefCell = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    subCoefCell{iSubband,jSubband} = ...
                        subCoefs(iSubband:dec:end,jSubband:dec:end);
                end
            end
              
            % Expected values
            I = eye(dec);
            P = [ downsample(I,2,0); downsample(I,2,1) ];
            fun = @(x) idct2(P.'*x*P);
            imgExpctd = myblkproc(subCoefs,[dec dec],fun);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            this.igenlot = InverseGenLot2d(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefCell);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end 
        
        % Test for cell, dec=4, ord=2
        function this = testInverseBlockWithCellDec4Ord2(this)
            
            dec = 4;
            height = 16;
            width = 16;
            ord = 2;
            vm = 2;
            
            % Preparation
            subCoefs = rand(height,width);
            subCoefCell = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    subCoefCell{iSubband,jSubband} = ...
                        subCoefs(iSubband:dec:end,jSubband:dec:end);
                end
            end
              
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric-ymmetric extension
                fi = lppufb(iSubband);
                for jSubband = 1:dec/2 
                    fj = lppufb(jSubband);
                    tmp = padarray(subCoefCell{iSubband,jSubband},...
                        [ord/2 ord/2],'symmetric');
                    tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                    tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                    imgExpctd = imgExpctd + ...
                        tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end
            for iSubband = dec/2+1:dec % Antisymmetric-symmetric extension
                fi = lppufb(iSubband);
                for jSubband = 1:dec/2
                    fj = lppufb(jSubband);
                tmp = padarray(subCoefCell{iSubband,jSubband},...
                    [ord/2 ord/2],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end
            for iSubband = 1:dec/2 % Symmetric-antisymmetric extension
                fi = lppufb(iSubband);
                for jSubband = dec/2+1:dec 
                    fj = lppufb(jSubband);
                tmp = padarray(subCoefCell{iSubband,jSubband},...
                    [ord/2 ord/2],'symmetric');
                tmp(:,1:ord/2) = -tmp(:,1:ord/2);
                tmp(:,end-(ord/2-1):end) = -tmp(:,end-(ord/2-1):end);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end            
            for iSubband = dec/2+1:dec % Antsymmetric-antisymmetric extension
                fi = lppufb(iSubband);
                for jSubband = dec/2+1:dec 
                    fj = lppufb(jSubband);
                tmp = padarray(subCoefCell{iSubband,jSubband},...
                    [ord/2 ord/2],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);                
                tmp(:,1:ord/2) = -tmp(:,1:ord/2);
                tmp(:,end-(ord/2-1):end) = -tmp(:,end-(ord/2-1):end);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end                        
            
            % Instantiation of target class
            this.igenlot = InverseGenLot2d(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefCell);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end    
        
        % Test for cell, dec=4, ord=2
        function this = testInverseBlockWithCellDec4Ord4(this)
            
            dec = 4;
            height = 32;
            width = 32;
            ord = 4;
            vm = 2;
            
            % Preparation
            subCoefs = rand(height,width);
            subCoefCell = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    subCoefCell{iSubband,jSubband} = ...
                        subCoefs(iSubband:dec:end,jSubband:dec:end);
                end
            end
              
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angls = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angls)));
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric-ymmetric extension
                fi = lppufb(iSubband);
                for jSubband = 1:dec/2 
                    fj = lppufb(jSubband);
                    tmp = padarray(subCoefCell{iSubband,jSubband},...
                        [ord/2 ord/2],'symmetric');
                    tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                    tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                    imgExpctd = imgExpctd + ...
                        tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end
            for iSubband = dec/2+1:dec % Antisymmetric-symmetric extension
                fi = lppufb(iSubband);
                for jSubband = 1:dec/2
                    fj = lppufb(jSubband);
                tmp = padarray(subCoefCell{iSubband,jSubband},...
                    [ord/2 ord/2],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end
            for iSubband = 1:dec/2 % Symmetric-antisymmetric extension
                fi = lppufb(iSubband);
                for jSubband = dec/2+1:dec 
                    fj = lppufb(jSubband);
                tmp = padarray(subCoefCell{iSubband,jSubband},...
                    [ord/2 ord/2],'symmetric');
                tmp(:,1:ord/2) = -tmp(:,1:ord/2);
                tmp(:,end-(ord/2-1):end) = -tmp(:,end-(ord/2-1):end);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end            
            for iSubband = dec/2+1:dec % Antsymmetric-antisymmetric extension
                fi = lppufb(iSubband);
                for jSubband = dec/2+1:dec 
                    fj = lppufb(jSubband);
                tmp = padarray(subCoefCell{iSubband,jSubband},...
                    [ord/2 ord/2],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);                
                tmp(:,1:ord/2) = -tmp(:,1:ord/2);
                tmp(:,end-(ord/2-1):end) = -tmp(:,end-(ord/2-1):end);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end                        
            
            % Instantiation of target class
            this.igenlot = InverseGenLot2d(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefCell);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end  
        
        % Test for cell, dec=8, ord=2
        function this = testInverseBlockWithCellDec8Ord2(this)
            
            dec = 8;
            height = 32;
            width = 32;
            ord = 2;
            vm = 2;
            
            % Preparation
            subCoefs = rand(height,width);
            subCoefCell = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    subCoefCell{iSubband,jSubband} = ...
                        subCoefs(iSubband:dec:end,jSubband:dec:end);
                end
            end
              
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric-ymmetric extension
                fi = lppufb(iSubband);
                for jSubband = 1:dec/2 
                    fj = lppufb(jSubband);
                    tmp = padarray(subCoefCell{iSubband,jSubband},...
                        [ord/2 ord/2],'symmetric');
                    tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                    tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                    imgExpctd = imgExpctd + ...
                        tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end
            for iSubband = dec/2+1:dec % Antisymmetric-symmetric extension
                fi = lppufb(iSubband);
                for jSubband = 1:dec/2
                    fj = lppufb(jSubband);
                tmp = padarray(subCoefCell{iSubband,jSubband},...
                    [ord/2 ord/2],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end
            for iSubband = 1:dec/2 % Symmetric-antisymmetric extension
                fi = lppufb(iSubband);
                for jSubband = dec/2+1:dec 
                    fj = lppufb(jSubband);
                tmp = padarray(subCoefCell{iSubband,jSubband},...
                    [ord/2 ord/2],'symmetric');
                tmp(:,1:ord/2) = -tmp(:,1:ord/2);
                tmp(:,end-(ord/2-1):end) = -tmp(:,end-(ord/2-1):end);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end            
            for iSubband = dec/2+1:dec % Antsymmetric-antisymmetric extension
                fi = lppufb(iSubband);
                for jSubband = dec/2+1:dec 
                    fj = lppufb(jSubband);
                tmp = padarray(subCoefCell{iSubband,jSubband},...
                    [ord/2 ord/2],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);                
                tmp(:,1:ord/2) = -tmp(:,1:ord/2);
                tmp(:,end-(ord/2-1):end) = -tmp(:,end-(ord/2-1):end);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                tmp = imfilter(upsample(tmp.',dec),fj(:),'corr','full').';
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,ord*dec+1:ord*dec+width);
                end
            end  
            
            % Instantiation of target class
            this.igenlot = InverseGenLot2d(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefCell);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for cell, dec=4, ord=2, periodic extension
        function this = testInverseBlockWithCellDec4Ord2PeriodicExt(this)
            
            dec = 4;
            height = 16;
            width = 16;
            ord = 2;
            vm = 2;
            
            % Preparation
            subCoefs = rand(height,width);
            subCoefCell = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    subCoefCell{iSubband,jSubband} = ...
                        subCoefs(iSubband:dec:end,jSubband:dec:end);
                end
            end
              
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            imgExpctd = 0;
            for iSubband = 1:dec % Periodic extension
                fi = lppufb(iSubband);
                for jSubband = 1:dec 
                    fj = lppufb(jSubband);
                    tmp = subCoefCell{iSubband,jSubband};
                    tmp = imfilter(upsample(tmp,dec,dec/2),fi(:),'circular');
                    tmp = imfilter(upsample(tmp.',dec,dec/2),fj(:),'circular').';
                    imgExpctd = imgExpctd + tmp;
                end
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot2d(lppufb,'circular');
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefCell);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end   
        
        % Test for cell, dec=4, ord=4, periodic extension
        function this = testInverseBlockWithCellDec4Ord4PeriodicExt(this)
            
            dec = 4;
            height = 32;
            width = 32;
            ord = 4;
            vm = 2;
            
            % Preparation
            subCoefs = rand(height,width);
            subCoefCell = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    subCoefCell{iSubband,jSubband} = ...
                        subCoefs(iSubband:dec:end,jSubband:dec:end);
                end
            end
              
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angls = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angls)));
            imgExpctd = 0;
            for iSubband = 1:dec % Periodic extension
                fi = lppufb(iSubband);
                for jSubband = 1:dec 
                    fj = lppufb(jSubband);
                    tmp = subCoefCell{iSubband,jSubband};
                    tmp = imfilter(upsample(tmp,dec,dec/2),fi(:),'circular');
                    tmp = imfilter(upsample(tmp.',dec,dec/2),fj(:),'circular').';
                    imgExpctd = imgExpctd + tmp;
                end
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot2d(lppufb,'circular');
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefCell);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for cell, dec=8, ord=2, perodic extension
        function this = testInverseBlockWithCellDec8Ord2PeriodicExt(this)
            
            dec = 8;
            height = 32;
            width = 32;
            ord = 2;
            vm = 2;
            
            % Preparation
            subCoefs = rand(height,width);
            subCoefCell = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    subCoefCell{iSubband,jSubband} = ...
                        subCoefs(iSubband:dec:end,jSubband:dec:end);
                end
            end
              
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            imgExpctd = 0;
           for iSubband = 1:dec % Periodic extension
                fi = lppufb(iSubband);
                for jSubband = 1:dec 
                    fj = lppufb(jSubband);
                    tmp = subCoefCell{iSubband,jSubband};
                    tmp = imfilter(upsample(tmp,dec,dec/2),fi(:),'circular');
                    tmp = imfilter(upsample(tmp.',dec,dec/2),fj(:),'circular').';
                    imgExpctd = imgExpctd + tmp;
                end
            end  
            
            % Instantiation of target class
            this.igenlot = InverseGenLot2d(lppufb,'circular');
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefCell);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
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
