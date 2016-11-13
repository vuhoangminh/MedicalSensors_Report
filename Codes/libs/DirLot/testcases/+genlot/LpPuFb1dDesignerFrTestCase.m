classdef LpPuFb1dDesignerFrTestCase < TestCase
    %LPPUFB1DDESIGNERFRTESTCASE Test case for LpPuFb1dDesignerFr
    %
    % SVN identifier:
    % $Id: LpPuFb1dDesignerFrTestCase.m 261 2011-11-29 12:05:56Z sho $
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
        designer;
    end
    
    methods
         
        function this = tearDown(this)
            delete(this.designer);
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Expected values
            I = eye(4);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];
            coefExpctd = P*fliplr(dctmtx(4));
            angsExpctd = [0 0];
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerFr();
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd,angsActual);
            
        end
        
        % Test for default construction
        function this = testConstructorDec4Ord0(this)
            
            % Parameters
            dec = 4;
            ord = 0;
            
            % Expected values
            I = eye(4);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];
            coefExpctd = P*fliplr(dctmtx(4));
            angsExpctd = [0 0];
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd,angsActual);
            
        end
        
        % Test for default construction
        function this = testConstructorDec4Ord1(this)
            
            % Parameters
            dec = 4;
            ord = 1;
            
            % Expected values
            I = eye(4);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];
            C = P*fliplr(dctmtx(4));
            D = C(1:2,:)+C(3:4,:);
            coefExpctd(:,:,1) = [ D; -D]/2;
            coefExpctd(:,:,2) = [ fliplr(D); fliplr(D) ]/2;
            angsExpctd = [ 0 0 0 ];
            musExpctd = [
                1 1 -1 ;
                1 1 -1 ];
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerFr(dec,ord);
            
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
        
        % Test for ord=2
        function this = testConstructorDec4Ord2(this)
            
            % Parameters
            dec = 4;
            ord = 2;
            
            % Expected values
            I = eye(4);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];
            Z = zeros(4);
            coefExpctd(:,:,1) = Z;
            coefExpctd(:,:,2) = P*fliplr(dctmtx(4));
            coefExpctd(:,:,3) = Z;
            angsExpctd = [ 0 0 0 0 ];
            musExpctd = [
                1 1 -1 -1 ;
                1 1 -1 -1 ];
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerFr(dec,ord);
            
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

        % Test for ord=2
        function this = testRunWithDec4Ord2(this)
            
            % Parameters
            nPoints = 16;
            dec = 4;
            ord = 2;
            transition = 0.2;
            vm = 1;
            
            % Stopband specification
            spp = SubbandSpecification1d(dec);
            spp = setTransition(spp,transition);
            specBand = cell(dec,1); 
            for idx = 1:dec
                ros = getPassStopAssignment(spp,nPoints,idx);
                specBand{idx} = ros;
            end
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy1d(specBand);
            this.designer = LpPuFb1dDesignerFr(dec,ord,spec,vm);
            
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
            %{
            figure
            lppufb = getLpPuFb1d(this.designer);
            dispBasisVectors(lppufb);
            drawnow
            %}
            
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end

        % Test for ord=3
        function this = testRunWithDec4Ord3(this)
            
            % Parameters
            nPoints = 16;
            dec = 4;
            ord = 3;
            transition = 0.2;
            vm = 1;
            optfcnExpctd = 'fminunc';
            
            % Stopband specification
            spp = SubbandSpecification1d(dec);
            spp = setTransition(spp,transition);
            specBand = cell(dec,1);
            for idx = 1:dec
                ros = getPassStopAssignment(spp,nPoints,idx);
                specBand{idx} = ros;
            end
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy1d(specBand);
            this.designer = LpPuFb1dDesignerFr(dec,ord,spec,vm);
            
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
            
            % Show basis vectors
            %            figure
            %            lppufb = getLpPuFb1d(this.designer);
            %            dispBasisVectors(lppufb);
            %            drawnow
            
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end

        % Test for ord=4;
        function this = testRunWithDec4Ord4(this)
            
            % Parameters
            nPoints = 16;
            dec = 4;
            ord = 4;
            transition = 0.2;
            vm = 1;
            optfcnExpctd = 'fminunc';
            
            % Stopband specification
            spp = SubbandSpecification1d(dec);
            spp = setTransition(spp,transition);
            specBand = cell(dec,1);
            for idx = 1:dec
                ros = getPassStopAssignment(spp,nPoints,idx);
                specBand{idx} = ros;
            end
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy1d(specBand);
            this.designer = LpPuFb1dDesignerFr(dec,ord,spec,vm);
            
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
            
            % Show basis vectors
            %                         figure
            %                         lppufb = getLpPuFb1d(this.designer);
            %                         dispBasisVectors(lppufb);
            %                         drawnow
            
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
   
        % Test for ord=2, vm2
        function this = testRunWithDec4Ord2Vm2(this)
            
            % Parameters
            nPoints = 16;
            dec = 4;
            ord = 2;
            transition = 0.2;
            vm = 2;
            optfcnExpctd = 'fmincon';
            
            % Stopband specification
            spp = SubbandSpecification1d(dec);
            spp = setTransition(spp,transition);
            specBand = cell(dec,1);
            for idx = 1:dec
                ros = getPassStopAssignment(spp,nPoints,idx);
                specBand{idx} = ros;
            end
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy1d(specBand);
            this.designer = LpPuFb1dDesignerFr(dec,ord,spec,vm);
            
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
            
            % Evaluation
            this.assert(costPre>=costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for dec=8, ord = 0
        function this = testConstructorDec8Ord0(this)
                
            % Parameters
            dec = 8;
            ord = 0;
            
            % Expected values
            I = eye(dec);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];
            coefExpctd = P*fliplr(dctmtx(dec));
            angsExpctd = zeros(6,2);
            musExpctd = ones(4,2);
            
            % Instantiation of target class
            this.designer = LpPuFb1dDesignerFr(dec,ord);
            
            % Actual values
            coefActual = double(this.designer);
            angsActual = getAngles(this.designer);
            musActual = getMus(this.designer);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            this.assertEquals(angsExpctd,angsActual);
            this.assertEquals(musExpctd,musActual);            

        end

        % Test for default construction
        function this = testRunWithDec4Ord4Vm2(this)
            
            % Parameters
            nPoints = 32;
            dec = 4;
            ord = 4;
            transition = 0.2;
            vm = 2;
            optfcnExpctd = 'fmincon';
            
            % Stopband specification
            spp = SubbandSpecification1d(dec);
            spp = setTransition(spp,transition);
            specBand = cell(dec,1);
            for idx = 1:dec
                ros = getPassStopAssignment(spp,nPoints,idx);
                specBand{idx} = ros;
            end
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy1d(specBand);
            this.designer = LpPuFb1dDesignerFr(dec,ord,spec,vm);
            
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
            %             figure
            %             lppufb = getLpPuFb1d(this.designer);
            %             dispBasisVectors(lppufb);
            %             drawnow
            
            % Evaluation
            this.assert(costPre>=costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
        
        % Test for dec=4, ord=2, GA
        function this = testRunWithDec4Ord2Ga(this)
            [isGaAvailable errmsg] = license('checkout','gads_toolbox');
            if ~isGaAvailable ...
                    || exist('ga','file') ~= 2
                %thif.fail('Skipped\n\tGA is not available. ... ');
                return
            end
            
            % Parameters
            nPoints = 16;
            dec = 4;
            ord = 2;
            transition = 0.2;
            vm = 1;
            optfcnExpctd = 'ga';
            
            % Stopband specification
            spp = SubbandSpecification1d(dec);
            spp = setTransition(spp,transition);
            specBand = cell(dec,1);
            for idx=1:dec
                ros = getPassStopAssignment(spp,nPoints,idx);
                specBand{idx} = ros;
            end
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy1d(specBand);
            this.designer = LpPuFb1dDesignerFr(dec,ord,spec,vm,@ga);
            
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
        
        % Test for dec=4, ord=2, vm=1, GA, PCT
        function this = testRunWithDec4Ord2GaPct(this)
            [isGaAvailable errmsg] = license('checkout','gads_toolbox');
            if ~isGaAvailable ...
                    || exist('ga','file') ~= 2
                this.fail('Skipped\n\tGA is not available. ... ');
                return
            end
            [isPctAvailable errmsg] = license('checkout','distrib_computing_toolbox');
            if ~isPctAvailable || ...
                    exist('matlabpool','file') ~= 2
                this.fail('Skipped\n\t MATLABPOOL is not available. ...');
                return
            end
            
            % Parameters
            nPoints = 16;
            dec = 4;
            ord = 2;
            transition = 0.2;
            vm = 1;
            optfcnExpctd = 'ga';
            
            % Stopband specification
            spp = SubbandSpecification1d(dec);
            spp = setTransition(spp,transition);
            specBand = cell(dec,1);
            for idx=1:dec
                ros = getPassStopAssignment(spp,nPoints,idx);
                specBand{idx} = ros;
            end

            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy1d(specBand);
            this.designer = LpPuFb1dDesignerFr(dec,ord,spec,vm,@ga);
            
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

        % Test for dec=4, ord=2, vm=2, GA, PCT
        function this = testRunWithOrd22Vm2GaPct(this)
            [isGaAvailable errmsg] = license('checkout','gads_toolbox');
            if ~isGaAvailable ...
                    || exist('ga','file') ~= 2
                this.fail('Skipped\n\tGA is not available. ... ');
                return
            end
            [isPctAvailable errmsg] = license('checkout','distrib_computing_toolbox');
            if ~isPctAvailable || ...
                    exist('matlabpool','file') ~= 2
                this.fail('Skipped\n\t MATLABPOOL is not available. ...');
                return
            end
            
            % Parameters
            nPoints = 16;
            dec = 4;
            ord = 2;
            transition = 0.2;
            vm = 2;
            optfcnExpctd = 'ga';
            
            % Stopband specification
            spp = SubbandSpecification1d(dec);
            spp = setTransition(spp,transition);
            specBand = cell(dec,1);
            for idx = 1:dec
                ros = getPassStopAssignment(spp,nPoints,idx);
                specBand{idx} = ros;
            end
                        
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy1d(specBand);
            this.designer = LpPuFb1dDesignerFr(dec,ord,spec,vm,@ga);
            
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
        
        % Test for dec=8, ord=1
        function this = testRunWithDec8Ord2(this)
            
            % Parameters
            nPoints = 32;
            dec = 8;
            ord = 2;
            transition = 0.2;
            vm = 1;
            
            % Stopband specification
            spp = SubbandSpecification1d(dec);
            spp = setTransition(spp,transition);
            specBand = cell(dec,1);
            for idx = 1:dec
                ros = getPassStopAssignment(spp,nPoints,idx);
                specBand{idx} = ros;
            end
            
            % Instantiation of target class
            spec = PassBandErrorStopBandEnergy1d(specBand);
            this.designer = LpPuFb1dDesignerFr(dec,ord,spec,vm);
            
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
            
            % Show basis vectors
            %             figure
            %             lppufb = getLpPuFb1d(this.designer);
            %             dispBasisVectors(lppufb);
            %             drawnow
            
            % Evaluation
            this.assert(costPre>costPst,sprintf(...
                'Pre:%g, Pst:%g',costPre,costPst));
            
        end
   
    end
end
