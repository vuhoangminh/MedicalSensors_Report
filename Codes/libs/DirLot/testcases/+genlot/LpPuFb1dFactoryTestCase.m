classdef LpPuFb1dFactoryTestCase < TestCase
    %LPPUFB1DFACTORYTESTCASE Test case for LpPuFb1dFactory
    %
    % SVN identifier:
    % $Id: LpPuFb1dFactoryTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        lppufb;
    end
    
    methods
         
        function this = tearDown(this)
            delete(this.lppufb)
        end
        
        function this = testCreateLpPuFb1dVm0(this)
            
            % Parameters
            vm = 0;
            
            % Expected values
            classExpctd = 'LpPuFb1dVm0';
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dFactory.createLpPuFb1d(vm);
            
            % Actual values
            classActual = class(this.lppufb);
            
            % Evaluation
            this.assertEquals(classExpctd,classActual);
            
        end
        
        function this = testCreateLpPuFb1dVm1(this)
            
            % Parameters
            vm = 1;
            
            % Expected values
            classExpctd = 'LpPuFb1dVm1';
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dFactory.createLpPuFb1d(vm);
            
            % Actual values
            classActual = class(this.lppufb);
            
            % Evaluation
            this.assertEquals(classExpctd,classActual);
            
        end
        
        function this = testCreateLpPuFb1dVm2(this)
            
            % Parameters
            vm = 2;
            
            % Expected values
            classExpctd = 'LpPuFb1dVm2';
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dFactory.createLpPuFb1d(vm);
            
            % Actual values
            classActual = class(this.lppufb);
            
            % Evaluation
            this.assertEquals(classExpctd,classActual);
            
        end

        function this = testInvalidArguments(this)
            
            % Parameters
            vm = -1;
            
            % Expected values
            exceptionIdExpctd = 'GenLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Unsupported type of vanishing moments');
            
            % Instantiation of target class
            try
                LpPuFb1dFactory.createLpPuFb1d(vm);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
        end
        
        function this = testCreateLpPuFb1dVm0DeepCopy(this)
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dFactory.createLpPuFb1d();
            cloneLpPuFb = LpPuFb1dFactory.createLpPuFb1d(this.lppufb);
            
            % Expected values
            coefExpctd = double(this.lppufb);
            
            % Actual values
            coefActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Change angles
            angles = randn(size(getAngles(cloneLpPuFb)));
            cloneLpPuFb = setAngles(cloneLpPuFb,angles);
            
            % Actual values
            coefActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist>1e-15,sprintf('%g',coefDist));
            
        end
        
        function this = testCreateLpPuFb1dDec4Ord2Vm2DeepCopy(this)
            
            % Parameters
            dec = 4;
            ord = 2;
            ang = 2*pi*randn(1,4);
            mus = 2*round(rand(2,4))-1;
            vm = 2;
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord,ang,mus);
            cloneLpPuFb = LpPuFb1dFactory.createLpPuFb1d(this.lppufb);
            
            % Expected values
            coefExpctd = this.lppufb(dec);
            
            % Actual values
            coefActual = cloneLpPuFb(dec);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Change angles
            angles = randn(size(getAngles(cloneLpPuFb)));
            cloneLpPuFb = setAngles(cloneLpPuFb,angles);
            
            % Actual values
            coefActual = cloneLpPuFb(dec);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))/...
                sqrt(numel(coefActual));
            this.assert(coefDist>1e-15,sprintf('%g',coefDist));
            
        end
        
        function this = testCreateLpPuFb1dDec4Ord2Vm1DeepCopy(this)
            
            % Parameters
            dec = 4;
            ord = 2;
            ang = 2*pi*randn(1,4);
            mus = 2*round(rand(2,4))-1;
            vm = 1;
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dFactory.createLpPuFb1d(vm,dec,ord,ang,mus);
            cloneLpPuFb = LpPuFb1dFactory.createLpPuFb1d(this.lppufb);
            
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

    end
end
