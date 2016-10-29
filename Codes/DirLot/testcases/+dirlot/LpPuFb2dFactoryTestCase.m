classdef LpPuFb2dFactoryTestCase < TestCase
    %LPPUFB2DFACTORYTESTCASE Test case for LpPuFb2dFactory
    %
    % SVN identifier:
    % $Id: LpPuFb2dFactoryTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        
        function this = testCreateLpPuFb2dVm0(this)
            
            % Parameters
            vm = 0;
            
            % Expected values
            classExpctd = 'LpPuFb2dVm0';
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(vm);
            
            % Actual values
            classActual = class(this.lppufb);
            
            % Evaluation
            this.assertEquals(classExpctd,classActual);
            
        end
        
        function this = testCreateLpPuFb2dVm1(this)
            
            % Parameters
            vm = 1;
            
            % Expected values
            classExpctd = 'LpPuFb2dVm1';
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(vm);
            
            % Actual values
            classActual = class(this.lppufb);
            
            % Evaluation
            this.assertEquals(classExpctd,classActual);
            
        end
        
        function this = testCreateLpPuFb2dVm2(this)
            
            % Parameters
            vm = 2;
            
            % Expected values
            classExpctd = 'LpPuFb2dVm2';
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(vm);
            
            % Actual values
            classActual = class(this.lppufb);
            
            % Evaluation
            this.assertEquals(classExpctd,classActual);
            
        end
        
        function this = testCreateLpPuFb2dTvm(this)
            
            % Parameters
            vm = 'd0';
            
            % Expected values
            classExpctd = 'LpPuFb2dTvm';
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(vm);
            
            % Actual values
            classActual = class(this.lppufb);
            
            % Evaluation
            this.assertEquals(classExpctd,classActual);
            
        end
        
        function this = testInvalidArguments(this)
            
            % Parameters
            vm = -1;
            
            % Expected values
            exceptionIdExpctd = 'DirLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Unsupported type of vanishing moments');
            
            % Instantiation of target class
            try
                LpPuFb2dFactory.createLpPuFb2d(vm);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);
            end
        end
        
        function this = testCreateLpPuFb2dVm0DeepCopy(this)
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d();
            cloneLpPuFb = LpPuFb2dFactory.createLpPuFb2d(this.lppufb);
            
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
        
        function this = testCreateLpPuFb2dDec44Ord22Vm2DeepCopy(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = 2*pi*rand(28,6);
            mus = 2*round(rand(8,6))-1;
            vm = 2;
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(vm,dec,ord,ang,mus);
            cloneLpPuFb = LpPuFb2dFactory.createLpPuFb2d(this.lppufb);
            
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
        
        function this = testCreateLpPuFb2dDec44Ord22Vm1DeepCopy(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = 2*pi*rand(28,6);
            mus = 2*round(rand(8,6))-1;
            vm = 1;
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(vm,dec,ord,ang,mus);
            cloneLpPuFb = LpPuFb2dFactory.createLpPuFb2d(this.lppufb);
            
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
        
        function this = testCreateLpPuFb2dDec44Ord22Tvm120DeepCopy(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = 2*pi*rand(28,6);
            mus = 2*round(rand(8,6))-1;
            vm = 'd120';
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(vm,dec,ord,ang,mus);
            cloneLpPuFb = LpPuFb2dFactory.createLpPuFb2d(this.lppufb);
            
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
