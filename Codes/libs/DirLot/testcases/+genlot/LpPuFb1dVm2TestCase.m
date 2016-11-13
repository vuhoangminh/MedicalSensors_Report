classdef LpPuFb1dVm2TestCase < TestCase
    %LPPUFB1DVM2TESTCASE Test case for LpPuFb1dVm2
    %
    % SVN identifier:
    % $Id: LpPuFb1dVm2TestCase.m 249 2011-11-27 01:55:42Z sho $
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
        lppufb;
    end
    
    methods
        
        function this = tearDown(this)
            delete(this.lppufb)
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Expected values
            coefsExpctd(:,:,1) = [ ...
                -0.007126702979228  -0.078810797020772  -0.016310797020772   0.180373297020772  ;
                -0.024481028678934  -0.270723978212463  -0.056029427745993   0.619602622720478  ;
                 0.007126702979228   0.078810797020772   0.016310797020772  -0.180373297020772  ;
                 0.024481028678934   0.270723978212463   0.056029427745993  -0.619602622720478  ];
            coefsExpctd(:,:,2) = [ ...
                 0.326753405958456   0.595121594041544   0.595121594041544   0.326753405958456  ;
                -0.095121594041544  -0.173246594041544  -0.173246594041544  -0.095121594041544  ;
                 0.214694550466470  -0.644083651399413   0.644083651399412  -0.214694550466470  ;
                -0.062500000000000   0.187500000000000  -0.187500000000000   0.062500000000000  ];
            coefsExpctd(:,:,3) = [ ...
                 0.180373297020772  -0.016310797020772  -0.078810797020772  -0.007126702979228  ;
                 0.619602622720478  -0.056029427745993  -0.270723978212463  -0.024481028678934  ;
                 0.180373297020772  -0.016310797020772  -0.078810797020772  -0.007126702979228  ;
                 0.619602622720478  -0.056029427745993  -0.270723978212463  -0.024481028678934  ];
             
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm2();
            
            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd(:)-coefsActual(:))/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for default construction
        function this = testConstructorWithDeepCopy(this)
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm2();
            cloneLpPuFb = LpPuFb1dVm2(this.lppufb);
            
            % Expected values
            coefsExpctd = double(this.lppufb);
            
            % Actual values
            coefsActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefsExpctd(:)-coefsActual(:))/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Change angles
            angles = randn(size(getAngles(cloneLpPuFb)));
            cloneLpPuFb = setAngles(cloneLpPuFb,angles);
            
            % Actual values
            coefsActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefsExpctd(:)-coefsActual(:))/...
                sqrt(numel(coefsActual));
            this.assert(coefDist>1e-15,sprintf('%g',coefDist));
            
        end

        % Test for construction
        function this = testConstructorWithOrd0(this)
       
            % Invalid input
            dec = 4;
            ord = 0;
            
            % Expected values
            exceptionIdExpctd = 'GenLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Order must be greater than or equal to 2');
            
            % Instantiation of target class
            try 
                LpPuFb1dVm2(dec,ord);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);                
            end
            
        end

        % Test for exception
        function this = testConstructorWithInvalidArguments(this)
            
            % Invalid input
            dec = 4;
            ord = 2;
            sizeInvalid = [ 2 2 ];
            ang = 2*pi*rand(sizeInvalid);
            
            % Expected value
            sizeExpctd = [1 4];
            
            % Expected values
            exceptionIdExpctd = 'GenLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Size of angles must be [ %d %d ]',...
                sizeExpctd(1), sizeExpctd(2));
            
            % Instantiation of target class
            try
                LpPuFb1dVm2(dec,ord,ang);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
            
        end
        
        % Test for char()
        function this = testChar(this)
            
            % Expected value
            charsExpctd = [...
                '[', 10, ...
                9, '-0.0071267 + 0.24794*z^(-1) + 0.75918*z^(-2) + 0.75918*z^(-3) + 0.24794*z^(-4) - 0.0071267*z^(-5);',10,...
                9, '-0.024481 - 0.36585*z^(-1) + 0.39033*z^(-2) + 0.39033*z^(-3) - 0.36585*z^(-4) - 0.024481*z^(-5);',10,...
                9, '0.0071267 + 0.29351*z^(-1) - 0.4474*z^(-2) + 0.4474*z^(-3) - 0.29351*z^(-4) - 0.0071267*z^(-5);',10,...
                9, '0.024481 + 0.20822*z^(-1) + 0.86313*z^(-2) - 0.86313*z^(-3) - 0.20822*z^(-4) - 0.024481*z^(-5)',10,...
                ']' ...
                ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm2();
            
            % Actual values
            charsActual = char(this.lppufb);
            
            % Evaluation
            this.assertEquals(charsExpctd, charsActual);
            
        end

        % Test for construction with order 2
        function this = testConstructorWithDec4Ord2Vm2(this)
            
            % Parameters
            dec = 4;
            ord = 2;
            ang = 2*pi*randn(1,4);
            mus = 2*round(rand(2,4))-1;
            
            % Expected values
            dimExpctd = [dec dec ord+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm2(dec,ord,ang,mus);
            
            % Actual values
            coefsActual = double(this.lppufb);
            dimActual = size(coefsActual);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            
            % Check symmetry
            tmp = coefsActual;
            coefEvn = tmp(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            %
            coefOdd = tmp(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(:,:,ord+1) = ...
                coefActual(:,:,ord+1) - eye(dec);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            P = double(E);
            Gdc = [
                sum(P(1,:))
                sum(P(2,:))
                sum(P(3,:))
                sum(P(4,:))
                ];
            coefDist = norm(Gdc(:).' - [sqrt(prod(dec)) 0 0 0])/...
                sqrt(numel(Gdc));
            this.assert(coefDist<1e-14,sprintf('%g',coefDist));
            
            % Check Vm2
            ckVm2 = checkVm2(this.lppufb);
            this.assert(ckVm2<1e-15,...
                'c=%g: triange condition failed',ckVm2);
            for iSubband = 2:dec
                hi = P(iSubband,:);
                lenH = length(hi);
                ramp = (0:(3*lenH))/(3*lenH);
                res = conv(hi,ramp);
                evl = norm(res(lenH+1:2*lenH))/lenH;
                this.assert(evl<1e-15,sprintf('(%d) %g',...
                    iSubband, evl));
            end
        end
        
        % Test: dec 4 order 4     
        function this = testConstructorWithDec4Ord4AngVm2(this)

            % Parameters
            dec = 4;
            ord = 4;

            % Expected values
            dimExpctd = [dec dec ord+1];

            % Instantiation of target class
            ang = 2*pi*rand(1,6);
            mus = 2*round(rand(2,6))-1;
            sd = 2*round(rand(1))-1;
            this.lppufb = LpPuFb1dVm2(dec,ord,ang,mus,sd);
            warning('OFF','GenLOT:Vm2Violation');
            ckVm2 = checkVm2(this.lppufb);
            while (ckVm2>1e-15)
                ang = 2*pi*rand(1,6);
                mus = 2*round(rand(2,6))-1;
                sd = 2*round(rand(1))-1;
                setAngles(this.lppufb,ang);
                setMus(this.lppufb,mus);
                setSign4Lambda(this.lppufb,sd);
                ckVm2 = checkVm2(this.lppufb);
            end
            warning('ON','GenLOT:Vm2Violation');
            
            % Actual values
            coefsActual = double(this.lppufb);
            dimActual = size(coefsActual);

            % Evaluation
            this.assertEquals(dimExpctd,dimActual);

            % Check symmetry
            tmp = coefsActual(:,:,:);
            coefEvn = tmp(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            %
            coefOdd = tmp(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(:,:,ord+1) = ...
                coefActual(:,:,ord+1) - eye(dec);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            P = double(E);
            Gdc = [
                sum(P(1,:))
                sum(P(2,:))
                sum(P(3,:))
                sum(P(4,:))
                ];
            coefDist = norm(Gdc(:).' - [sqrt(dec) 0 0 0])/...
                sqrt(numel(Gdc));
            this.assert(coefDist<1e-14,sprintf('%g',coefDist));  
            
            % Check Vm2
            for iSubband = 2:dec
                hi = P(iSubband,:);
                lenH = length(hi);
                ramp = (0:(3*lenH))/(3*lenH);
                res = conv(hi,ramp);
                evl = norm(res(lenH+1:2*lenH))/lenH;
                this.assert(evl<1e-15,sprintf('(%d) %g',...
                    iSubband, evl));
            end
            
        end
        
        % Test for construction with dec=8, ord=2
        function this = testConstructorWithDec8Ord2AngVm2(this)
        
            % Parameters
            dec = 8;
            ord = 2;
            
            % Expected values
            dimExpctd = [dec dec ord+1];
            
            % Instantiation of target class
            ang = 2*pi*rand(6,4);
            mus = 2*round(rand(4,4))-1;
            sd = 2*round(rand(1))-1;
            this.lppufb = LpPuFb1dVm2(dec,ord,ang,mus,sd);
            warning('OFF','GenLOT:Vm2Violation');
            ckVm2 = checkVm2(this.lppufb);
            while (ckVm2>1e-15)
                ang = 2*pi*rand(6,4);
                mus = 2*round(rand(4,4))-1;
                sd = 2*round(rand(1))-1;
                setAngles(this.lppufb,ang);
                setMus(this.lppufb,mus);
                setSign4Lambda(this.lppufb,sd);
                ckVm2 = checkVm2(this.lppufb);
            end
            warning('ON','GenLOT:Vm2Violation');
            
            % Actual values
            coefsActual = double(this.lppufb);
            dimActual = size(coefsActual);
            
            % Evaluation
            this.assertEquals(dimExpctd,dimActual);
            
            % Check symmetry
            tmp = coefsActual;
            coefEvn = tmp(1:ceil(end/2),:);
            coefDiff = coefEvn-fliplr(coefEvn);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            %
            coefOdd = tmp(ceil(end/2)+1:end,:);
            coefDiff = coefOdd+fliplr(coefOdd);
            coefDist = norm(coefDiff(:))/sqrt(numel(coefDiff));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check orthogonality
            E = getPolyPhaseMatrix(this.lppufb);
            coefActual = double(E.'*E);
            coefActual(:,:,ord+1) = ...
                coefActual(:,:,ord+1) - eye(dec);
            coefDist = norm(coefActual(:))/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Check DC-leakage
            P = double(E);
            Gdc = [
                sum(P(1,:))
                sum(P(2,:))
                sum(P(3,:))
                sum(P(4,:))
                sum(P(5,:))
                sum(P(6,:))
                sum(P(7,:))
                sum(P(8,:))                
                ];
            coefDist = norm(Gdc(:).' - [sqrt(dec) 0 0 0 0 0 0 0])/...
                sqrt(numel(Gdc));
            this.assert(coefDist<1e-14,sprintf('%g',coefDist));
            
            % Check Vm2
            for iSubband = 2:dec
                hi = P(iSubband,:);
                lenH = length(hi);
                ramp = (0:(3*lenH))/(3*lenH);
                res = conv(hi,ramp);
                evl = norm(res(lenH+1:2*lenH))/lenH;
                this.assert(evl<1e-15,sprintf('(%d) %g',...
                    iSubband, evl));
            end
        end
    end
end
