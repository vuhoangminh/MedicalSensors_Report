classdef LpPuFb1dVm0TestCase < TestCase
    %LPPUFB1DVM0TESTCASE Test case for LpPuFb1dVm0
    %
    % SVN identifier:
    % $Id: LpPuFb1dVm0TestCase.m 249 2011-11-27 01:55:42Z sho $
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
            coefsExpctd(:,:) = [ ...
                0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000;
                0.500000000000000  -0.500000000000000  -0.500000000000000   0.500000000000000;
                -0.653281482438188  -0.270598050073099   0.270598050073099  0.653281482438188;
                -0.270598050073099   0.653281482438188  -0.653281482438188  0.270598050073099  ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0();
            
            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
    
        % Test for default construction
        function this = testConstructorWithDeepCopy(this)

            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0();
            cloneLpPuFb = LpPuFb1dVm0(this.lppufb);

            % Expected values
            coefsExpctd = double(this.lppufb);

            % Actual values
            coefsActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            % Change angles
            angles = randn(size(getAngles(cloneLpPuFb)));
            cloneLpPuFb = setAngles(cloneLpPuFb,angles);
            
            % Actual values
            coefsActual = double(cloneLpPuFb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)/...
                sqrt(numel(coefsActual));
            this.assert(coefDist>1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction
        function this = testConstructorWithOrd0(this)

            % Parameters
            dec = 4;
            ord = 0;
            
            % Expected values
            coefsExpctd = [ ...
                0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000;
                0.500000000000000  -0.500000000000000  -0.500000000000000   0.500000000000000;
                -0.653281482438188  -0.270598050073099  0.270598050073099  0.653281482438188;
                -0.270598050073099   0.653281482438188  -0.653281482438188  0.270598050073099  ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord);

            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end

        % Test for construction
        function this = testConstructorWithOrd0Ang(this)

            % Parameters
            dec = 4;
            ord = 0;
            ang = [ 0 0 ];
            
            % Expected values
            coefsExpctd = [ ...
                0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000;
                0.500000000000000  -0.500000000000000  -0.500000000000000   0.500000000000000;
                -0.653281482438188  -0.270598050073099   0.270598050073099  0.653281482438188;
                -0.270598050073099   0.653281482438188  -0.653281482438188  0.270598050073099  ];

            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,ang);

            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction
        function this = testConstructorWithAngPi3Pi4(this)

            % Parameters
            dec = 4;
            ord = 0;
            ang = [ pi/3 pi/4 ];
            
            % Expected values
            matrixW0 = double(GivensRotations(ang(1)));                        
            matrixU0 = double(GivensRotations(ang(2)));
            coefsExpctd = blkdiag(matrixW0, matrixU0) * [ ...
                0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000;
                0.500000000000000  -0.500000000000000  -0.500000000000000   0.500000000000000;
                -0.653281482438188  -0.270598050073099   0.270598050073099  0.653281482438188;
                -0.270598050073099   0.653281482438188  -0.653281482438188  0.270598050073099  ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,ang);

            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for invalid arguments
        function this = testConstructorWithInvalidArguments(this)

            % Invalid input
            dec = 4;
            ord = 0;
            sizeInvalid = [ 2 2 ];
            ang = 2*pi*rand(sizeInvalid);
            
            % Expected value
            sizeExpctd = [ 1 2 ];
            
            % Expected values
            exceptionIdExpctd = 'GenLOT:IllegalArgumentException';
            messageExpctd = ...
                sprintf('Size of angles must be [ %d %d ]',...
                sizeExpctd(1), sizeExpctd(2));
            
            % Instantiation of target class
            try 
                LpPuFb1dVm0(dec,ord,ang);
                this.fail(sprintf('%s must be thrown.',...
                    exceptionIdExpctd));
            catch me
                exceptionIdActual = me.identifier;
                this.assertEquals(exceptionIdExpctd, exceptionIdActual);
                messageActual = me.message;
                this.assertEquals(messageExpctd, messageActual);                
            end
        end
        
        % Test for construction
        function this = testConstructorWithMusPosNeg(this)

            % Parameters
            dec = 4;
            ord = 0;
            ang = [ 0 0 ];
            mus = [ 1 1 ; -1 -1 ];
            
            % Expected values
            coefsExpctd = [ ...
                0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000;
               -0.500000000000000   0.500000000000000   0.500000000000000  -0.500000000000000;
               -0.653281482438188  -0.270598050073099   0.270598050073099   0.653281482438188;
                0.270598050073099  -0.653281482438188   0.653281482438188  -0.270598050073099  ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,ang,mus);

            % Actual values
            coefsActual = double(this.lppufb);

            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 1
        function this = testConstructorWithOrd1(this)

            % Parameters
            dec = 4;
            ord = 1;
            ang = 0;
            
            % Expected values  
            I = eye(4);
            P = [ I(1:2:end,:) ; I(2:2:end,:) ];
            C = P*fliplr(dctmtx(dec));
            D = C(1:2,:)+C(3:4,:);
            coefsExpctd(:,:,1) = [ D; -D ]/2; 
            coefsExpctd(:,:,2) = [ fliplr(D); fliplr(D) ]/2;
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,ang);

            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd(:)-coefsActual(:))...
                /sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            sizeDiff = norm(size(coefsExpctd)-size(coefsActual));
            this.assert(sizeDiff == 0,sprintf('%g',sizeDiff));
            
        end
        
        % Test for construction with order 2
        function this = testConstructorWithOrd2(this)

            % Parameters
            dec = 4;
            ord = 2;
            ang = 0;
            
            % Expected values        
            coefsExpctd(:,:,1) = [
                0         0         0         0;
                0         0         0         0;
                0         0         0         0;
                0         0         0         0 ];
            coefsExpctd(:,:,2) = [ ...
                0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000;
                0.500000000000000  -0.500000000000000  -0.500000000000000   0.500000000000000;
               -0.653281482438188  -0.270598050073099   0.270598050073099   0.653281482438188;
               -0.270598050073099   0.653281482438188  -0.653281482438188   0.270598050073099 ];
            coefsExpctd(:,:,3) = [
                0         0         0         0;
                0         0         0         0;
                0         0         0         0;
                0         0         0         0 ];

            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,ang);

            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd(:)-coefsActual(:))...
                /sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            sizeDiff = norm(size(coefsExpctd)-size(coefsActual));
            this.assert(sizeDiff == 0,sprintf('%g',sizeDiff));
            
        end
        
        % Test: dec 4 order 2     
        function this = testConstructorWithDec4Ord2Ang(this)

            % Parameters
            dec = 4;
            ord = 2;
            ang = 2*pi*rand(1,4);

            % Expected values
            dimExpctd = [dec(1) dec(1) ord(1)+1 ];

            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,ang);

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
            
        end
        
        % Test for setting angles
        function this = testSetAngles(this)

            % Parameters
            dec = 4;
            ord = 0;
            angPre = [ pi/4 pi/4 ];
            angPst = [ 0 0 ];
            
            % Expected values
            coefsExpctd = [ ...
                0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000;
                0.500000000000000  -0.500000000000000  -0.500000000000000   0.500000000000000;
               -0.653281482438188  -0.270598050073099   0.270598050073099   0.653281482438188;
               -0.270598050073099   0.653281482438188  -0.653281482438188   0.270598050073099 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,angPre);

            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)...
                /sqrt(numel(coefsActual));
            this.assert(coefDist>=1e-15,sprintf('%g',coefDist));
            
            % Set angles
            this.lppufb = setAngles(this.lppufb,angPst);
            
            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)...
                /sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for setting mus
        function this = testSetMus(this)

            % Parameters
            dec = 4;
            ord = 0;
            ang = [ 0 0 ];
            musPre = [ 1 -1 ; 1 -1 ];
            musPst = 1;
            
            % Expected values
            coefsExpctd(:,:) = [ ...
                0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000;
                0.500000000000000  -0.500000000000000  -0.500000000000000   0.500000000000000;
               -0.653281482438188  -0.270598050073099   0.270598050073099   0.653281482438188;
               -0.270598050073099   0.653281482438188  -0.653281482438188   0.270598050073099 ];

            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,ang,musPre);

            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)...
                /sqrt(numel(coefsActual));
            this.assert(coefDist>=1e-15,sprintf('%g',coefDist));
            
            % Set angles
            this.lppufb = setMus(this.lppufb,musPst);
            
            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)...
                /sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for char 
        function this = testChar(this)

            % Expected value
            charsExpctd = [...
               '[', 10, ...
                9, '0.5 + 0.5*z^(-1) + 0.5*z^(-2) + 0.5*z^(-3);', 10, ... 
                9, '0.5 - 0.5*z^(-1) - 0.5*z^(-2) + 0.5*z^(-3);', 10, ... 
                9, '-0.65328 - 0.2706*z^(-1) + 0.2706*z^(-2) + 0.65328*z^(-3);', 10, ... 
                9, '-0.2706 + 0.65328*z^(-1) - 0.65328*z^(-2) + 0.2706*z^(-3)', 10, ... 
                ']' ...
                ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0();
            
            % Actual values
            charsActual = char(this.lppufb);
            
            % Evaluation
            this.assertEquals(charsExpctd, charsActual);

        end

        % Test for subsref
        function this = testSubsRef(this)

            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0();

            % Expected value
            impExpctd{1} = [0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000];
            impExpctd{2} = [0.500000000000000  -0.500000000000000  -0.500000000000000   0.500000000000000];
            impExpctd{3} = [-0.653281482438188  -0.270598050073099   0.270598050073099  0.653281482438188];
            impExpctd{4} = [-0.270598050073099   0.653281482438188  -0.653281482438188  0.270598050073099];

            % Actual values
            impActual{1} = this.lppufb(1);
            impActual{2} = this.lppufb(2);
            impActual{3} = this.lppufb(3);
            impActual{4} = this.lppufb(4);
            
            % Evaluation
            for iSubband = 1:length(impExpctd)
                dist = norm(impExpctd{iSubband}-impActual{iSubband})/...
                    length(impExpctd{iSubband});
                this.assert(dist<1e-15,sprintf('(%2d) %g',iSubband,dist));
            end
    
        end

        % Test for construction with dec=8
        function this = testConstructorWithDec8(this)
            
            % Parameters
            dec = 8;
            
            % Expected values
            C = dctmtx(dec);
            coefsExpctd(:,:) = [ C(1:2:end,:); -C(2:2:end,:) ];

            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec);
            
            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd-coefsActual)/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end

        % Test for construction with dec=8, ord=2
        function this = testConstructorWithDec8Ord2(this)
            
            % Parameters
            dec = 8;
            ord = 2;
            
            % Expected values
            C = dctmtx(dec);
            coefsExpctd = zeros(dec,dec,ord+1);
            coefsExpctd(:,:,2) = [ C(1:2:end,:); -C(2:2:end,:) ];

            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord);
            
            % Actual values
            coefsActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefsExpctd(:)-coefsActual(:))/...
                sqrt(numel(coefsActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end

        % Test: dec 4 order 4     
        function this = testConstructorWithDec4Ord4Ang(this)

            % Parameters
            dec = 4;
            ord = 4;
            ang = 2*pi*rand(1,6);

            % Expected values
            dimExpctd = [dec dec ord+1 ];

            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,ang);

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
            
        end
        
        % Test for getting parameter matrices
        function this = testGetParameterMatrices(this)

            % Parameters
            dec = 4;
            ord = 0;
            ang = [ pi/3 pi/4 ];
            mus = 1;
            
            % Expected values
            matrixW0Expctd = [0.500000000000000,-0.866025403784439;0.866025403784439,0.500000000000000;];
            matrixU0Expctd = [0.707106781186548,-0.707106781186548;0.707106781186548,0.707106781186548;];
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(dec,ord,ang,mus);

            % Actual values
            matrices = getParameterMatrices(this.lppufb);
            matrixW0Actual = matrices{1};
            matrixU0Actual = matrices{2};
            
            % Evaluation
            coefDist = norm(matrixW0Expctd(:)-matrixW0Actual(:))/...
                sqrt(numel(matrixW0Actual));
            this.assert(coefDist<1e-15,sprintf('(W0) %g',coefDist));
            coefDist = norm(matrixU0Expctd(:)-matrixU0Actual(:))/...
                sqrt(numel(matrixU0Actual));
            this.assert(coefDist<1e-15,sprintf('(U0) %g',coefDist));
            
        end
        
        % Test for default construction
        function this = testGetDec(this)
            
            % Expected values
            decExpctd = 4;
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0();
            
            % Actual values
            decActual = getDec(this.lppufb);
            
            % Evaluation
            this.assertEquals(decExpctd,decActual);
            
                        % Expected values
            decExpctd = 8;
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(8);
            
            % Actual values
            decActual = getDec(this.lppufb);
            
            % Evaluation
            this.assertEquals(decExpctd,decActual);
            
        end
        
        % Test for default construction
        function this = testGetOrd(this)
            
            % Expected values
            ordExpctd = 0;
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(4);
            
            % Actual values
            ordActual = getOrd(this.lppufb);
            
            % Evaluation
            this.assertEquals(ordExpctd,ordActual);
            
            % Expected values
            ordExpctd = 2;
            
            % Instantiation of target class
            this.lppufb = LpPuFb1dVm0(4,2);
            
            % Actual values
            ordActual = getOrd(this.lppufb);
            
            % Evaluation
            this.assertEquals(ordExpctd,ordActual);
            
        end

    end

end
