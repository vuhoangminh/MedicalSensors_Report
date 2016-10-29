classdef ForwardGenLot2dTestCase < TestCase
    %FORWARDGENLOT2DTESTCASE Test case for ForwardGenLot2d
    %
    % SVN identifier:
    % $Id: ForwardGenLot2dTestCase.m 249 2011-11-27 01:55:42Z sho $
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

            % Parameters
            dec = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected values
            P = [ 1 0 0 0 ; 0 0 1 0 ; 0 1 0 0 ; 0 0 0 1];
            fun = @(x) P*dct2(x)*P.';
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d();
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getCoefs(this.fgenlot);
                        
            % Evaluation
            this.assertEquals(height,size(coefActual,1));
            this.assertEquals(width,size(coefActual,2));
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testForwardBlockDctNaturalOrder(this)

            % Parameters
            dec = 4;
            height = 16;
            width = 16;
            srcImg = rand(height,width);
            
            % Expected values
            fun = @(x) dct2(x);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d();
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg,'natural');
            coefActual = getCoefs(this.fgenlot);
                        
            % Evaluation
            this.assertEquals(height,size(coefActual,1));
            this.assertEquals(width,size(coefActual,2));
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for dec=8
        function this = testForwardBlockDctDec8(this)
            
            % Parameters
            dec = 8;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            vm = 0;
            
            % Expected values
            I = eye(dec);
            P = [ downsample(I,2,0) ; downsample(I,2,1) ];
            fun = @(x) P*dct2(x)*P.';
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            this.fgenlot = ForwardGenLot2d(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getCoefs(this.fgenlot);
                        
            % Evaluation
            this.assertEquals(height,size(coefActual,1));
            this.assertEquals(width,size(coefActual,2));
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
        % Test for dec=8
        function this = testForwardBlockDctDec8NaturalOrder(this)
            
            % Parameters
            dec = 8;
            height = 32;
            width = 32;
            srcImg = rand(height,width);
            vm = 0;
            
            % Expected values
            I = eye(dec);
            P = [ downsample(I,2,0) ; downsample(I,2,1) ];
            fun = @(x) dct2(x);
            coefExpctd = myblkproc(srcImg,[dec dec],fun);
            
            % Instantiation of target class
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec);
            this.fgenlot = ForwardGenLot2d(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg,'natural');
            coefActual = getCoefs(this.fgenlot);
                        
            % Evaluation
            this.assertEquals(height,size(coefActual,1));
            this.assertEquals(width,size(coefActual,2));
            diff = norm(coefExpctd(:) - coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end

        % Test for dec=4,ord=0
        function this = testGetSubbandCoefsDec4Ord0(this)
            dec = 4;
            ord = 0;
            height = 16;
            width = 16;
            vm = 0;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            I = eye(dec);
            P = [ downsample(I,2,0) ; downsample(I,2,1) ];
            fun = @(x) P*dct2(x)*P.';
            tmp = myblkproc(srcImg,[dec dec],fun);
            coefExpctd = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    coefExpctd{iSubband,jSubband} = ...
                        tmp(iSubband:dec:end,jSubband:dec:end);
                end
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);
            
            % Evaluation
            for iSubband=1:dec
                for jSubband=1:dec
                    subCoefExpctd = coefExpctd{iSubband,jSubband};
                    subCoefActual = coefActual{iSubband,jSubband};
                    diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                        /numel(subCoefExpctd);
                    this.assertEquals(height/dec,size(subCoefActual,1));
                    this.assertEquals(width/dec,size(subCoefActual,2));
                    this.assert(diff<1e-14,sprintf('%d,%d:%g',iSubband,jSubband,diff));
                end
                
            end
                       
        end
        
        % Test for dec=4,ord=2
        function this = testGetSubbandCoefsDec4Ord2(this)
            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,dec);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                tmp = downsample(...
                    imfilter(srcImg,hi(:),'conv','symmetric'),...
                    dec,1);
                for jSubband = 1:dec
                    hj = lppufb(jSubband);
                    coefExpctd{iSubband,jSubband} = downsample(...
                        imfilter(tmp.',hj(:),'conv','symmetric'),...
                        dec,1).';
                end
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);
            
            % Evaluation
            for iSubband=1:dec
                for jSubband=1:dec
                    subCoefExpctd = coefExpctd{iSubband,jSubband};
                    subCoefActual = coefActual{iSubband,jSubband};
                    diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                        /numel(subCoefExpctd);
                    this.assertEquals(height/dec,size(subCoefActual,1));
                    this.assertEquals(width/dec,size(subCoefActual,2));
                    this.assert(diff<1e-14,sprintf('%d,%d:%g',iSubband,jSubband,diff));
                end
                
            end
        end
        
        % Test for dec=4,ord=4
        function this = testGetSubbandCoefsDec4Ord4(this)
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angls = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angls)));
            
            % Expected values
            coefExpctd = cell(dec,dec);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                tmp = downsample(...
                    imfilter(srcImg,hi(:),'conv','symmetric'),...
                    dec,1);
                for jSubband = 1:dec
                    hj = lppufb(jSubband);
                    coefExpctd{iSubband,jSubband} = downsample(...
                        imfilter(tmp.',hj(:),'conv','symmetric'),...
                        dec,1).';
                end
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);
            
            % Evaluation
            for iSubband=1:dec
                for jSubband=1:dec
                    subCoefExpctd = coefExpctd{iSubband,jSubband};
                    subCoefActual = coefActual{iSubband,jSubband};
                    diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                        /numel(subCoefExpctd);
                    this.assertEquals(height/dec,size(subCoefActual,1));
                    this.assertEquals(width/dec,size(subCoefActual,2));
                    this.assert(diff<1e-14,sprintf('%d,%d:%g',iSubband,jSubband,diff));
                end
                
            end
        end
        
        % Test for dec=8,ord=0
        function this = testGetSubbandCoefsDec8Ord0(this)
            dec = 8;
            ord = 0;
            height = 32;
            width = 32;
            vm = 0;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            I = eye(dec);
            P = [ downsample(I,2,0) ; downsample(I,2,1) ];
            fun = @(x) P*dct2(x)*P.';
            tmp = myblkproc(srcImg,[dec dec],fun);
            coefExpctd = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    coefExpctd{iSubband,jSubband} = ...
                        tmp(iSubband:dec:end,jSubband:dec:end);
                end
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);
            
            % Evaluation
            for iSubband=1:dec
                for jSubband=1:dec
                    subCoefExpctd = coefExpctd{iSubband,jSubband};
                    subCoefActual = coefActual{iSubband,jSubband};
                    diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                        /numel(subCoefExpctd);
                    this.assertEquals(height/dec,size(subCoefActual,1));
                    this.assertEquals(width/dec,size(subCoefActual,2));
                    this.assert(diff<1e-14,sprintf('%d,%d:%g',iSubband,jSubband,diff));
                end
                
            end
                       
        end
        
        % Test for dec=8,ord=2
        function this = testGetSubbandCoefsDec8Ord2(this)
            dec = 8;
            ord = 2;
            height = 32;
            width = 32;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,dec);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                tmp = downsample(...
                    imfilter(srcImg,hi(:),'conv','symmetric'),...
                    dec,3);
                for jSubband = 1:dec
                    hj = lppufb(jSubband);
                    coefExpctd{iSubband,jSubband} = downsample(...
                        imfilter(tmp.',hj(:),'conv','symmetric'),...
                        dec,3).';
                end
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d(lppufb);
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);
            
            % Evaluation
            for iSubband=1:dec
                for jSubband=1:dec
                    subCoefExpctd = coefExpctd{iSubband,jSubband};
                    subCoefActual = coefActual{iSubband,jSubband};
                    diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                        /numel(subCoefExpctd);
                    this.assertEquals(height/dec,size(subCoefActual,1));
                    this.assertEquals(width/dec,size(subCoefActual,2));
                    this.assert(diff<1e-14,sprintf('%d,%d:%g',iSubband,jSubband,diff));
                end
                
            end
        end
        
        % Test for dec=4,ord=2, periodic extension
        function this = testGetSubbandCoefsDec4Ord2PeriodicExt(this)
            dec = 4;
            ord = 2;
            height = 16;
            width = 16;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,dec);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                tmp = downsample(...
                    imfilter(srcImg,hi(:),'conv','circular'),...
                    dec,1);
                for jSubband = 1:dec
                    hj = lppufb(jSubband);
                    coefExpctd{iSubband,jSubband} = downsample(...
                        imfilter(tmp.',hj(:),'conv','circular'),...
                        dec,1).';
                end
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d(lppufb,'circular');
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);
            
            % Evaluation
            for iSubband=1:dec
                for jSubband=1:dec
                    subCoefExpctd = coefExpctd{iSubband,jSubband};
                    subCoefActual = coefActual{iSubband,jSubband};
                    diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                        /numel(subCoefExpctd);
                    this.assertEquals(height/dec,size(subCoefActual,1));
                    this.assertEquals(width/dec,size(subCoefActual,2));
                    this.assert(diff<1e-14,sprintf('%d,%d:%g',iSubband,jSubband,diff));
                end
                
            end
        end
              
        % Test for dec=4,ord=2, periodic extension
        function this = testGetSubbandCoefsDec4Ord4PeriodicExt(this)
            dec = 4;
            ord = 4;
            height = 32;
            width = 32;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            angls = getAngles(lppufb);
            lppufb = setAngles(lppufb,randn(size(angls)));
            
            % Expected values
            coefExpctd = cell(dec,dec);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                tmp = downsample(...
                    imfilter(srcImg,hi(:),'conv','circular'),...
                    dec,1);
                for jSubband = 1:dec
                    hj = lppufb(jSubband);
                    coefExpctd{iSubband,jSubband} = downsample(...
                        imfilter(tmp.',hj(:),'conv','circular'),...
                        dec,1).';
                end
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d(lppufb,'circular');
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);
            
            % Evaluation
            for iSubband=1:dec
                for jSubband=1:dec
                    subCoefExpctd = coefExpctd{iSubband,jSubband};
                    subCoefActual = coefActual{iSubband,jSubband};
                    diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                        /numel(subCoefExpctd);
                    this.assertEquals(height/dec,size(subCoefActual,1));
                    this.assertEquals(width/dec,size(subCoefActual,2));
                    this.assert(diff<1e-14,sprintf('%d,%d:%g',iSubband,jSubband,diff));
                end
                
            end
        end
        
        % Test for dec=8,ord=2, periodic extension
        function this = testGetSubbandCoefsDec8Ord2PeriodicExt(this)
            dec = 8;
            ord = 2;
            height = 32;
            width = 32;
            vm = 2;
            srcImg = rand(height,width);

            % Preparation
            lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord);
            
            % Expected values
            coefExpctd = cell(dec,dec);
            for iSubband = 1:dec
                hi = lppufb(iSubband);
                tmp = downsample(...
                    imfilter(srcImg,hi(:),'conv','circular'),...
                    dec,3);
                for jSubband = 1:dec
                    hj = lppufb(jSubband);
                    coefExpctd{iSubband,jSubband} = downsample(...
                        imfilter(tmp.',hj(:),'conv','circular'),...
                        dec,3).';
                end
            end
            
            % Instantiation of target class
            this.fgenlot = ForwardGenLot2d(lppufb,'circular');
            
            % Actual values
            this.fgenlot = forwardTransform(this.fgenlot,srcImg);
            coefActual = getSubbandCoefs(this.fgenlot);
            
            % Evaluation
            for iSubband=1:dec
                for jSubband=1:dec
                    subCoefExpctd = coefExpctd{iSubband,jSubband};
                    subCoefActual = coefActual{iSubband,jSubband};
                    diff = norm(subCoefExpctd(:) - subCoefActual(:))...
                        /numel(subCoefExpctd);
                    this.assertEquals(height/dec,size(subCoefActual,1));
                    this.assertEquals(width/dec,size(subCoefActual,2));
                    this.assert(diff<1e-14,sprintf('%d,%d:%g',iSubband,jSubband,diff));
                end
                
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
