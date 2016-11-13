classdef LpPuFb1dDesignerCgTestCase < TestCase
    %LPPUFB1DDESIGNERCGTESTCASE Test case for LpPuFb1dDesignerCg
    %
    % SVN identifier:
    % $Id: LpPuFb1dDesignerCgTestCase.m 261 2011-11-29 12:05:56Z sho $
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
        designer
    end
    
    methods
        
        function this = tearDown(this)
            delete(this.designer);
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Expected values
            I = eye(4);
            P = [ I(1:2:end,:); I(2:2:end,:) ];
            coefExpctd = P*fliplr(dctmtx(4));
            angsExpctd = [0 0];
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerCg();
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd,angsActual);
            
        end

        % Test for default construction
        function this = testConstructorWithDec4Ord0(this)
            
            % Parameters
            dec = 4;
            ord = 0;
            
            % Expected values
            I = eye(4);
            P = [ I(1:2:end,:); I(2:2:end,:) ];
            coefExpctd = P*fliplr(dctmtx(4));
            angsExpctd = [0 0];
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerCg(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd,angsActual);
            
        end

        % Test for dec=4, ord=1
        function this = testConstructorWithDec4Ord1(this)
            
            % Parameters
            dec = 4;
            ord = 1;
            
            % Expected values
            I = eye(4);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];
            C = P*fliplr(dctmtx(dec));
            D = C(1:2,:)+C(3:4,:);
            coefExpctd(:,:,1) = [ D; -D]/2;
            coefExpctd(:,:,2) = [ fliplr(D); fliplr(D) ]/2;
            angsExpctd = [ 0 0 0 ];
            musExpctd = [
                1 1 -1 ;
                1 1 -1 ];            
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerCg(dec,ord);
            
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
        
        % Test for dec=4, ord=2
        function this = testConstructorWithDec4Ord2(this)
            
            % Parameters
            dec = 4;
            ord = 2;
            
            % Expected values
            I = eye(dec);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];            
            C = P*fliplr(dctmtx(dec));
            coefExpctd = zeros(dec,dec,ord+1);
            coefExpctd(:,:,2) = C;
            angsExpctd = [ 0 0 0 0 ];
            musExpctd = [
                1 1 -1 -1 ;
                1 1 -1 -1 ];            
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerCg(dec,ord);
            
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
        
        % Test for run, dec=4, ord=2
        function this = testRunWithDec4Ord2(this)
            
            % Parameters
            dec = 4;
            ord = 2;
            rho = 0.95;
            vm = 1;
            
            % Instantiation of target class
            nTaps = dec.*(ord+1);
            spec = CodingGain1d(nTaps,rho);
            this.designer = LpPuFb1dDesignerCg(dec,ord,spec,vm);
            
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
            %             figure
            %             lppufb = getLpPuFb2d(this.designer);
            %             dispBasisImages(lppufb);
            %             drawnow

            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end

        % Test for run, dec=4, ord=3
        function this = testRunWithDec4Ord3(this)
            
            % Parameters
            dec = 4;
            ord = 3;
            rho = 0.95;
            vm = 1;
            optfcnExpctd = 'fminunc';
            
            % Instantiation of target class
            nTaps = dec.*(ord+1);
            spec = CodingGain1d(nTaps,rho);
            this.designer = LpPuFb1dDesignerCg(dec,ord,spec,vm);
            
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
            %            lppufb = getLpPuFb2d(designer);
            %            dispBasisImages(lppufb);
            %            drawnow
            
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for run, dec=4, ord=4
        function this = testRunWithDec4Ord4(this)
            
            % Parameters
            dec = 4;
            ord = 4;
            rho = 0.95;
            vm  = 1;
            optfcnExpctd = 'fminunc';
            
            % Instantiation of target class
            nTaps = dec.*(ord+1);
            spec = CodingGain1d(nTaps,rho);
            this.designer = LpPuFb1dDesignerCg(dec,ord,spec,vm);
            
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
            
            % Shw basis images
            %                         figure(2)
            %                         lppufb = getLpPuFb2d(this.designer);
            %                         dispBasisImages(lppufb);
            %                         drawnow
            
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end

        % Test for run, dec=4, ord=2, vm=2
        function this = testRunWithDec4Ord2Vm2(this)
            
            % Parameters
            dec = 4;
            ord = 2;
            rho = 0.2;
            vm = 2;
            optfcnExpctd = 'fmincon';
            
            % Instantiation of target class
            nTaps = dec.*(ord+1);
            spec = CodingGain1d(nTaps,rho);
            this.designer = LpPuFb1dDesignerCg(dec,ord,spec,vm);
            
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

        % Test for construction, dec=8, ord=0
        function this = testConstructorWithDec8Ord0(this)
            
            % Parameters
            dec = 8;
            ord = 0;
            
            % Expected values
            I = eye(dec);
            P = [ I(1:2:end,:); I(2:2:end,:) ];
            coefExpctd = P*fliplr(dctmtx(dec));
            hDecs = dec/2;
            angsExpctd = zeros(hDecs*(hDecs-1)/2,sum(ord)+2);
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerCg(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd,angsActual);
            
        end
        
        % Test for construction, dec=8, ord=1
        function this = testConstructorWithDec8Ord1(this)
            
            % Parameters
            dec = 8;
            ord = 1;
            
            % Expected values
            I = eye(dec);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];
            C = P*fliplr(dctmtx(dec));
            D = C(1:dec/2,:)+C(dec/2+1:dec,:);
            coefExpctd(:,:,1) = [ D; -D]/2;
            coefExpctd(:,:,2) = [ fliplr(D); fliplr(D) ]/2;
            angsExpctd = zeros(6,3);
            musExpctd = [
                1 1 -1 ;
                1 1 -1 ;
                1 1 -1 ;
                1 1 -1 ];            
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerCg(dec,ord);
            
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
        
        % Test for construction dec=8, ord=2
        function this = testConstructorWithDec8Ord2(this)
            
            % Parameters
            dec = 8;
            ord = 2;
            
            % Expected values
            I = eye(dec);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];            
            C = P*fliplr(dctmtx(dec));
            coefExpctd = zeros(dec,dec,ord+1);
            coefExpctd(:,:,2) = C;
            angsExpctd = zeros(6,4);
            musExpctd = [
                1 1 -1 -1 ;
                1 1 -1 -1 ;
                1 1 -1 -1 ;
                1 1 -1 -1 ];            
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerCg(dec,ord);
            
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
        

        % Test for run, dec=4, ord=2, vm=2, GA
        function this = testRunWithDec4Ord2Ga(this)
            [isGaAvailable errmsg] = license('checkout','gads_toolbox');
            if ~isGaAvailable ...
                    || exist('ga','file') ~= 2
                this.fail('Skipped\n\tGA is not available. ... ');
                return
            end
            % Parameters
            dec = 4;
            ord = 2;
            rho = 0.95;
            vm = 1;
            optfcnExpctd = 'ga';
            
            % Instantiation of target class
            nTaps = dec.*(ord+1);
            spec = CodingGain1d(nTaps,rho);
            this.designer = LpPuFb1dDesignerCg(dec,ord,spec,vm,@ga);
            
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
            options = gaoptimset(optfcn);
            options = gaoptimset(options,'Display','off');
            options = gaoptimset(options,'PopInitRange',...
                [angles(:).'-pi;angles(:).'+pi]);
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
        
        % Test for run, dec=4, ord=2, vm=2, GA, PCT
        function this = testRunWithOrd22GaPct(this)
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
            dec = 4;
            ord = 2;
            rho = 0.95;
            vm = 1;
            optfcnExpctd = 'ga';
            
            % Instantiation of target class
            nTaps = dec.*(ord+1);
            spec = CodingGain1d(nTaps,rho);
            this.designer = LpPuFb1dDesignerCg(dec,ord,spec,vm,@ga);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
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
        
        % Test for dec=4, ord=2, vm=2, GA, PCT
        function this = testRunWithDec4Ord2Vm2GaPct(this)
            
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
            dec = 4;
            ord = 2;
            rho = 0.95;
            vm = 2;
            optfcnExpctd = 'ga';
            
            % Instantiation of target class
            nTaps = dec.*(ord+1);
            spec = CodingGain1d(nTaps,rho);
            this.designer = LpPuFb1dDesignerCg(dec,ord,spec,vm,@ga);
            
            % Cost before optimization
            angles = getAngles(this.designer);
            angles = 2*pi*(rand(size(angles))-0.5);
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
