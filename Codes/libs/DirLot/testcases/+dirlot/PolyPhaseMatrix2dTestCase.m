classdef PolyPhaseMatrix2dTestCase < TestCase
    %POLYPHASEMATRIX2DTESTCASE Test case for PolyPhaseMatrix2d
    %
    % SVN identifier:
    % $Id: PolyPhaseMatrix2dTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        ppm0;
        ppm1;
        ppm2;
    end
    
    methods
         
        function this = tearDown(this)
            delete(this.ppm0)
            delete(this.ppm1)
            delete(this.ppm2)
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Expected values
            coefsExpctd = [];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d();
            
            % Actual values
            coefsActual = double(this.ppm0);
            
            % Evaluation
            this.assertEquals(coefsExpctd, coefsActual);
            
        end
        
        
        % Test for construction with initialization
        function this = testConstructorWithInit(this)
            
            % Input coeffficients
            coefs = [
                1 3
                2 4 ];
            
            % Expected values
            coefsExpctd = coefs;
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefs);
            
            % Actual values
            coefsActual = double(this.ppm0);
            
            % Evaluation
            this.assertEquals(coefsExpctd, coefsActual);
            
        end
        
        % Test for object construction
        function this = testConstructorWithObj(this)
            
            % Input value
            coefs = [
                1 3 ;
                2 4 ];
            
            % Expected value
            coefsExpctd = coefs;
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefs);
            this.ppm1 = PolyPhaseMatrix2d(this.ppm0);
            
            % Actual values
            coefsActual = double(this.ppm1);
            
            % Evaluation
            this.assertEquals(coefsExpctd, coefsActual);
            
        end
        
        % Test for char
        function this = testChar(this)
            
            % Input value
            coefs(:,:,1,1) = [
                1 0 ;
                0 0 ];
            coefs(:,:,2,1) = [
                0 0 ;
                2 0 ];
            coefs(:,:,1,2) = [
                0 3 ;
                0 0 ];
            coefs(:,:,2,2) = [
                0 0 ;
                0 4 ];
            coefs(:,:,3,1) = [
                -5 0 ;
                0 0 ];
            coefs(:,:,1,3) = [
                0 0 ;
                -6 0 ];
            coefs(:,:,3,2) = [
                0 -7 ;
                0  0 ];
            coefs(:,:,2,3) = [
                0  0 ;
                0 -8 ];
            
            % Expected value
            charExpctd = [...
                '[', 10, ... % 10 -> \n
                9, '1 - 5*y^(-2),', 9, ... % 9 -> \t
                '3*x^(-1) - 7*y^(-2)*x^(-1);', 10,... % 10 -> \n
                9, '2*y^(-1) - 6*x^(-2),', 9, ... % 9 -> \t
                '4*y^(-1)*x^(-1) - 8*y^(-1)*x^(-2)', 10,... % 10 -> \n
                ']'...
                ];
            
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefs);
            
            % Actual values
            charActual = char(this.ppm0);
            
            % Display
            %             disp(this.ppm0);
            %             x = 1;
            %             y = 1;
            %             eval(char(this.ppm0));
            
            % Evaluation
            %strcmp(charExpctd,charActual)
            this.assertEquals(charExpctd, charActual);
            
        end
        
        % Test for char with zero elements
        function this = testCharWithZeros(this)
            
            % Input value
            coefs(:,:,1,1) = [
                0 0 ;
                0 0 ];
            coefs(:,:,2,1) = [
                0 0 ;
                1 0 ];
            coefs(:,:,1,2) = [
                0 1 ;
                0 0 ];
            
            % Expected value
            charExpctd = [...
                '[', 10, ... % 10 -> \n
                9, '0,', 9, ... % 9 -> \t
                'x^(-1);', 10,... % 10 -> \n
                9, 'y^(-1),', 9, ... % 9 -> \t
                '0', 10,... % 10 -> \n
                ']'...
                ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefs);
            
            % Actual values
            charActual = char(this.ppm0);
            
            % Display
            %             display(charExpctd);
            %             display(charActual);
            %             x = 2;
            %             y = 2;
            %             eval(char(this.ppm0));
            
            % Evaluation
            %strcmp(charExpctd,charActual)
            this.assertEquals(charExpctd, charActual);
            
        end
        
        % Test for subsref
        function this = testSubsRef(this)
            
            % Input value
            coefs(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefs(:,:,2,1) = [
                2 -2 ;
                2 -2 ];
            coefs(:,:,1,2) = [
                3 3 ;
                -3 -3 ];
            coefs(:,:,2,2) = [
                4 -4 ;
                -4 4 ];
            
            % Expected value
            ppfExpctd11 = [ 1 3 ; 2 4 ];
            ppfExpctd21 = [ 1 -3 ; 2 -4 ];
            ppfExpctd12 = [ 1 3 ; -2 -4 ];
            ppfExpctd22 = [ 1 -3 ; -2 4 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefs);
            
            % Actual values
            ppfActual11 = this.ppm0(1,1);
            ppfActual21 = this.ppm0(2,1);
            ppfActual12 = this.ppm0(1,2);
            ppfActual22 = this.ppm0(2,2);
            
            % Evaluation
            this.assertEquals(ppfExpctd11, ppfActual11);
            this.assertEquals(ppfExpctd21, ppfActual21);
            this.assertEquals(ppfExpctd12, ppfActual12);
            this.assertEquals(ppfExpctd22, ppfActual22);
            
        end
        
        % Test for plus
        function this = testPlus(this)
            
            % Input value
            coefsA(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefsA(:,:,2,1) = [
                2 2 ;
                2 2 ];
            coefsA(:,:,1,2) = [
                3 3 ;
                3 3 ];
            coefsA(:,:,2,2) = [
                4 4 ;
                4 4 ];
            
            % Input value
            coefsB(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefsB(:,:,2,1) = [
                2 -2 ;
                2 -2 ];
            coefsB(:,:,1,2) = [
                3 3 ;
                -3 -3 ];
            coefsB(:,:,3,3) = [
                5 -5 ;
                -5 5 ];
            
            % Expected value
            coefsCExpctd(:,:,1,1) = [
                2 2 ;
                2 2 ];
            coefsCExpctd(:,:,2,1) = [
                4 0 ;
                4 0 ];
            coefsCExpctd(:,:,1,2) = [
                6 6 ;
                0 0 ];
            coefsCExpctd(:,:,2,2) = [
                4 4 ;
                4 4 ];
            coefsCExpctd(:,:,3,3) = [
                5 -5 ;
                -5 5 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefsA);
            this.ppm1 = PolyPhaseMatrix2d(coefsB);
            
            % Actual values
            this.ppm2 = this.ppm0 + this.ppm1;
            
            coefsCActual = double(this.ppm2);
            
            % Evaluation
            this.assertEquals(size(coefsCExpctd), size(coefsCActual));
            diff = norm(coefsCExpctd(:)-coefsCActual(:))/numel(coefsCExpctd);
            this.assert(diff<1e-15);
            
        end
        
        % Test for minus
        function this = testMinus(this)
            
            % Input value
            coefsA(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefsA(:,:,2,1) = [
                2 2 ;
                2 2 ];
            coefsA(:,:,1,2) = [
                3 3 ;
                3 3 ];
            coefsA(:,:,2,2) = [
                4 4 ;
                4 4 ];
            
            % Input value
            coefsB(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefsB(:,:,2,1) = [
                2 -2 ;
                2 -2 ];
            coefsB(:,:,1,2) = [
                3 3 ;
                -3 -3 ];
            coefsB(:,:,3,3) = [
                5 -5 ;
                -5 5 ];
            
            % Expected value
            coefsCExpctd(:,:,1,1) = [
                0 0 ;
                0 0 ];
            coefsCExpctd(:,:,2,1) = [
                0 4 ;
                0 4 ];
            coefsCExpctd(:,:,1,2) = [
                0 0 ;
                6 6 ];
            coefsCExpctd(:,:,2,2) = [
                4 4 ;
                4 4 ];
            coefsCExpctd(:,:,3,3) = [
                -5 5 ;
                5 -5 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefsA);
            this.ppm1 = PolyPhaseMatrix2d(coefsB);
            
            % Actual values
            this.ppm2 = this.ppm0 - this.ppm1;
            
            coefsCActual = double(this.ppm2);
            
            % Evaluation
            this.assertEquals(size(coefsCExpctd), size(coefsCActual));
            diff = norm(coefsCExpctd(:)-coefsCActual(:))/numel(coefsCExpctd);
            this.assert(diff<1e-15); 
        end
        
        % Test for mtimes
        function this = testMTimes(this)
            
            % Input value
            coefsA(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefsA(:,:,2,1) = [
                2 2 ;
                2 2 ];
            coefsA(:,:,1,2) = [
                3 3 ;
                3 3 ];
            coefsA(:,:,2,2) = [
                4 4 ;
                4 4 ];
            
            % Input value
            coefsB(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefsB(:,:,2,1) = [
                1 -1 ;
                1 -1 ];
            coefsB(:,:,1,2) = [
                1 1 ;
                -1 -1 ];
            coefsB(:,:,2,2) = [
                1 -1 ;
                -1  1 ];
            
            % Expected value
            coefsCExpctd(:,:,1,1) = [
                2     2 ;
                2     2 ];
            coefsCExpctd(:,:,2,1) = [
                6     2 ;
                6     2 ];
            coefsCExpctd(:,:,3,1) = [
                4    -4 ;
                4    -4 ];
            coefsCExpctd(:,:,1,2) = [
                6     6 ;
                6     6 ];
            coefsCExpctd(:,:,2,2) = [
                14     2 ;
                14     2 ];
            coefsCExpctd(:,:,3,2) = [
                8    -8 ;
                8    -8 ];
            coefsCExpctd(:,:,1,3) = [
                0     0 ;
                0     0 ];
            coefsCExpctd(:,:,2,3) = [
                0     0
                0     0 ];
            coefsCExpctd(:,:,3,3) = [
                0     0
                0     0 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefsA);
            this.ppm1 = PolyPhaseMatrix2d(coefsB);
            
            % Actual values
            this.ppm2 = this.ppm0 * this.ppm1;
            
            coefsCActual = double(this.ppm2);
            
            % Evaluation
            this.assertEquals(size(coefsCExpctd), size(coefsCActual));
            diff = norm(coefsCExpctd(:)-coefsCActual(:))/numel(coefsCExpctd);
            this.assert(diff<1e-15);
            
        end
        
        % Test for mtimes
        function this = testPlusScaler(this)
            
            % Input value
            coefsA(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefsA(:,:,2,1) = [
                2 2 ;
                2 2 ];
            coefsA(:,:,1,2) = [
                3 3 ;
                3 3 ];
            coefsA(:,:,2,2) = [
                4 4 ;
                4 4 ];
            
            % Input value
            scaler = 10;
            
            % Expected value
            coefsCExpctd(:,:,1,1) = [
                11    11 ;
                11    11 ];
            coefsCExpctd(:,:,2,1) = [
                12    12 ;
                12     12 ];
            coefsCExpctd(:,:,1,2) = [
                13    13 ;
                13    13 ];
            coefsCExpctd(:,:,2,2) = [
                14    14 ;
                14    14 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefsA);
            
            % Actual values
            this.ppm1 = this.ppm0 + scaler;
            
            coefsCActual = double(this.ppm1);
            
            % Evaluation
            this.assertEquals(size(coefsCExpctd), size(coefsCActual));
            diff = norm(coefsCExpctd(:)-coefsCActual(:))/numel(coefsCExpctd);
            this.assert(diff<1e-15);
            
        end
        
        % Test for minus scaler
        function this = testMinusScaler(this)
            
            % Input value
            coefsA(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefsA(:,:,2,1) = [
                2 2 ;
                2 2 ];
            coefsA(:,:,1,2) = [
                3 3 ;
                3 3 ];
            coefsA(:,:,2,2) = [
                4 4 ;
                4 4 ];
            
            % Input value
            scaler = 10;
            
            % Expected value
            coefsCExpctd(:,:,1,1) = - [
                9   9 ;
                9   9 ];
            coefsCExpctd(:,:,2,1) = - [
                8   8 ;
                8   8 ];
            coefsCExpctd(:,:,1,2) = - [
                7   7 ;
                7   7 ];
            coefsCExpctd(:,:,2,2) = - [
                6   6 ;
                6   6 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefsA);
            
            % Actual valu
            this.ppm1 = this.ppm0 - scaler;
            
            coefsCActual = double(this.ppm1);
            
            % Evaluation
            this.assertEquals(size(coefsCExpctd), size(coefsCActual));
            diff = norm(coefsCExpctd(:)-coefsCActual(:))/numel(coefsCExpctd);
            this.assert(diff<1e-15);
            
        end
        
        % Test for mtimes
        function this = testMTimesScaler(this)
            
            % Input value
            coefsA(:,:,1,1) = [
                1 1 ;
                1 1 ];
            coefsA(:,:,2,1) = [
                2 2 ;
                2 2 ];
            coefsA(:,:,1,2) = [
                3 3 ;
                3 3 ];
            coefsA(:,:,2,2) = [
                4 4 ;
                4 4 ];
            
            % Input value
            scaler = 10;
            
            % Expected value
            coefsCExpctd(:,:,1,1) = [
                10 10 ;
                10 10 ];
            coefsCExpctd(:,:,2,1) = [
                20 20 ;
                20 20 ];
            coefsCExpctd(:,:,1,2) = [
                30 30 ;
                30 30 ];
            coefsCExpctd(:,:,2,2) = [
                40 40 ;
                40 40 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefsA);
            
            % Actual values
            this.ppm1 = this.ppm0 * scaler;
            
            coefsCActual = double(this.ppm1);
            
            % Evaluation
            this.assertEquals(size(coefsCExpctd), size(coefsCActual));
            diff = norm(coefsCExpctd(:)-coefsCActual(:))/numel(coefsCExpctd);
            this.assert(diff<1e-15);
            
        end
        
        % Test for mtimes
        function this = testMTimes4x4(this)
            
            % Input value
            coefsA(:,:,1,1) = [
                1  1  1  1;
                1  1 -1 -1;
                1 -1  1 -1;
                1 -1 -1  1 ];
            
            % Input value
            coefsB(:,:,1,1) = [
                1  0  0  0;
                0  0  0  0;
                0  0  0  0;
                0  0  0  0 ];
            coefsB(:,:,2,1) = [
                0  0  0  0;
                0  1  0  0;
                0  0  0  0;
                0  0  0  0 ];
            coefsB(:,:,1,2) = [
                0  0  0  0;
                0  0  0  0;
                0  0  1  0;
                0  0  0  0 ];
            coefsB(:,:,2,2) = [
                0  0  0  0;
                0  0  0  0;
                0  0  0  0;
                0  0  0  1];
            
            % Expected value
            coefsCExpctd(:,:,1,1) = [
                1  0  0  0;
                1  0  0  0;
                1  0  0  0;
                1  0  0  0 ];
            coefsCExpctd(:,:,2,1) = [
                0  1  0  0;
                0  1  0  0;
                0 -1  0  0;
                0 -1  0  0 ];
            coefsCExpctd(:,:,1,2) = [
                0  0  1  0;
                0  0 -1  0;
                0  0  1  0;
                0  0 -1  0 ];
            coefsCExpctd(:,:,2,2) = [
                0  0  0  1;
                0  0  0 -1;
                0  0  0 -1;
                0  0  0  1];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coefsA);
            this.ppm1 = PolyPhaseMatrix2d(coefsB);
            
            % Actual values
            this.ppm2 = this.ppm0 * this.ppm1;
            
            coefsCActual = double(this.ppm2);
            
            % Evaluation
            this.assertEquals(size(coefsCExpctd), size(coefsCActual));
            diff = norm(coefsCExpctd(:)-coefsCActual(:))/numel(coefsCExpctd);
            this.assert(diff<1e-15);
            
        end
        
        % Test for ctranspose
        function this = testCtranspose(this)
            
            % Input value
            coef(:,:,1,1) = [
                1  0  0  0;
                1i  0  0  0;
                1  0  0  0;
                1i  0  0  0 ];
            coef(:,:,2,1) = [
                0  1  0  0;
                0  1i  0  0;
                0 -1  0  0;
                0 -1i  0  0 ];
            coef(:,:,1,2) = [
                0  0  1  0;
                0  0 -1i  0;
                0  0  1  0;
                0  0 -1i  0 ];
            coef(:,:,2,2) = [
                0  0  0  1;
                0  0  0 -1i;
                0  0  0 -1;
                0  0  0  1i];
            
            % Expected value
            coefExpctd(:,:,2,2) = [
                1 -1i  1 -1i;
                0  0  0  0;
                0  0  0  0;
                0  0  0  0 ];
            coefExpctd(:,:,1,2) = [
                0  0  0  0;
                1 -1i -1  1i;
                0  0  0  0;
                0  0  0  0 ];
            coefExpctd(:,:,2,1) = [
                0  0  0  0;
                0  0  0  0;
                1  1i  1  1i;
                0  0  0  0 ];
            coefExpctd(:,:,1,1) = [
                0  0  0  0;
                0  0  0  0;
                0  0  0  0;
                1  1i -1 -1i];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coef);
            
            % Actual values
            this.ppm0 = this.ppm0';
            
            coefActual = double(this.ppm0);
            
            % Evaluation
            this.assertEquals(size(coefExpctd), size(coefActual));
            diff = norm(coefExpctd(:)-coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15);
            
        end
        
        % Test for transpose
        function this = testTranspose(this)
            
            % Input value
            coef(:,:,1,1) = [
                1  0  0  0;
                1i  0  0  0;
                1  0  0  0;
                1i  0  0  0 ];
            coef(:,:,2,1) = [
                0  1  0  0;
                0  1i  0  0;
                0 -1  0  0;
                0 -1i  0  0 ];
            coef(:,:,1,2) = [
                0  0  1  0;
                0  0 -1i  0;
                0  0  1  0;
                0  0 -1i  0 ];
            coef(:,:,2,2) = [
                0  0  0  1;
                0  0  0 -1i;
                0  0  0 -1;
                0  0  0  1i];
            
            % Expected value
            coefExpctd(:,:,2,2) = [
                1  1i  1  1i;
                0  0  0  0;
                0  0  0  0;
                0  0  0  0 ];
            coefExpctd(:,:,1,2) = [
                0  0  0  0;
                1  1i -1 -1i;
                0  0  0  0;
                0  0  0  0 ];
            coefExpctd(:,:,2,1) = [
                0  0  0  0;
                0  0  0  0;
                1 -1i  1 -1i;
                0  0  0  0 ];
            coefExpctd(:,:,1,1) = [
                0  0  0  0;
                0  0  0  0;
                0  0  0  0;
                1 -1i -1  1i];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coef);
            
            % Actual values
            this.ppm0 = this.ppm0.';
            
            coefActual = double(this.ppm0);
            
            % Evaluation
            this.assertEquals(size(coefExpctd), size(coefActual));
            diff = norm(coefExpctd(:)-coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15);
        end
        
        % Test for vertical upsampling
        function this = testUpsampleVertical(this)
            
            % Parameters
            factorUy = 2;
            direction = Direction.VERTICAL;
            
            % Input value
            coef(:,:,1,1) = [
                1  1 ;
                1  1 ];
            coef(:,:,2,1) = [
                2  2 ;
                2  2 ];
            coef(:,:,1,2) = [
                3  3 ;
                3  3 ];
            coef(:,:,2,2) = [
                4  4 ;
                4  4 ];
            
            % Expected value
            coefExpctd(:,:,1,1) = [
                1  1 ;
                1  1 ];
            coefExpctd(:,:,2,1) = [
                0  0 ;
                0  0 ];
            coefExpctd(:,:,3,1) = [
                2  2 ;
                2  2 ];
            coefExpctd(:,:,1,2) = [
                3  3 ;
                3  3 ];
            coefExpctd(:,:,2,2) = [
                0  0 ;
                0  0 ];
            coefExpctd(:,:,3,2) = [
                4  4 ;
                4  4 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coef);
            
            % Actual value
            coefActual = double(upsample(this.ppm0,factorUy,direction));
            
            % Evaluation
            this.assertEquals(size(coefExpctd), size(coefActual));
            diff = norm(coefExpctd(:)-coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15);
            
        end
        
        function this = testUpsampleHorizontal(this)
            
            % Parameters
            factorUy = 2;
            direction = Direction.HORIZONTAL;
            
            % Input value
            coef(:,:,1,1) = [
                1  1 ;
                1  1 ];
            coef(:,:,2,1) = [
                2  2 ;
                2  2 ];
            coef(:,:,1,2) = [
                3  3 ;
                3  3 ];
            coef(:,:,2,2) = [
                4  4 ;
                4  4 ];
            
            % Expected value
            coefExpctd(:,:,1,1) = [
                1  1 ;
                1  1 ];
            coefExpctd(:,:,2,1) = [
                2  2 ;
                2  2 ];
            coefExpctd(:,:,1,2) = [
                0  0 ;
                0  0 ];
            coefExpctd(:,:,1,3) = [
                3  3 ;
                3  3 ];
            coefExpctd(:,:,2,2) = [
                0  0 ;
                0  0 ];
            coefExpctd(:,:,2,3) = [
                4  4 ;
                4  4 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coef);
            
            % Actual value
            coefActual = double(upsample(this.ppm0,factorUy,direction));
            
            % Evaluation
            this.assertEquals(size(coefExpctd), size(coefActual));
            diff = norm(coefExpctd(:)-coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15);
            
        end
        
        function this = testUpsampleVerticalHorizontal(this)
            
            % Parameters
            factorUy = [2 2];
            direction = [Direction.VERTICAL Direction.HORIZONTAL];
            
            % Input value
            coef(:,:,1,1) = [
                1  1 ;
                1  1 ];
            coef(:,:,2,1) = [
                2  2 ;
                2  2 ];
            coef(:,:,1,2) = [
                3  3 ;
                3  3 ];
            coef(:,:,2,2) = [
                4  4 ;
                4  4 ];
            
            % Expected value
            coefExpctd(:,:,1,1) = [
                1  1 ;
                1  1 ];
            coefExpctd(:,:,2,1) = [
                0  0 ;
                0  0 ];
            coefExpctd(:,:,3,1) = [
                2  2 ;
                2  2 ];
            coefExpctd(:,:,1,2) = [
                0  0 ;
                0  0 ];
            coefExpctd(:,:,2,2) = [
                0  0 ;
                0  0 ];
            coefExpctd(:,:,2,3) = [
                0  0 ;
                0  0 ];
            coefExpctd(:,:,1,3) = [
                3  3 ;
                3  3 ];
            coefExpctd(:,:,2,3) = [
                0  0 ;
                0  0 ];
            coefExpctd(:,:,3,3) = [
                4  4 ;
                4  4 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coef);
            
            % Actual value
            coefActual = double(upsample(this.ppm0,factorUy,direction));
            
            % Evaluation
            this.assertEquals(size(coefExpctd), size(coefActual));
            diff = norm(coefExpctd(:)-coefActual(:))/numel(coefExpctd);
            this.assert(diff<1e-15);
            
        end
        
        function this = testUpsampleForConstant(this)
            
            % Parameters
            factorUy = [2 2];
            direction = [Direction.VERTICAL Direction.HORIZONTAL];
            
            % Input value
            coef = [
                1  1 ;
                1  1 ];
            
            % Expected value
            coefExpctd = [
                1  1 ;
                1  1 ];
            
            % Instantiation of target class
            this.ppm0 = PolyPhaseMatrix2d(coef);
            
            % Actual value
            coefActual = double(upsample(this.ppm0,factorUy,direction));
            
            % Evaluation
            this.assertEquals(coefExpctd, coefActual);
        end
    end
end
