classdef InverseGenLotTestCase < TestCase
    %INVERSEGENLOTTESTCASE Test case for InverseGenLot
    %
    % SVN identifier:
    % $Id: InverseGenLotTestCase.m 249 2011-11-27 01:55:42Z sho $
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
            nSamples = 16;
            subCoefs  = rand(nSamples,1);
            
            % Expected values
            E0 = double(LpPuFb1dFactory.createLpPuFb1d());
            tmp = flipud(E0.'*reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = tmp(:);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot();
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testInverseBlockDctNaturalOrder(this)
            
            dec = 4;
            nSamples = 16;
            subCoefs  = rand(nSamples,1);
            
            % Expected values
            tmp = idct(reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = tmp(:);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot();
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for images
        function this = testInverseBlockDctDec4Img(this)

            dec = 4;
            height = 16;
            width = 4;
            nSamples = height*width;
            vm = 0;
            subCoefs = rand(height,width);
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            E0 = double(lppufb);
            tmp = flipud(E0.'*reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));
        end
        
         % Test for images
        function this = testInverseBlockDctDec4ImgNaturalOrder(this)

            dec = 4;
            height = 16;
            width = 4;
            nSamples = height*width;
            vm = 0;
            subCoefs = rand(height,width);
            
            % Expected values
            tmp = idct(reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));
        end

        % Test for dec=8
        function this = testInverseBlockDctDec8(this)

            dec = 8;
            height = 32;
            width = 1;
            nSamples = height*width;
            vm = 0;
            subCoefs = rand(height,width);
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            E0 = double(lppufb);
            tmp = flipud(E0.'*reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for dec=8
        function this = testInverseBlockDctDec8NaturalOrder(this)

            dec = 8;
            height = 32;
            width = 1;
            nSamples = height*width;
            vm = 0;
            subCoefs = rand(height,width);
            
            % Expected values
            tmp = idct(reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for image, dec=8
        function this = testInverseBlockDctDec8Img(this)

            dec = 8;
            height = 32;
            width = 8;
            nSamples = height*width;
            vm = 0;
            subCoefs = rand(height,width);
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            E0 = double(lppufb);
            tmp = flipud(E0.'*reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));
        end
        
                % Test for image, dec=8
        function this = testInverseBlockDctDec8ImgNaturalOrder(this)

            dec = 8;
            height = 32;
            width = 8;
            nSamples = height*width;
            vm = 0;
            subCoefs = rand(height,width);
            
            % Expected values
            tmp = idct(reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));
        end
        
        % Test for image, dec=4, ord=1
        function this = testInverseBlockDctDec4Ord0Img(this)

            dec = 4;
            ord = 0;
            height = 16;
            width = 4;
            nSamples = height*width;
            vm = 0;
            subCoefs = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            E = double(lppufb);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            tmp = flipud(E.'*reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(dec,paramMtx);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));
        end
        
        % Test for image, dec=8, ord=0
        function this = testInverseBlockDctDec8Ord0Img(this)

            dec = 8;
            ord = 0;
            height = 32;
            width = 8;
            nSamples = height*width;
            vm = 0;
            subCoefs = rand(height,width);
            
            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            E = double(lppufb);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            tmp = flipud(E.'*reshape(subCoefs,dec,nSamples/dec));
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(dec,paramMtx);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));

        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord0(this)

            dec = 4;
            ord = 0;
            nSamples = 16;
            vm = 0;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
               subCoefs{iSubband} = rand(nSamples/dec,1); 
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            E0 = double(lppufb);
            tmp = flipud(E0.'*reshape(cell2mat(subCoefs.').',dec,nSamples/dec));
            
            % Expected values
            imgExpctd = reshape(tmp,nSamples,1);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
                % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord0NaturalOrder(this)

            dec = 4;
            ord = 0;
            nSamples = 16;
            vm = 0;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
               subCoefs{iSubband} = rand(nSamples/dec,1); 
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            tmp = idct(reshape(cell2mat(subCoefs.').',dec,nSamples/dec));
            
            % Expected values
            imgExpctd = reshape(tmp,nSamples,1);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord0Ang(this)

            dec = 4;
            ord = 0;
            nSamples = 16;
            vm = 0;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
               subCoefs{iSubband} = rand(nSamples/dec,1); 
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angs)));
            E = double(lppufb);
            tmp = flipud(E.'*reshape(cell2mat(subCoefs.').',dec,nSamples/dec));
            
            % Expected values
            imgExpctd = reshape(tmp,nSamples,1);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord0Img(this)

            dec = 4;
            ord = 0;
            height = 16;
            width = 16;
            vm = 0;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
               subCoefs{iSubband} = rand(height/dec,width); 
            end
            coefsArray = zeros(height,width);
            for iSubband = 1:dec
                coefsArray(iSubband:dec:end,:) = subCoefs{iSubband};
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            E0 = double(lppufb);
            tmp = flipud(E0.'*reshape(coefsArray,dec,height*width/dec));
            
            % Expected values
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation 
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
           
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord0ImgNaturalOrder(this)

            dec = 4;
            ord = 0;
            height = 16;
            width = 16;
            vm = 0;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
               subCoefs{iSubband} = rand(height/dec,width); 
            end
            coefsArray = zeros(height,width);
            for iSubband = 1:dec
                coefsArray(iSubband:dec:end,:) = subCoefs{iSubband};
            end
            tmp = idct(reshape(coefsArray,dec,height*width/dec));
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            imgExpctd = reshape(tmp,height,width);
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation 
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
           
        end
             
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord2(this)
            
            dec = 4;
            ord = 2;
            nSamples = 16;
            vm = 0;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(nSamples/dec,1);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values 
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+nSamples,:);
            end
            for iSubband = dec/2+1:dec % Antisymmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+nSamples,:);
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord2Vm2(this)
            
            dec = 4;
            ord = 2;
            nSamples = 16;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(nSamples/dec,1);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+nSamples,:);
            end
            for iSubband = dec/2+1:dec % Antisymmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+nSamples,:);
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord2Vm2Ang(this)
            
            dec = 4;
            ord = 2;
            nSamples = 16;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(nSamples/dec,1);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angs)));
            
            % Expected values
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+nSamples,:);
            end
            for iSubband = dec/2+1:dec % Antisymmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+nSamples,:);
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord2Vm2Img(this)
            
            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(height/dec,width);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angs)));
            
            % Expected values
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,:);
            end
            for iSubband = dec/2+1:dec % Antisymmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,:);
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord2Vm2ImgNaturalOrder(this)
            
            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(height/dec,width);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angs)));
            
            % Expected values
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,:);
            end
            for iSubband = dec/2+1:dec % Antisymmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,:);
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            subCoefsNatural{1} = subCoefs{1};
            subCoefsNatural{2} = subCoefs{3};
            subCoefsNatural{3} = subCoefs{2};
            subCoefsNatural{4} = subCoefs{4};
            this.igenlot = inverseTransform(this.igenlot,subCoefsNatural,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord4(this)
            
            dec = 4;
            ord = 4;
            nSamples = 16;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(nSamples/dec,1);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values 
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+nSamples,:);
            end
            for iSubband = dec/2+1:dec % Antisymmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+nSamples,:);
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec8Ord2Img(this)
            
            dec = 8;
            ord = 2;
            height = 32;
            width = 8;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(height/dec,width);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values 
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,:);
            end
            for iSubband = dec/2+1:dec % Antisymmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,:);
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));              
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec8Ord2ImgNaturalOrder(this)
            
            dec = 8;
            ord = 2;
            height = 32;
            width = 8;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(height/dec,width);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values 
            imgExpctd = 0;
            for iSubband = 1:dec/2 % Symmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,:);
            end
            for iSubband = dec/2+1:dec % Antisymmetric extension
                fi = lppufb(iSubband);
                tmp = padarray(subCoefs{iSubband},[ord/2 0],'symmetric');
                tmp(1:ord/2,:) = -tmp(1:ord/2,:);
                tmp(end-(ord/2-1):end,:) = -tmp(end-(ord/2-1):end,:);
                tmp = imfilter(upsample(tmp,dec),fi(:),'corr','full');
                imgExpctd = imgExpctd + ...
                    tmp(ord*dec+1:ord*dec+height,:);
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb);
            
            % Actual values
            subCoefsNatural{1} = subCoefs{1};
            subCoefsNatural{2} = subCoefs{5};
            subCoefsNatural{3} = subCoefs{2};
            subCoefsNatural{4} = subCoefs{6};
            subCoefsNatural{5} = subCoefs{3};
            subCoefsNatural{6} = subCoefs{7};
            subCoefsNatural{7} = subCoefs{4};
            subCoefsNatural{8} = subCoefs{8};
            this.igenlot = inverseTransform(this.igenlot,subCoefsNatural,'natural');
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));              
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord2Vm2ImgPeriodicExt(this)
            
            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(height/dec,width);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angs)));
            
            % Expected values
            imgExpctd = 0;
            for iSubband = 1:dec % Periodic extension
                fi = lppufb(iSubband);
                tmp = subCoefs{iSubband};
                tmp = imfilter(upsample(tmp,dec,dec/2),fi(:),'corr','circ');
                imgExpctd = imgExpctd + tmp;
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb,'circular');
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec4Ord4Vm2ImgPeriodicExt(this)
            
            dec = 4;
            ord = 4;
            height = 16;
            width = 16;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(height/dec,width);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angs)));
            
            % Expected values
            imgExpctd = 0;
            for iSubband = 1:dec % Periodic extension
                fi = lppufb(iSubband);
                tmp = subCoefs{iSubband};
                tmp = imfilter(upsample(tmp,dec,dec/2),fi(:),'corr','circ');
                imgExpctd = imgExpctd + tmp;
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb,'circular');
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for coefs in cell
        function this = testInverseTransformWithCellDec8Ord2Vm2ImgPeriodicExt(this)
            
            dec = 8;
            ord = 2;
            height = 32;
            width = 8;
            vm = 2;
            
            % Preparation
            subCoefs = cell(dec,1);
            for iSubband = 1:dec
                subCoefs{iSubband} = rand(height/dec,width);
            end
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angs)));
            
            % Expected values
            imgExpctd = 0;
            for iSubband = 1:dec % Periodic extension
                fi = lppufb(iSubband);
                tmp = subCoefs{iSubband};
                tmp = imfilter(upsample(tmp,dec,dec/2),fi(:),'corr','circ');
                imgExpctd = imgExpctd + tmp;
            end
            
            % Instantiation of target class
            this.igenlot = InverseGenLot(lppufb,'circular');
            
            % Actual values
            this.igenlot = inverseTransform(this.igenlot,subCoefs);
            imgActual = getImage(this.igenlot);
            
            % Evaluation
            this.assertEquals(height,size(imgActual,1));
            this.assertEquals(width,size(imgActual,2));            
            diff = norm(imgExpctd(:) - imgActual(:))/numel(imgExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
    end

    
end
