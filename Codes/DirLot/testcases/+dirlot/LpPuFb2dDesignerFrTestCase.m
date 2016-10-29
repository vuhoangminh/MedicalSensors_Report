classdef LpPuFb2dDesignerFrTestCase < TestCase
    %LPPUFB2DDESIGNERFRTESTCASE Test case for LpPuFb2dDesignerFr
    %
    % SVN identifier:
    % $Id: LpPuFb2dDesignerFrTestCase.m 261 2011-11-29 12:05:56Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit_2008a
    %
    % Copyright (c) 2008, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties
        designer;
    end
    
    methods
        
        function this = tearDown(this)
            delete(this.designer);
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Expected values
            coefExpctd = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            angsExpctd = [0 0];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr();
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd,angsActual);
            
        end
        
        % Test for default construction
        function this = testConstructorWithOrd00(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 0 ];
            
            % Expected values
            coefExpctd = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            angsExpctd = [0 0];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd,angsActual);
            
        end
        
        % Test for default construction
        function this = testConstructorWithOrd11(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 1 1 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0         0         0    0.5000
                0         0         0    0.5000
                0         0         0    0.5000
                0         0         0    0.5000 ];
            coefExpctd(:,:,2,1) = [
                0         0    0.5000         0
                0         0   -0.5000         0
                0         0   -0.5000         0
                0         0    0.5000         0 ];
            coefExpctd(:,:,1,2) = [
                0    0.5000         0         0
                0   -0.5000         0         0
                0    0.5000         0         0
                0   -0.5000         0         0 ];
            coefExpctd(:,:,2,2) = [
                0.5000         0         0         0
                0.5000         0         0         0
                -0.5000         0         0         0
                -0.5000         0         0         0 ];
            angsExpctd = [ 0 -pi/2 -pi/2 0 ];
            musExpctd = [
                1     1     1     1 ;
                1    -1    -1     1 ];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd, angsActual);
            this.assertEquals(musExpctd, musActual);
        end
        
        % Test for default construction
        function this = testRunWithOrd22(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd33(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 3 3 ];
            alpha = 1.0;
            dir = Direction.VERTICAL;
            transition = 0.2;
            vm1 = true;
            optfcnExpctd = 'fminunc';
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            this.assertEquals(optfcnExpctd,char(optfcn));
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %            figure(2)
            %            lppufb = getLpPuFb2d(this.designer);
            %            dispBasisImages(lppufb);
            %            drawnow
            
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd44(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 4 4 ];
            alpha = 1.0;
            dir = Direction.VERTICAL;
            transition = 0.2;
            vm1 = true;
            optfcnExpctd = 'fminunc';
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            this.assertEquals(optfcnExpctd,char(optfcn));
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %                         figure(2)
            %                         lppufb = getLpPuFb2d(this.designer);
            %                         dispBasisImages(lppufb);
            %                         drawnow
            
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd44Vm2(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 4 4 ];
            alpha = 1.0;
            dir = Direction.VERTICAL;
            transition = 0.2;
            vm = 2;
            optfcnExpctd = 'fmincon';
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            this.assertEquals(optfcnExpctd,char(optfcn));
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            options = optimset(options,'Algorithm','active-set');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %                         figure(2)
            %                         lppufb = getLpPuFb2d(this.designer);
            %                         dispBasisImages(lppufb);
            %                         drawnow
            
            % Evaluation
            this.assert(costPre>=costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testConstructor44WithOrd00(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 0 0 ];
            
            % Expected values
            coefExpctd(:,1:6) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000  -0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000  -0.250000000000000   0.250000000000000
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637   0.176776695296637   0.073223304703363
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637   0.073223304703363  -0.176776695296637
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637  -0.426776695296637  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363  -0.176776695296637   0.426776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094  -0.326640741219094  -0.135299025036549
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549  -0.135299025036549   0.326640741219094
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094   0.326640741219094   0.135299025036549
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549   0.135299025036549  -0.326640741219094
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.135299025036549  -0.135299025036549
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094  -0.135299025036549   0.135299025036549
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549   0.326640741219094   0.326640741219094
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549   0.326640741219094  -0.326640741219094 ];
            
            coefExpctd(:,7:12) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                -0.073223304703363  -0.176776695296637  -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                0.176776695296637  -0.073223304703363  -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.176776695296637   0.426776695296637   0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                -0.426776695296637   0.176776695296637   0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.135299025036549   0.326640741219094  -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.326640741219094   0.135299025036549  -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.135299025036549  -0.326640741219094   0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.326640741219094  -0.135299025036549   0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.135299025036549  -0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549   0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                0.326640741219094   0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094  -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094 ];
            
            coefExpctd(:,13:16) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549 ];
            
            hDecs = prod(dec)/2;
            angsExpctd = zeros(hDecs*(hDecs-1)/2,sum(ord)+2);
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd,angsActual);
            
        end
        
        % Test for default construction
        function this = testConstructor88WithOrd00(this)
            
            % Parameters
            dec = [ 8 8 ];
            ord = [ 0 0 ];
            
            % Expected values
            coefSizeExpctd = [64 64];
            hDecs = prod(dec)/2;
            angsExpctd = zeros(hDecs*(hDecs-1)/2,sum(ord)+2);
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefSizeActual = size(double(this.designer));
            angsActual = getAngles(this.designer);
            
            % Evaluation
            this.assertEquals(coefSizeExpctd,coefSizeActual);
            this.assertEquals(angsExpctd,angsActual);
        end
        
        % Test for default construction
        function this = testRunWithOrd22DirVm(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            alpha = 1.0;
            dir = Direction.VERTICAL;
            transition = 0.2;
            phi = atan(alpha)*180/pi;
            vm = sprintf('d%f',phi);
            optfcnExpctd = 'fmincon';
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            this.assertEquals(optfcnExpctd,char(optfcn));
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            options = optimset(options,'Algorithm','active-set');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(2)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            
            % Evaluation
            this.assert(costPre>=costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd22Ga(this)
            
            [isGaAvailable errmsg] = license('checkout','gads_toolbox');
            if ~isGaAvailable ...
                    || exist('ga','file') ~= 2
                this.fail(this,'Skipped\n\tGA is not available. ... ');
                return
            end
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            alpha = 1.0;
            dir = Direction.VERTICAL;
            transition = 0.2;
            vm = 1;
            optfcnExpctd = 'ga';
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm,@ga);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            this.assertEquals(optfcnExpctd,char(optfcn));
            options = gaoptimset(optfcn);
            options = gaoptimset(options,'Display','off');
            options = gaoptimset(options,'PopInitRange',...
                [angles(:).'-pi;angles(:).'+pi]);
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Evaluation
            this.assert(costPre>=costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd22GaPct(this)
            [isGaAvailable errmsg] = license('checkout','gads_toolbox');
            if ~isGaAvailable ...
                    || exist('ga','file') ~= 2
                this.fail(this,'Skipped\n\tGA is not available. ... ');
                return
            end
            [isPctAvailable errmsg] = license('checkout','distrib_computing_toolbox');
            if ~isPctAvailable || ...
                    exist('matlabpool','file') ~= 2
                this.fail(this,'Skipped\n\t MATLABPOOL is not available. ...');
                return
            end
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            alpha = 1.0;
            dir = Direction.VERTICAL;
            transition = 0.2;
            vm = 1;
            optfcnExpctd = 'ga';
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm,@ga);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % parallel run
            %matlabpool open
            optfcn = getOptFcn(this.designer);
            this.assertEquals(optfcnExpctd,char(optfcn));
            options = gaoptimset(optfcn);
            options = gaoptimset(options,'Display','off');
            options = gaoptimset(options,'PopInitRange',...
                [angles(:).'-pi;angles(:).'+pi]);
            options = gaoptimset(options,'UseParallel','always');
            this.designer = run(this.designer,options);
            %matlabpool close
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Evaluation
            this.assert(costPre>=costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd22Vm2GaPct(this)
            [isGaAvailable errmsg] = license('checkout','gads_toolbox');
            if ~isGaAvailable ...
                    || exist('ga','file') ~= 2
                this.fail('Skipped\n\tGA is not available. ... ');
                return
            end
            [isPctAvailable errmsg] = license('checkout','distrib_computing_toolbox');
            if ~isPctAvailable  || ...
                    exist('matlabpool','file') ~= 2
                this.fail('Skipped\n\t MATLABPOOL is not available. ...');
                return
            end
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            alpha = 1.0;
            dir = Direction.VERTICAL;
            transition = 0.2;
            vm = 2;
            optfcnExpctd = 'ga';
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm,@ga);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % parallel run
            %matlabpool open
            optfcn = getOptFcn(this.designer);
            this.assertEquals(optfcnExpctd,char(optfcn));
            options = gaoptimset(optfcn);
            options = gaoptimset(options,'Display','off');
            options = gaoptimset(options,'PopInitRange',...
                [angles(:).'-pi;angles(:).'+pi]);
            options = gaoptimset(options,'UseParallel','always');
            this.designer = run(this.designer,options);
            %matlabpool close
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Evaluation
            this.assert(costPre>=costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testConstructorWithOrd01(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 1 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = 1/2 * [
                0         0         1         1;
                0         0        -1         1;
                0         0        -1         1;
                0         0         1         1 ];
            coefExpctd(:,:,2,1) = 1/2 * [
                1         1         0         0;
                1        -1         0         0;
                -1         1         0         0;
                -1        -1         0         0 ];
            
            angsExpctd = [ 0 -pi/2 -pi/2];
            musExpctd = [
                1     1     1;
                1    -1    -1];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd, angsActual);
            this.assertEquals(musExpctd, musActual);
        end
        
        % Test for default construction
        function this = testConstructorWithOrd10(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 1 0 ];
            
            
            % Expected values
            coefExpctd(:,:,1,1) = 1/2 * [
                0         1         0         1;
                0        -1         0         1;
                0         1         0         1;
                0        -1         0         1 ];
            coefExpctd(:,:,2,1) = 1/2 * [
                1         0         1         0;
                1         0        -1         0;
                -1         0        -1         0;
                -1         0         1         0 ];
            
            angsExpctd = [ 0 0 0];
            musExpctd = [
                1     1     1;
                1     1     1];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd, angsActual);
            this.assertEquals(musExpctd, musActual);
        end
        
        % Test for default construction
        function this = testRunWithOrd01(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 0 1 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd10(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 1 0 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd11(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 1 1 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testConstructorWithOrd02(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 2 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,2) = 1/2 * [
                1           1         1         1;
                1          -1        -1         1;
                -1           1        -1         1;
                -1          -1         1         1 ];
            coefExpctd(:,:,1,3) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            
            angsExpctd = [ 0 0 0 0 ];
            musExpctd = [
                1     1    -1    -1;
                1     1    -1    -1];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd, angsActual);
            this.assertEquals(musExpctd, musActual);
        end
        
        % Test for default construction
        function this = testConstructorWithOrd20(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 0 ];
            
            % Expected values
            coefExpctd(:,:,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2) = 1/2 * [
                1           1         1         1;
                1          -1        -1         1;
                -1           1        -1         1;
                -1          -1         1         1 ];
            coefExpctd(:,:,3) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            
            angsExpctd = [ 0 0 0 0 ];
            musExpctd = [
                1     1    -1    -1;
                1     1    -1    -1];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd, angsActual);
            this.assertEquals(musExpctd, musActual);
        end
        
        % Test for default construction
        function this = testRunWithOrd02(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 0 2 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd20(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 2 0 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testConstructorWithOrd04(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 4 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,2) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,3) = 1/2 * [
                1           1         1         1;
                1          -1        -1         1;
                -1           1        -1         1;
                -1          -1         1         1 ];
            coefExpctd(:,:,1,4) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,5) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            
            angsExpctd = [ 0 0 0 0 0 0 ];
            musExpctd = [
                1     1    -1    -1    -1    -1;
                1     1    -1    -1    -1    -1];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd, angsActual);
            this.assertEquals(musExpctd, musActual);
        end
        
        % Test for default construction
        function this = testConstructorWithOrd40(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 0 ];
            
            % Expected values
            coefExpctd(:,:,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,3) = 1/2 * [
                1           1         1         1;
                1          -1        -1         1;
                -1           1        -1         1;
                -1          -1         1         1 ];
            coefExpctd(:,:,4) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,5) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            
            angsExpctd = [ 0 0 0 0 0 0 ];
            musExpctd = [
                1     1    -1    -1    -1    -1;
                1     1    -1    -1    -1    -1];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd, angsActual);
            this.assertEquals(musExpctd, musActual);
        end
        
        % Test for default construction
        function this = testRunWithOrd04(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 0 4 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd40(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 4 0 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testConstructorWithOrd24(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 4 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,3,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,2) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2,2) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,3,2) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,3) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2,3) = 1/2 * [
                1           1         1         1;
                1          -1        -1         1;
                -1           1        -1         1;
                -1          -1         1         1 ];
            coefExpctd(:,:,3,3) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,4) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2,4) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,3,4) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,5) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2,5) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,3,5) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            
            
            angsExpctd = [ 0 0 0 0 0 0 0 0 ];
            musExpctd = [
                1     1    -1    -1    -1    -1     -1    -1;
                1     1    -1    -1    -1    -1     -1    -1];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd, angsActual);
            this.assertEquals(musExpctd, musActual);
        end
        
        % Test for default construction
        function this = testConstructorWithOrd42(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 2 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,3,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,4,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,5,1) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,2) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2,2) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,3,2) = 1/2 * [
                1           1         1         1;
                1          -1        -1         1;
                -1           1        -1         1;
                -1          -1         1         1 ];
            coefExpctd(:,:,4,2) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,5,2) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,1,3) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,2,3) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,3,3) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,4,3) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            coefExpctd(:,:,5,3) = [
                0           0         0         0;
                0           0         0         0;
                0           0         0         0;
                0           0         0         0 ];
            
            
            angsExpctd = [ 0 0 0 0 0 0 0 0 ];
            musExpctd = [
                1     1    -1    -1    -1    -1     -1    -1;
                1     1    -1    -1    -1    -1     -1    -1];
            
            % Instantiation of target class
            this.designer = LpPuFb2dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd, angsActual);
            this.assertEquals(musExpctd, musActual);
        end
        
        % Test for default construction
        function this = testRunWithOrd24(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 2 4 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for default construction
        function this = testRunWithOrd42(this)
            
            % Parameters
            nPoints = [16 16];
            dec = [ 2 2 ];
            ord = [ 4 2 ];
            alpha = 1.0;
            dir = Direction.HORIZONTAL;
            transition = 0.2;
            vm1 = true;
            
            % Stopband specification
            spp = SubbandSpecification(alpha,dir);
            spp = setTransition(spp,transition);
            rosLyLx = getPassStopAssignment(spp,nPoints,Subband.LyLx);
            rosHyLx = getPassStopAssignment(spp,nPoints,Subband.HyLx);
            rosLyHx = getPassStopAssignment(spp,nPoints,Subband.LyHx);
            rosHyHx = getPassStopAssignment(spp,nPoints,Subband.HyHx);
            specBand{Subband.LyLx} = rosLyLx;
            specBand{Subband.HyLx} = rosHyLx;
            specBand{Subband.LyHx} = rosLyHx;
            specBand{Subband.HyHx} = rosHyHx;
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy(specBand);
            this.designer = LpPuFb2dDesignerFr(dec,ord,spec,vm1);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
            mus = getMus(this.designer);
            mus = 2*round(rand(size(mus))) - 1;
            this.designer = setAngles(this.designer,angles);
            this.designer = setMus(this.designer,mus);
            costPre = getCost(this.designer);
            
            % run
            optfcn = getOptFcn(this.designer);
            options = optimset(optfcn);
            options = optimset(options,'Display','off');
            options = optimset(options,'LargeScale','off');
            this.designer = run(this.designer,options);
            
            % Cost after optimization
            costPst = getCost(this.designer);
            
            % Show basis images
            %             figure(1)
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow
            %
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end        
    end
end
