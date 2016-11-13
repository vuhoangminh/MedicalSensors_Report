classdef LpPuFb2dTvmTestCase < TestCase
    %LPPUFB2DTVMTESTCASE Test case for LpPuFb2dTvm
    %
    % SVN identifier:
    % $Id: LpPuFb2dTvmTestCase.m 344 2012-10-24 02:21:28Z sho $
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
        lppufb;
    end
    
    methods
       
        function this = tearDown(this)
            delete(this.lppufb)
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0
                ];
            
            coefExpctd(:,:,2,1) = [
                -0.107390364784491   0.013640364784491   0.138640364784491   0.017609635215509
                0.415921094353473  -0.052828905646527  -0.536951823922454  -0.068201823922454
                0.000000000000000  -0.000000000000000                   0                   0
                0.429561459137964  -0.054561459137964  -0.554561459137964  -0.070438540862036
                ];
            
            coefExpctd(:,:,3,1) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0
                ];
            
            coefExpctd(:,:,1,2) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0
                ];
            
            coefExpctd(:,:,2,2) = [
                0.589780729568982   0.347719270431018   0.347719270431018   0.589780729568982
                0.152280729568982   0.089780729568982   0.089780729568982   0.152280729568982
                0.500000000000000  -0.500000000000000   0.500000000000000  -0.500000000000000
                0   0.000000000000000                   0                   0
                ];
            
            coefExpctd(:,:,3,2) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0
                ];
            
            coefExpctd(:,:,1,3) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0
                ];
            
            coefExpctd(:,:,2,3) = [
                0.017609635215509   0.138640364784491   0.013640364784491  -0.107390364784491
                -0.068201823922454  -0.536951823922454  -0.052828905646527   0.415921094353473
                0   0.000000000000000   0.000000000000000  -0.000000000000000
                0.070438540862036   0.554561459137964   0.054561459137964  -0.429561459137964
                ];
            
            coefExpctd(:,:,3,3) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0
                ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm();
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for default construction
        function this = testConstructorWithDeepCopy(this)
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm();
            cloneLpPuFb = LpPuFb2dTvm(this.lppufb);
            
            % Expected values
            coefExpctd = double(this.lppufb);
            
            % Actual values
            coefActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Change angles
            angles = randn(size(getAngles(cloneLpPuFb)));
            cloneLpPuFb = setAngles(cloneLpPuFb,angles);
            
            % Actual values
            coefActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist>1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction
        function this = testConstructorWithOrd00(this)
            
            % Parameters
            phi = 0;
            dec = [ 2 2 ];
            ord = [ 0 0 ];
            
            % Expected values
            exceptionIdExpctd = 'DirLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Order must be greater than or equal to 2');
            
            % Instantiation of target class
            try
                LpPuFb2dTvm(phi,dec,ord);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
        end
        
        % Test for construction with order 2 2 and directional vm
        function this = testConstructorWithDec44Ord22Tvm120(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = 2*pi*rand(28,6);
            mus = 2*round(rand(8,6))-1;
            phi = 120;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % lenx3
            lenx3 = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            this.assert(lenx3<2);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay = zeros(4);
            for iCol = 1:dec(2)
                for iRow = 1:dec(1)
                    delay(dec(1)*(iCol-1)+iRow,:,iRow,iCol) = 1;
                end
            end
            dc = PolyPhaseMatrix2d(delay);
            H = upsample(E,dec,[1 2])*dc;
            Hdc = zeros(prod(dec),1);
            for i=1:prod(dec)
                Hdc(i) =  sum(sum(H(i,1)));
            end
            coefDist = norm(Hdc(:).' ...
                - [sqrt(prod(dec)) zeros(1,prod(dec)-1)])/sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Directional VM
            if getLambdaUeq(this.lppufb) <= 0
                [ckTvm, angleVm] = checkTvm(this.lppufb);
                this.assert(angleVm-phi<1e-15,...
                    sprintf('a = %g: invalid angle (neq %g)', angleVm, phi));
                this.assert(ckTvm<1e-15,...
                    sprintf('c = %g: triangle condition failed', ckTvm));
            end
        end
        
        function this = testConstructorWithInvalidArguments(this)
            
            % Invalid input
            phi = 0;
            dec = [ 4 4 ];
            ord = [ 0 0 ];
            sizeInvalid = [2 2];
            ang = 2*pi*rand(sizeInvalid);
            
            % Expected value
            sizeExpctd = [28 2];
            
            % Expected values
            exceptionIdExpctd = 'DirLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Size of angles must be [ %d %d ]',...
                sizeExpctd(1), sizeExpctd(2));
            
            % Instantiation of target class
            try
                LpPuFb2dTvm(phi,dec,ord,ang);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
        end
        
        
        
        % Test for char
        function this = testChar(this)
            
            % Expected value
            if isunix || ~verLessThan('matlab', '7.9')
                charExpctd = [...
                    '[',10,...
                    9,'-0.10739*y^(-1) + 0.01364*y^(-2) + 0.72842*y^(-1)*x^(-1) + 0.36533*y^(-2)*x^(-1) + 0.36533*y^(-1)*x^(-2) + 0.72842*y^(-2)*x^(-2) + 0.01364*y^(-1)*x^(-3) - 0.10739*y^(-2)*x^(-3);',10,...
                    9,'0.41592*y^(-1) - 0.052829*y^(-2) - 0.38467*y^(-1)*x^(-1) + 0.021579*y^(-2)*x^(-1) + 0.021579*y^(-1)*x^(-2) - 0.38467*y^(-2)*x^(-2) - 0.052829*y^(-1)*x^(-3) + 0.41592*y^(-2)*x^(-3);',10,...
                    9,'2.7756e-17*y^(-1) - 3.4694e-18*y^(-2) + 0.5*y^(-1)*x^(-1) - 0.5*y^(-2)*x^(-1) + 0.5*y^(-1)*x^(-2) - 0.5*y^(-2)*x^(-2) + 1.7347e-18*y^(-1)*x^(-3) - 2.7756e-17*y^(-2)*x^(-3);',10,...
                    9,'0.42956*y^(-1) - 0.054561*y^(-2) - 0.55456*y^(-1)*x^(-1) - 0.070439*y^(-2)*x^(-1) + 0.070439*y^(-1)*x^(-2) + 0.55456*y^(-2)*x^(-2) + 0.054561*y^(-1)*x^(-3) - 0.42956*y^(-2)*x^(-3)',10,...
                    ']'...
                    ];
            else
                charExpctd = [...
                    '[',10,...
                    9,'-0.10739*y^(-1) + 0.01364*y^(-2) + 0.72842*y^(-1)*x^(-1) + 0.36533*y^(-2)*x^(-1) + 0.36533*y^(-1)*x^(-2) + 0.72842*y^(-2)*x^(-2) + 0.01364*y^(-1)*x^(-3) - 0.10739*y^(-2)*x^(-3);',10,...
                    9,'0.41592*y^(-1) - 0.052829*y^(-2) - 0.38467*y^(-1)*x^(-1) + 0.021579*y^(-2)*x^(-1) + 0.021579*y^(-1)*x^(-2) - 0.38467*y^(-2)*x^(-2) - 0.052829*y^(-1)*x^(-3) + 0.41592*y^(-2)*x^(-3);',10,...
                    9,'2.7756e-017*y^(-1) - 3.4694e-018*y^(-2) + 0.5*y^(-1)*x^(-1) - 0.5*y^(-2)*x^(-1) + 0.5*y^(-1)*x^(-2) - 0.5*y^(-2)*x^(-2) + 1.7347e-018*y^(-1)*x^(-3) - 2.7756e-017*y^(-2)*x^(-3);',10,...
                    9,'0.42956*y^(-1) - 0.054561*y^(-2) - 0.55456*y^(-1)*x^(-1) - 0.070439*y^(-2)*x^(-1) + 0.070439*y^(-1)*x^(-2) + 0.55456*y^(-2)*x^(-2) + 0.054561*y^(-1)*x^(-3) - 0.42956*y^(-2)*x^(-3)',10,...
                    ']'...
                    ];
            end
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm();
            
            % Actual values
            charActual = char(this.lppufb);
            
            % Evaluation
            this.assertEquals(charExpctd, charActual);
            
        end
        
        % Test for construction with order 2 2 and directional vm
        function this = testConstructorWithDec22Ord22Tvm0(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            ang = (2*pi*rand(1,6)-1);
            mus = 2*round(rand(2,6))-1;
            phi = 0;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay(1,:,1,1) = 1;
            delay(2,:,2,1) = 1;
            delay(3,:,1,2) = 1;
            delay(4,:,2,2) = 1;
            d = PolyPhaseMatrix2d(delay);
            H = E*d;
            Hdc = [
                sum(sum(H(1,1)))
                sum(sum(H(2,1)))
                sum(sum(H(3,1)))
                sum(sum(H(4,1)))
                ];
            coefDist = norm(Hdc(:).' - [sqrt(prod(dec)) 0 0 0])/...
                sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Directional VM
            [ckTvm, angleVm] = checkTvm(this.lppufb);
            this.assert(angleVm<1e-15,...
                sprintf('a = %g: invalid angle', angleVm));
            this.assert(ckTvm<1e-15,...
                sprintf('c = %g: triangle condition failed', ckTvm));
            
        end
        
        % Test for construction with order 2 2 and directional vm
        function this = testConstructorWithDec44Ord22Tvm0(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = 2*pi*rand(28,6);
            mus = 2*round(rand(8,6))-1;
            phi = 0;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay = zeros(4);
            for iCol = 1:dec(2)
                for iRow = 1:dec(1)
                    delay(dec(1)*(iCol-1)+iRow,:,iRow,iCol) = 1;
                end
            end
            dc = PolyPhaseMatrix2d(delay);
            H = upsample(E,dec,[1 2])*dc;
            Hdc = zeros(prod(dec),1);
            for i=1:prod(dec)
                Hdc(i) =  sum(sum(H(i,1)));
            end
            coefDist = norm(Hdc(:).' ...
                - [sqrt(prod(dec)) zeros(1,prod(dec)-1)])/sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Directional VM
            if getLambdaUeq(this.lppufb) <= 0
                [ckTvm, angleVm] = checkTvm(this.lppufb);
                this.assert(angleVm<1e-15,...
                    sprintf('a = %g: invalid angle', angleVm));
                this.assert(ckTvm<1e-15,...
                    sprintf('c = %g: triangle condition failed', ckTvm));
            end
        end
        
        % Test for construction with order 3 3 and directional vm
        function this = testConstructorWithDec22Ord33Tvm0(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 3 3 ];
            ang = (2*pi*rand(1,8)-1);
            mus = 2*round(rand(2,8))-1;
            phi = 0;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % lenx3
            lenx3 = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            this.assert(lenx3<2);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay(1,:,1,1) = 1;
            delay(2,:,2,1) = 1;
            delay(3,:,1,2) = 1;
            delay(4,:,2,2) = 1;
            d = PolyPhaseMatrix2d(delay);
            H = E*d;
            Hdc = [
                sum(sum(H(1,1)))
                sum(sum(H(2,1)))
                sum(sum(H(3,1)))
                sum(sum(H(4,1)))
                ];
            coefDist = norm(Hdc(:).' - [sqrt(prod(dec)) 0 0 0])/...
                sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Directional VM
            [ckTvm, angleVm] = checkTvm(this.lppufb);
            this.assert(angleVm<1e-15,...
                sprintf('a = %g: invalid angle', angleVm));
            this.assert(ckTvm<1e-15,...
                sprintf('c = %g: triangle condition failed', ckTvm));
            
        end
        
        % Test for construction with order 2 2 and directional vm
        function this = testConstructorWithDec44Ord33Tvm0(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 3 3 ];
            ang = 2*pi*rand(28,8);
            mus = 2*round(rand(8,8))-1;
            phi = 0;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % lenx3
            lenx3 = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            this.assert(lenx3<2);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay = zeros(4);
            for iCol = 1:dec(2)
                for iRow = 1:dec(1)
                    delay(dec(1)*(iCol-1)+iRow,:,iRow,iCol) = 1;
                end
            end
            dc = PolyPhaseMatrix2d(delay);
            H = upsample(E,dec,[1 2])*dc;
            Hdc = zeros(prod(dec),1);
            for i=1:prod(dec)
                Hdc(i) =  sum(sum(H(i,1)));
            end
            coefDist = norm(Hdc(:).' ...
                - [sqrt(prod(dec)) zeros(1,prod(dec)-1)])/sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Directional VM
            if getLambdaUeq(this.lppufb) <= 0
                [ckTvm, angleVm] = checkTvm(this.lppufb);
                this.assert(angleVm<1e-15,...
                    sprintf('a = %g: invalid angle', angleVm));
                this.assert(ckTvm<1e-15,...
                    sprintf('c = %g: triangle condition failed', ckTvm));
            end
        end
        
        % Test for construction with order 2 2 and directional vm
        function this = testConstructorWithDec22Ord22Tvm60(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            ang = (2*pi*rand(1,6)-1);
            mus = 2*round(rand(2,6))-1;
            phi = 60;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % lenx3
            lenx3 = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            this.assert(lenx3<2);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay(1,:,1,1) = 1;
            delay(2,:,2,1) = 1;
            delay(3,:,1,2) = 1;
            delay(4,:,2,2) = 1;
            d = PolyPhaseMatrix2d(delay);
            H = E*d;
            Hdc = [
                sum(sum(H(1,1)))
                sum(sum(H(2,1)))
                sum(sum(H(3,1)))
                sum(sum(H(4,1)))
                ];
            coefDist = norm(Hdc(:).' - [sqrt(prod(dec)) 0 0 0])/...
                sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Directional VM
            [ckTvm, angleVm] = checkTvm(this.lppufb);
            this.assert(angleVm-phi<1e-15,...
                sprintf('a = %g: invalid angle (neq %g)', angleVm, phi));
            this.assert(ckTvm<1e-15,...
                sprintf('c = %g: triangle condition failed', ckTvm));
            
        end
        
        % Test for construction with order 2 2 and directional vm
        function this = testConstructorWithDeepCopyDec44Ord22Tvm120(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = 2*pi*rand(28,6);
            mus = 2*round(rand(8,6))-1;
            phi = 120;
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            cloneLpPuFb = LpPuFb2dTvm(this.lppufb);
            
            % Expected values
            coefExpctd = this.lppufb(1);
            
            % Actual values
            coefActual = cloneLpPuFb(1);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Change angles
            angles = randn(size(getAngles(cloneLpPuFb)));
            cloneLpPuFb = setAngles(cloneLpPuFb,angles);
            
            % Actual values
            coefActual = cloneLpPuFb(1);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist>1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 3 3 and directional vm
        function this = testConstructorWithDec22Ord33Tvm90(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 3 3 ];
            ang = (2*pi*rand(1,8)-1);
            mus = 2*round(rand(2,8))-1;
            phi = 90;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % lenx3
            lenx3 = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            this.assert(lenx3<2);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay(1,:,1,1) = 1;
            delay(2,:,2,1) = 1;
            delay(3,:,1,2) = 1;
            delay(4,:,2,2) = 1;
            d = PolyPhaseMatrix2d(delay);
            H = E*d;
            Hdc = [
                sum(sum(H(1,1)))
                sum(sum(H(2,1)))
                sum(sum(H(3,1)))
                sum(sum(H(4,1)))
                ];
            coefDist = norm(Hdc(:).' - [sqrt(prod(dec)) 0 0 0])/...
                sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Directional VM
            [ckTvm, angleVm] = checkTvm(this.lppufb);
            this.assert(angleVm-phi<1e-15,...
                sprintf('a = %g: invalid angle (neq %g)', angleVm, phi));
            this.assert(ckTvm<1e-15,...
                sprintf('c = %g: triangle condition failed', ckTvm));
            
        end
        
        % Test for construction with order 3 3 and directional vm
        function this = testConstructorWithDec44Ord33Tvm90(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 3 3 ];
            ang = 2*pi*rand(28,8);
            mus = 2*round(rand(8,8))-1;
            phi = 90;
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            dimActual = size(coefActual);
            
            % lenx3
            lenx3 = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            this.assert(lenx3<2);
            
            % Check symmetry
            coefEvn = coefActual(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            coefOdd = coefActual(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix2d(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) = ...
                coefActual(1:nDecs,1:nDecs,ord(1)+1,ord(2)+1) - eye(nDecs);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            delay = zeros(4);
            for iCol = 1:dec(2)
                for iRow = 1:dec(1)
                    delay(dec(1)*(iCol-1)+iRow,:,iRow,iCol) = 1;
                end
            end
            dc = PolyPhaseMatrix2d(delay);
            H = upsample(E,dec,[1 2])*dc;
            Hdc = zeros(prod(dec),1);
            for i=1:prod(dec)
                Hdc(i) =  sum(sum(H(i,1)));
            end
            coefDist = norm(Hdc(:).' ...
                - [sqrt(prod(dec)) zeros(1,prod(dec)-1)])/sqrt(numel(Hdc));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check Directional VM
            if getLambdaUeq(this.lppufb) <= 0
                [ckTvm, angleVm] = checkTvm(this.lppufb);
                this.assert(angleVm-phi<1e-15,...
                    sprintf('a = %g: invalid angle (neq %g)', angleVm, phi));
                this.assert(ckTvm<1e-15,...
                    sprintf('c = %g: triangle condition failed', ckTvm));
            end
        end
        
        % Test for construction with order 2 2 and directional vm
        function this = testGetLengthX3Dec22Ord22Tvm(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            ang = zeros(1,6);
            mus = ones(2,6);
            
            % Instantiation of target class
            phi = 0;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 0.5;
            lambdaUeqExpctd = -0.75;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 30;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            
            % Instantiation of target class
            phi = 60;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 0.715518083829763;
            lambdaUeqExpctd = -0.642240958085119;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 90;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 0.5;
            lambdaUeqExpctd = -0.75;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 120;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1.679692592424553;
            lambdaUeqExpctd = -0.160153703787724;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 150;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
        end
        
        % Test for construction with order 3 3 and directional vm
        function this = testGetLengthX3Dec22Ord33Tvm(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 3 3 ];
            ang = zeros(1,8);
            mus = ones(2,8);
            
            % Instantiation of target class
            phi = 0;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1.118033988749895;
            lambdaUeqExpctd = -0.440983005625053;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 30;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd =   2.494009759259467; % > 2 (violated)
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-14,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            
            % Instantiation of target class
            phi = 60;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 2.250640828942328; % > 2 (violated)
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-14,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            
            % Instantiation of target class
            phi = 90;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 0.5;
            lambdaUeqExpctd = -0.75;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 120;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1.265417925337101;
            lambdaUeqExpctd = -0.367291037331449;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 150;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd =  0.668267900908913;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            
        end
        
        % Test for construction with order 2 2 and directional vm
        function this = testGetLengthX3Dec44Ord22Tvm(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = zeros(28,6);
            mus = ones(8,6);
            
            % Instantiation of target class
            phi = 0;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 0.559016994374947;
            lambdaUeqExpctd = -0.720491502812526;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 30;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1.003254288571669; %
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            
            % Instantiation of target class
            phi = 60;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 0.679892214782058;
            lambdaUeqExpctd = -0.660053892608971;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 90;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 0.559016994374947;
            lambdaUeqExpctd = -0.720491502812526;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 120;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1.742913244048236;
            lambdaUeqExpctd = -0.128543377975882;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 150;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1.003254288571669;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
        end
        
        % Test for construction with order 3 3 and directional vm
        function this = testGetLengthX3Dec44Ord33Tvm(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 3 3 ];
            ang = zeros(28,8);
            mus = ones(8,8);
            
            % Instantiation of target class
            phi = 0;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1.145643923738960;
            lambdaUeqExpctd = -0.427178038130520;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 30;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 2.474201637896802; % > 2 (violated)
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-14,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            
            % Instantiation of target class
            phi = 60;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 2.198619377857948; % > 2 (violated)
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            
            % Instantiation of target class
            phi = 90;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 0.444160726884051;
            lambdaUeqExpctd = -0.777919636557975;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 120;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 1.330023934842227;
            lambdaUeqExpctd = -0.334988032578886;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            lambdaUeqActual = getLambdaUeq(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            this.assert(abs(lambdaUeqExpctd-lambdaUeqActual)<1e-15,...
                sprintf('(%g) %g: invalid projection of x3 (neq %g)', ...
                phi, lambdaUeqActual,lambdaUeqExpctd));
            
            % Instantiation of target class
            phi = 150;
            this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus);
            
            % Expected values
            lenx3Expctd = 0.693698126690893;
            
            % Actual values
            lenx3Actual = getLengthX3(this.lppufb);
            
            % Evaluation
            this.assert(abs(lenx3Expctd-lenx3Actual)<1e-15,...
                sprintf('(%g) %g: invalid length of x3 (neq %g)', ...
                phi, lenx3Actual,lenx3Expctd));
            
        end
        
        function this = testInvalidParameters(this)
            
            % Parameters
            dec = [ 2 2 ];
            
            % Expected values
            exceptionIdExpctd = 'DirLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Unsupported combination of PHI and ORD');
            
            % Instantiation of target class
            try
                ord = [2 0];
                phi = 0;
                LpPuFb2dTvm(phi,dec,ord);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
            
            % Instantiation of target class
            try
                ord = [1 1];
                phi = 45;
                LpPuFb2dTvm(phi,dec,ord);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
            
            % Instantiation of target class
            try
                ord = [0 2];
                phi = 90;
                LpPuFb2dTvm(phi,dec,ord);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
        end
        
        function this = testTrendSurfaceAnnihilation(this)
            
            % Parameters
            dec = [ 2 2 ];
            dim = [ 64 64 ];
            
            for phi = 0:5:180
                % Instantiation of target class
                this.lppufb = LpPuFb2dTvm(phi,dec);
                
                % Trend Surface
                I = DirLotUtility.trendSurface(phi,dim);
                
                for iSubband = 2:prod(dec)
                    J = conv2(I,this.lppufb(iSubband));
                    subJ = J(dim(1)/4:dim(1)*3/4,dim(2)/4:dim(2)*3/4);
                    mse = norm(subJ(:))/numel(subJ);
                    msg = ...
                        sprintf('phi = %g, sb = %d, mse = %g, lenx3 = %g', ...
                        phi, iSubband, mse, getLengthX3(this.lppufb));
                    %fprintf('%s\n',msg);
                    % Evaluation
                    this.assert(mse<1e-15,msg);
                end
            end
            
        end
        
        function this = testTrendSurfaceAnnihilationOrd2(this)
            
            % Parameters
            dec = [ 2 2 ];
            dim = [ 64 64 ];
            
            for phi = 0:5:180
                
                % Instantiation of target class
                if mod(phi+45,180)-45 < 45
                    ord = [ 0 2 ];
                else
                    ord = [ 2 0 ];
                end
                this.lppufb = LpPuFb2dTvm(phi,dec,ord);
                
                % Trend Surface
                I = DirLotUtility.trendSurface(phi,dim);
                
                for iSubband = 2:prod(dec)
                    J = conv2(I,this.lppufb(iSubband));
                    subJ = J(dim(1)/4:dim(1)*3/4,dim(2)/4:dim(2)*3/4);
                    mse = norm(subJ(:))/numel(subJ);
                    msg = ...
                        sprintf('phi = %g, sb = %d, mse = %g, lenx3 = %g', ...
                        phi, iSubband, mse, getLengthX3(this.lppufb));
                    %fprintf('%s\n',msg);
                    % Evaluation
                    this.assert(mse<1e-15,msg);
                end
            end
            
        end
        
        function this = testTrendSurfaceAnnihilationDec44(this)
            
            % Parameters
            dec = [ 4 4 ];
            dim = [ 64 64 ];
            
            for phi = 0:5:180
                % Instantiation of target class
                this.lppufb = LpPuFb2dTvm(phi,dec);
                
                % Trend Surface
                I = DirLotUtility.trendSurface(phi,dim);
                
                for iSubband = 2:prod(dec)
                    J = conv2(I,this.lppufb(iSubband));
                    subJ = J(dim(1)/4:dim(1)*3/4,dim(2)/4:dim(2)*3/4);
                    mse = norm(subJ(:))/numel(subJ);
                    msg = ...
                        sprintf('phi = %g, sb = %d, mse = %g, lenx3 = %g', ...
                        phi, iSubband, mse, getLengthX3(this.lppufb));
                    %fprintf('%s\n',msg);
                    % Evaluation
                    this.assert(mse<1e-15,msg);
                end
            end
            
        end
        
        function this = testTrendSurfaceAnnihilationOrd4(this)
            
            % Parameters
            dec = [ 2 2 ];
            ang = 2*pi*rand(1,6);
            mus = 2*round(rand(2,6))-1;
            sl = 2*round(rand(1))-1;
            dim = [ 64 64 ];
            
            for phi = 0:5:180
                % Instantiation of target class
                if mod(phi+45,180)-45 < 45
                    ord = [ 0 4 ];
                else
                    ord = [ 4 0 ];
                end
                this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus,sl);
                
                % Trend Surface
                I = DirLotUtility.trendSurface(phi,dim);
                
                if getLengthX3(this.lppufb) < 2 && ...
                        getLambdaUeq(this.lppufb) <= 0
                    for iSubband = 2:prod(dec)
                        J = conv2(I,this.lppufb(iSubband));
                        subJ = J(dim(1)/4:dim(1)*3/4,dim(2)/4:dim(2)*3/4);
                        mse = norm(subJ(:))/numel(subJ);
                        msg = ...
                            sprintf('phi = %g, sb = %d, mse = %g, lenx3 = %g, lambdaueq = %g', ...
                            phi, iSubband, mse, ...
                            getLengthX3(this.lppufb),getLambdaUeq(this.lppufb));
                        
                        %fprintf('%s\n',msg);
                        % Evaluation
                        this.assert(mse<1e-15,msg);
                    end
                end
            end
        end
        
        function this = testTrendSurfaceAnnihilationOrd44(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 4 ];
            ang = 2*pi*rand(1,10);
            mus = 2*round(rand(2,10))-1;
            sl = 2*round(rand(1))-1;
            dim = [ 64 64 ];
            
            for phi = 0:5:180
                % Instantiation of target class
                this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus,sl);
                
                % Trend Surface
                I = DirLotUtility.trendSurface(phi,dim);
                
                if getLengthX3(this.lppufb) < 2 && ...
                        getLambdaUeq(this.lppufb) <= 0
                    for iSubband = 2:prod(dec)
                        J = conv2(I,this.lppufb(iSubband));
                        subJ = J(dim(1)/4:dim(1)*3/4,dim(2)/4:dim(2)*3/4);
                        mse = norm(subJ(:))/numel(subJ);
                        msg = ...
                            sprintf('phi = %g, sb = %d, mse = %g, lenx3 = %g, lambdaueq = %g', ...
                            phi, iSubband, mse, ...
                            getLengthX3(this.lppufb),getLambdaUeq(this.lppufb));
                        
                        %fprintf('%s\n',msg);
                        % Evaluation
                        this.assert(mse<1e-15,msg);
                    end
                end
            end
        end
        
        function this = testTrendSurfaceAnnihilationDec44Ord44(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 4 4 ];
            ang = 0; %2*pi*rand(28,10);
            mus = 2*round(rand(8,10))-1;
            sl = 2*round(rand(1))-1;
            dim = [ 128 128 ];
            
            for phi = 0:5:180
                % Instantiation of target class
                this.lppufb = LpPuFb2dTvm(phi,dec,ord,ang,mus,sl);
                
                % Trend Surface
                I = DirLotUtility.trendSurface(phi,dim);
                
                if getLengthX3(this.lppufb) < 2 && ...
                        getLambdaUeq(this.lppufb) <= 0
                    for iSubband = 2:prod(dec)
                        J = conv2(I,this.lppufb(iSubband));
                        subJ = J(dim(1)/4:dim(1)*3/4,dim(2)/4:dim(2)*3/4);
                        mse = norm(subJ(:))/numel(subJ);
                        msg = ...
                            sprintf('phi = %g, sb = %d, mse = %g, lenx3 = %g, lambdaueq = %g', ...
                            phi, iSubband, mse, ...
                            getLengthX3(this.lppufb),getLambdaUeq(this.lppufb));
                        
                        %fprintf('%s\n',msg);
                        % Evaluation
                        this.assert(mse<1e-15,msg);
                    end
                end
            end
            
        end
        
    end
end

