classdef ForwardGenLotTestCase < TestCase
    %FORWARDGENLOTTESTCASE Test case for ForwardGenLot
    %
    % SVN identifier:
    % $Id: ForwardGenLotTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        fgenlot
    end
    
    methods
        
        function this = tearDown(this)
            delete(this.fgenlot);
        end
        
        % Test for default construction
        function this = testForwardBlockDct(this)

            dec = 4;
            nSamples = 16;
            src = rand(nSamples,1);
            
            % Expected values
            E0 = double(LpPuFb1dFactory.createLpPuFb1d());
            tmp = E0*flipud(reshape(src,dec,nSamples/dec));
            coefExpctd = tmp(:);
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot();
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,src);
            coefActual = getCoefs(this.fgenlot);
                        
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testForwardBlockDctNaturalOrder(this)

            dec = 4;
            nSamples = 16;
            src = rand(nSamples,1);
            
            % Expected values
            tmp = dct(reshape(src,dec,nSamples/dec));
            coefExpctd = tmp(:);
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot();
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,src,'natural');
            coefActual = getCoefs(this.fgenlot);
                        
            % Evaluation
            diff = norm(coefExpctd - coefActual)/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end        

        % Test for images
        function this = testForwardBlockDctDec4Img(this)

            dec = 4;
            height = 16;
            width = 4;
            nSamples = height*width;
            vm = 0;
            srcImg = rand(height,width);
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            E0 = double(lppufb);
            coefs = E0*flipud(reshape(srcImg,dec,nSamples/dec));
            coefExpctd = reshape(coefs,height,width);
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getCoefs(this.fgenlot);
            
            % Evaluation
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for images
        function this = testForwardBlockDctDec4ImgNaturalOrder(this)

            dec = 4;
            ord = 0;
            vm = 0;
            height = 16;
            width = 4;
            nSamples = height*width;
            srcImg = rand(height,width);
            
            % Expected values
            coefs = dct(reshape(srcImg,dec,nSamples/dec));
            coefExpctd = reshape(coefs,height,width);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg,'natural');
            coefActual = getCoefs(this.fgenlot);
            
            % Evaluation
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        

        % Test for dec=8
        function this = testForwardBlockDctDec8(this)

            dec = 8;
            height = 32;
            width = 1;
            nSamples = height*width;            
            vm = 0;
            srcImg = rand(height,width);
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            E0 = double(lppufb);
            coefs = E0*flipud(reshape(srcImg,dec,nSamples/dec));
            coefExpctd = reshape(coefs,height,width);
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getCoefs(this.fgenlot);

            % Evaluation
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for dec=8
        function this = testForwardBlockDctDec8NaturalOrder(this)

            dec = 8;
            height = 32;
            width = 1;
            nSamples = height*width;            
            vm = 0;
            srcImg = rand(height,width);
            
            % Expected values
            coefs = dct(reshape(srcImg,dec,nSamples/dec));
            coefExpctd = reshape(coefs,height,width);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg,'natural');
            coefActual = getCoefs(this.fgenlot);

            % Evaluation
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for image, dec=8
        function this = testForwardBlockDctDec8Img(this)

            dec = 8;
            height = 32;
            width = 8;
            nSamples = height*width;            
            vm = 0;
            srcImg = rand(height,width);
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            E0 = double(lppufb);
            coefs = E0*flipud(reshape(srcImg,dec,nSamples/dec));
            coefExpctd = reshape(coefs,height,width);
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getCoefs(this.fgenlot);

            % Evaluation
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for image, dec=8
        function this = testForwardBlockDctDec8ImgNaturalOrder(this)
            
            dec = 8;
            height = 32;
            width = 8;
            nSamples = height*width;
            vm = 0;
            srcImg = rand(height,width);
            
            % Expected values
            coefs = dct(reshape(srcImg,dec,nSamples/dec));
            coefExpctd = reshape(coefs,height,width);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg,'natural');
            coefActual = getCoefs(this.fgenlot);
            
            % Evaluation
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for image, dec=4, ord=0
        function this = testForwardGenLotDec4Ord0Img(this)

            dec = 4;
            ord = 0;
            height = 16;
            width = 4;
            nSamples = height*width;
            vm = 0;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            E = double(lppufb);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            coefs = E*flipud(reshape(srcImg,dec,nSamples/dec));
            coefExpctd = reshape(coefs,height,width);
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(dec,paramMtx);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getCoefs(this.fgenlot);
                        
            % Evaluation
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
         % Test for image, dec=8, ord=0
        function this = testForwardGenLotDec8Ord0Img(this)

            dec = 8;
            ord = 0;
            height = 32;
            width = 8;
            nSamples = height*width;
            vm = 0;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angs = getAngles(lppufb);
            angs = randn(size(angs));
            lppufb = setAngles(lppufb,angs);
            E = double(lppufb);
            paramMtx = getParameterMatrices(lppufb);
            
            % Expected values
            coefs = E*flipud(reshape(srcImg,dec,nSamples/dec));
            coefExpctd = reshape(coefs,height,width);
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(dec,paramMtx);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getCoefs(this.fgenlot);
                        
            % Evaluation
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for getSubbandCoefs
        function this = testGetSubbandCoefsDec4Ord0(this)

            dec = 4;
            ord = 0;
            nSamples = 16;
            vm = 0;
            src = (1:nSamples).';

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            E0 = double(lppufb);
            coefs = E0*flipud(reshape(src,dec,nSamples/dec));
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                coefExpctd{iSubband} = coefs(iSubband,:).';
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,src);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test for getSubbandCoefs
        function this = testGetSubbandCoefsDec4Ord0NaturalOrder(this)

            dec = 4;
            ord = 0;
            nSamples = 16;
            vm = 0;
            src = (1:nSamples).';

            % Preparation
            coefs = dct(reshape(src,dec,nSamples/dec));
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                coefExpctd{iSubband} = coefs(iSubband,:).';
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,src,'natural');
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test for getSubbandCoefs
        function this = testGetSubbandCoefsDec8Ord0NaturalOrder(this)

            dec = 8;
            ord = 0;
            nSamples = 32;
            vm = 0;
            src = (1:nSamples).';

            % Preparation
            coefs = dct(reshape(src,dec,nSamples/dec));
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                coefExpctd{iSubband} = coefs(iSubband,:).';
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,src,'natural');
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test for getSubbandCoefs, dec=4,ord=0
        function this = testGetSubbandCoefsDec4Ord0Img(this)

            dec = 4;
            ord = 0;
            height = 16;
            width = 16;
            vm = 0;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            E0 = double(lppufb);
            coefs = E0*flipud(reshape(srcImg,dec,height*width/dec));
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                coefExpctd{iSubband} = ...
                    reshape(coefs(iSubband,:),height/dec,width);
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
                this.assertEquals(height/dec,size(subCoefActual,1));
                this.assertEquals(width,size(subCoefActual,2));
            end
            
        end
        
        % Test for getSubbandCoefs, dec=4,ord=0
        function this = testGetSubbandCoefsDec4Ord0ImgNaturalOrder(this)
            
            dec = 4;
            ord = 0;
            height = 16;
            width = 16;
            vm = 0;
            srcImg = rand(height,width);
            
            % Preparation
            coefs = dct(reshape(srcImg,dec,height*width/dec));
            
            % Expected values
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                coefExpctd{iSubband} = ...
                    reshape(coefs(iSubband,:),height/dec,width);
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg,'natural');
            coefActual = getSubbandCoefs(this.fgenlot);
            
            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
                this.assertEquals(height/dec,size(subCoefActual,1));
                this.assertEquals(width,size(subCoefActual,2));
            end
            
        end
        
        % Test for dec=4,ord=2
        function this = testGetSubbandCoefsDec4Ord2(this)

            dec = 4;
            ord = 2;
            nSamples = 16;
            vm = 2;
            src = (1:nSamples).';

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coefExpctd{iSubband} = downsample(...
                    imfilter(src,hi(:),'conv','symmetric'),...
                    dec,1);
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,src);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end
        
        % Test for dec=4,ord=2
        function this = testGetSubbandCoefsDec4Ord2Img(this)

            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coefExpctd{iSubband} = downsample(...
                    imfilter(srcImg,hi(:),'conv','symmetric'),...
                    dec,1);
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
                this.assertEquals(height/dec,size(subCoefActual,1));
                this.assertEquals(width,size(subCoefActual,2));
            end
            
        end
        
        % Test for dec=4,ord=2
        function this = testGetSubbandCoefsDec4Ord2ImgNaturalOrder(this)

            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coef_ = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coef_{iSubband} = downsample(...
                    imfilter(srcImg,hi(:),'conv','symmetric'),...
                    dec,1);
            end            
            coefExpctd = cell(dec,1);
            for iSubband = 1:2:dec
                coefExpctd{iSubband} = coef_{(iSubband+1)/2};
                coefExpctd{iSubband+1} = coef_{(iSubband+1+dec)/2};
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg,'natural');
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
                this.assertEquals(height/dec,size(subCoefActual,1));
                this.assertEquals(width,size(subCoefActual,2));
            end
            
        end        
        
        % Test for dec=4,ord=2
        function this = testGetSubbandCoefsDec4Ord4Img(this)

            dec = 4;
            ord = 4;
            height = 16;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coefExpctd{iSubband} = downsample(...
                    imfilter(srcImg,hi(:),'conv','symmetric'),...
                    dec,1);
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
                this.assertEquals(height/dec,size(subCoefActual,1));
                this.assertEquals(width,size(subCoefActual,2));                
            end
            
        end
        
        % Test for dec=4,ord=2
        function this = testGetSubbandCoefsDec8Ord2Img(this)

            dec = 8;
            ord = 2;
            height = 32;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coefExpctd{iSubband} = downsample(...
                    imfilter(srcImg,hi(:),'conv','symmetric'),...
                    dec,3);
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
                this.assertEquals(height/dec,size(subCoefActual,1));
                this.assertEquals(width,size(subCoefActual,2));                
            end
            
        end
        
         % Test for dec=4,ord=2
        function this = testGetSubbandCoefsDec8Ord2ImgNaturalOrder(this)

            dec = 8;
            ord = 2;
            height = 32;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coef_ = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coef_{iSubband} = downsample(...
                    imfilter(srcImg,hi(:),'conv','symmetric'),...
                    dec,3);
            end            
            coefExpctd = cell(dec,1);
            for iSubband = 1:2:dec
                coefExpctd{iSubband} = coef_{(iSubband+1)/2};
                coefExpctd{iSubband+1} = coef_{(iSubband+1+dec)/2};
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg,'natural');
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
                this.assertEquals(height/dec,size(subCoefActual,1));
                this.assertEquals(width,size(subCoefActual,2));                
            end
            
        end
        
        % Test for dec=4,ord=2
        function this = testGetSubbandCoefsDec4Ord2ImgSymmetricExt(this)

            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coefExpctd{iSubband} = downsample(...
                    imfilter(srcImg,hi(:),'conv','symmetric'),...
                    dec,1);
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb,'symmetric');
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end        
        
        % Test for dec=4,ord=2
        function this = testGetSubbandCoefsDec4Ord2ImgPeriodicExt(this)

            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coefExpctd{iSubband} = downsample(...
                    imfilter(srcImg,hi(:),'conv','circular'),...
                    dec,1);
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb,'circular');
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end                
        
        % Test for dec=4,ord=4
        function this = testGetSubbandCoefsDec4Ord4ImgPeriodicExt(this)

            dec = 4;
            ord = 4;
            height = 16;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coefExpctd{iSubband} = downsample(...
                    imfilter(srcImg,hi(:),'conv','circular'),...
                    dec,1);
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb,'circular');
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end 
        
        % Test for dec=4,ord=4
        function this = testGetSubbandCoefsDec8Ord2ImgPeriodicExt(this)

            dec = 8;
            ord = 2;
            height = 32;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,1);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                coefExpctd{iSubband} = downsample(...
                    imfilter(srcImg,hi(:),'conv','circular'),...
                    dec,3);
            end            
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot(lppufb,'circular');
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);

            % Evaluation
            for iSubband=1:dec
                subCoefExpctd = coefExpctd{iSubband};
                subCoefActual = coefActual{iSubband};
                diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                    /numel(subCoefExpctd);
                this.assert(diff<1e-14,sprintf('%d:%g',iSubband,diff));
            end
            
        end 
    end
    
end

