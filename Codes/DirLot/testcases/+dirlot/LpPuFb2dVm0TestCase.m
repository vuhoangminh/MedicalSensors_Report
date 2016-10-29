classdef LpPuFb2dVm0TestCase < TestCase
    %LPPUFB2DVM0TESTCASE Test case for LpPuFb2dVm0
    %
    % SVN identifier:
    % $Id: LpPuFb2dVm0TestCase.m 249 2011-11-27 01:55:42Z sho $
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
            coefExpctd = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0();
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for default construction
        function this = testConstructorWithDeepCopy(this)
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0();
            cloneLpPuFb = LpPuFb2dVm0(this.lppufb);
            
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
        
        % Test for construction
        function this = testConstructorWithOrd00(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 0 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)/sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction
        function this = testConstructorWithDec44Ord00(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 0 0 ];
            
            % Expected values
            dimExpctd = [16 16];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord);
            
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
            coefDist = norm((coefActual.'*coefActual)-eye(dimExpctd))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction
        function this = testConstructorWithOrd00Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 0 ];
            ang = [ 0 0 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction
        function this = testConstructorWithAngPi3Pi4(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 0 ];
            ang = [ pi/3 pi/4 ];
            
            % Expected values
            matrixW0 = double(GivensRotations(ang(1)));
            matrixU0 = double(GivensRotations(ang(2)));
            coefExpctd(:,:,1,1) = 1/2 * ...
                blkdiag(matrixW0, matrixU0) * ...
                [   1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction
        function this = testConstructorWithDec44Ord00Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 0 0 ];
            ang = 2*pi*rand(28,2);
            
            % Expected values
            dimExpctd = [16 16];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            coefDist = norm((coefActual.'*coefActual)-eye(dimExpctd))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        function this = testConstructorWithInvalidArguments(this)
            
            % Invalid input
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
                LpPuFb2dVm0(dec,ord,ang);
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
            dec = [ 2 2 ];
            ord = [ 0 0 ];
            ang = [ 0 0 ];
            mus = [ 1 1 ; -1 -1 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = 1/2 * [
                1  1  1  1 ;
                -1  1  1 -1 ;
                -1  1 -1  1 ;
                1  1 -1 -1 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang,mus);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 0 1
        function this = testConstructorWithOrd01(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 1 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0         0    0.5000    0.5000
                0         0   -0.5000    0.5000
                0         0   -0.5000    0.5000
                0         0    0.5000    0.5000 ];
            coefExpctd(:,:,1,2) = [
                0.5000    0.5000         0         0
                0.5000   -0.5000         0         0
                -0.5000    0.5000         0         0
                -0.5000   -0.5000         0         0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
            sizeDiff = norm(size(coefExpctd)-size(coefActual));
            this.assert(sizeDiff == 0,sprintf('%g',sizeDiff));
            
        end
        
        % Test for construction with order 1 0
        function this = testConstructorWithOrd10(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 1 0 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1) = [
                0    0.5000         0    0.5000
                0   -0.5000         0    0.5000
                0    0.5000         0    0.5000
                0   -0.5000         0    0.5000 ];
            coefExpctd(:,:,2) = [
                0.5000         0    0.5000         0
                0.5000         0   -0.5000         0
                -0.5000         0   -0.5000         0
                -0.5000         0    0.5000         0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 1 1
        function this = testConstructorWithOrd11(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 1 1 ];
            ang = 0;
            
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
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 2 2
        function this = testConstructorWithOrd22(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,2,1) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,3,1) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,1,2) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,2,2) = [
                0.5000    0.5000    0.5000    0.5000
                0.5000   -0.5000   -0.5000    0.5000
                -0.5000    0.5000   -0.5000    0.5000
                -0.5000   -0.5000    0.5000    0.5000 ];
            coefExpctd(:,:,3,2) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,1,3) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,2,3) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,3,3) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 3 3
        function this = testConstructorWithOrd33(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 3 3 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,2,1) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,3,1) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,4,1) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,1,2) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,2,2) = [
                0         0         0    0.5000
                0         0         0    0.5000
                0         0         0    0.5000
                0         0         0    0.5000 ];
            coefExpctd(:,:,3,2) = [
                0         0    0.5000         0
                0         0   -0.5000         0
                0         0   -0.5000         0
                0         0    0.5000         0 ];
            coefExpctd(:,:,4,2) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,1,3) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,2,3) = [
                0    0.5000         0         0
                0   -0.5000         0         0
                0    0.5000         0         0
                0   -0.5000         0         0 ];
            coefExpctd(:,:,3,3) = [
                0.5000         0         0         0
                0.5000         0         0         0
                -0.5000         0         0         0
                -0.5000         0         0         0 ];
            coefExpctd(:,:,4,3) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,1,4) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,2,4) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,3,4) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            coefExpctd(:,:,4,4) = [
                0     0     0     0
                0     0     0     0
                0     0     0     0
                0     0     0     0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 4 4
        function this = testConstructorWithOrd44(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 4 ];
            ang = 2*pi*rand(1,10);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test for construction with order 5 5
        function this = testConstructorWithOrd55(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 5 5 ];
            ang = 2*pi*rand(1,12);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test for construction with order 0 1
        function this = testConstructorWithDec44Ord01(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 0 1 ];
            ang = 2*pi*rand(28,3);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test for construction with order 1 0
        function this = testConstructorWithDec44Ord10(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 1 0 ];
            ang = 2*pi*rand(28,3);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 4 4 order 1 1
        function this = testConstructorWithDec44Ord11(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 1 1 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,1:4,1,1) = [
                0.005873803214612  -0.008790767739752  -0.029529602869795  -0.044194173824159
                -0.008790767739752  -0.005873803214612   0.044194173824159  -0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                0.005873803214612  -0.008790767739752  -0.029529602869795  -0.044194173824159
                -0.008790767739752  -0.005873803214612   0.044194173824159  -0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                0.005873803214612  -0.008790767739752  -0.029529602869795  -0.044194173824159
                -0.008790767739752  -0.005873803214612   0.044194173824159  -0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                0.005873803214612  -0.008790767739752  -0.029529602869795  -0.044194173824159
                -0.008790767739752  -0.005873803214612   0.044194173824159  -0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159 ];
            
            coefExpctd(:,5:8,1,1) = [
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                -0.005873803214612   0.008790767739752   0.029529602869795   0.044194173824159
                0.008790767739752   0.005873803214612  -0.044194173824159   0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                -0.005873803214612   0.008790767739752   0.029529602869795   0.044194173824159
                0.008790767739752   0.005873803214612  -0.044194173824159   0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                -0.005873803214612   0.008790767739752   0.029529602869795   0.044194173824159
                0.008790767739752   0.005873803214612  -0.044194173824159   0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                -0.005873803214612   0.008790767739752   0.029529602869795   0.044194173824159
                0.008790767739752   0.005873803214612  -0.044194173824159   0.029529602869795 ];
            
            coefExpctd(:,9:12,1,1) = [
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                0.044194173824159  -0.066141255221477  -0.222179115388070  -0.332514544433706
                -0.066141255221477  -0.044194173824159   0.332514544433706  -0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                0.044194173824159  -0.066141255221477  -0.222179115388070  -0.332514544433706
                -0.066141255221477  -0.044194173824159   0.332514544433706  -0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                0.044194173824159  -0.066141255221477  -0.222179115388070  -0.332514544433706
                -0.066141255221477  -0.044194173824159   0.332514544433706  -0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                0.044194173824159  -0.066141255221477  -0.222179115388070  -0.332514544433706
                -0.066141255221477  -0.044194173824159   0.332514544433706  -0.222179115388070 ];
            
            coefExpctd(:,13:16,1,1) = [
                -0.044194173824159   0.066141255221477   0.222179115388070   0.332514544433706
                0.066141255221477   0.044194173824159  -0.332514544433706   0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                -0.044194173824159   0.066141255221477   0.222179115388070   0.332514544433706
                0.066141255221477   0.044194173824159  -0.332514544433706   0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                -0.044194173824159   0.066141255221477   0.222179115388070   0.332514544433706
                0.066141255221477   0.044194173824159  -0.332514544433706   0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                -0.044194173824159   0.066141255221477   0.222179115388070   0.332514544433706
                0.066141255221477   0.044194173824159  -0.332514544433706   0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115 ];
            
            coefExpctd(:,1:4,2,1) = [
                -0.044194173824159  -0.029529602869795  -0.008790767739752   0.005873803214612
                -0.029529602869795   0.044194173824159  -0.005873803214612  -0.008790767739752
                0.066141255221477   0.044194173824159   0.013156313657566  -0.008790767739752
                0.044194173824159  -0.066141255221477   0.008790767739752   0.013156313657566
                0.044194173824159   0.029529602869795   0.008790767739752  -0.005873803214612
                0.029529602869795  -0.044194173824159   0.005873803214612   0.008790767739752
                -0.066141255221477  -0.044194173824159  -0.013156313657566   0.008790767739752
                -0.044194173824159   0.066141255221477  -0.008790767739752  -0.013156313657566
                0.044194173824159   0.029529602869795   0.008790767739752  -0.005873803214612
                0.029529602869795  -0.044194173824159   0.005873803214612   0.008790767739752
                -0.066141255221477  -0.044194173824159  -0.013156313657566   0.008790767739752
                -0.044194173824159   0.066141255221477  -0.008790767739752  -0.013156313657566
                -0.044194173824159  -0.029529602869795  -0.008790767739752   0.005873803214612
                -0.029529602869795   0.044194173824159  -0.005873803214612  -0.008790767739752
                0.066141255221477   0.044194173824159   0.013156313657566  -0.008790767739752
                0.044194173824159  -0.066141255221477   0.008790767739752   0.013156313657566 ];
            
            coefExpctd(:,5:8,2,1) = [
                0.066141255221477   0.044194173824159   0.013156313657566  -0.008790767739752
                0.044194173824159  -0.066141255221477   0.008790767739752   0.013156313657566
                0.044194173824159   0.029529602869795   0.008790767739752  -0.005873803214612
                0.029529602869795  -0.044194173824159   0.005873803214612   0.008790767739752
                -0.066141255221477  -0.044194173824159  -0.013156313657566   0.008790767739752
                -0.044194173824159   0.066141255221477  -0.008790767739752  -0.013156313657566
                -0.044194173824159  -0.029529602869795  -0.008790767739752   0.005873803214612
                -0.029529602869795   0.044194173824159  -0.005873803214612  -0.008790767739752
                -0.066141255221477  -0.044194173824159  -0.013156313657566   0.008790767739752
                -0.044194173824159   0.066141255221477  -0.008790767739752  -0.013156313657566
                -0.044194173824159  -0.029529602869795  -0.008790767739752   0.005873803214612
                -0.029529602869795   0.044194173824159  -0.005873803214612  -0.008790767739752
                0.066141255221477   0.044194173824159   0.013156313657566  -0.008790767739752
                0.044194173824159  -0.066141255221477   0.008790767739752   0.013156313657566
                0.044194173824159   0.029529602869795   0.008790767739752  -0.005873803214612
                0.029529602869795  -0.044194173824159   0.005873803214612   0.008790767739752 ];
            
            coefExpctd(:,9:12,2,1) = [
                0.222179115388070   0.148455338694115   0.044194173824159  -0.029529602869795
                0.148455338694115  -0.222179115388070   0.029529602869795   0.044194173824159
                -0.332514544433706  -0.222179115388070  -0.066141255221477   0.044194173824159
                -0.222179115388070   0.332514544433706  -0.044194173824159  -0.066141255221477
                -0.222179115388070  -0.148455338694115  -0.044194173824159   0.029529602869795
                -0.148455338694115   0.222179115388070  -0.029529602869795  -0.044194173824159
                0.332514544433706   0.222179115388070   0.066141255221477  -0.044194173824159
                0.222179115388070  -0.332514544433706   0.044194173824159   0.066141255221477
                -0.222179115388070  -0.148455338694115  -0.044194173824159   0.029529602869795
                -0.148455338694115   0.222179115388070  -0.029529602869795  -0.044194173824159
                0.332514544433706   0.222179115388070   0.066141255221477  -0.044194173824159
                0.222179115388070  -0.332514544433706   0.044194173824159   0.066141255221477
                0.222179115388070   0.148455338694115   0.044194173824159  -0.029529602869795
                0.148455338694115  -0.222179115388070   0.029529602869795   0.044194173824159
                -0.332514544433706  -0.222179115388070  -0.066141255221477   0.044194173824159
                -0.222179115388070   0.332514544433706  -0.044194173824159  -0.066141255221477 ];
            
            coefExpctd(:,13:16,2,1) = [
                0.332514544433706   0.222179115388070   0.066141255221477  -0.044194173824159
                0.222179115388070  -0.332514544433706   0.044194173824159   0.066141255221477
                0.222179115388070   0.148455338694115   0.044194173824159  -0.029529602869795
                0.148455338694115  -0.222179115388070   0.029529602869795   0.044194173824159
                -0.332514544433706  -0.222179115388070  -0.066141255221477   0.044194173824159
                -0.222179115388070   0.332514544433706  -0.044194173824159  -0.066141255221477
                -0.222179115388070  -0.148455338694115  -0.044194173824159   0.029529602869795
                -0.148455338694115   0.222179115388070  -0.029529602869795  -0.044194173824159
                -0.332514544433706  -0.222179115388070  -0.066141255221477   0.044194173824159
                -0.222179115388070   0.332514544433706  -0.044194173824159  -0.066141255221477
                -0.222179115388070  -0.148455338694115  -0.044194173824159   0.029529602869795
                -0.148455338694115   0.222179115388070  -0.029529602869795  -0.044194173824159
                0.332514544433706   0.222179115388070   0.066141255221477  -0.044194173824159
                0.222179115388070  -0.332514544433706   0.044194173824159   0.066141255221477
                0.222179115388070   0.148455338694115   0.044194173824159  -0.029529602869795
                0.148455338694115  -0.222179115388070   0.029529602869795   0.044194173824159 ];
            
            coefExpctd(:,1:4,1,2) = [
                -0.044194173824159   0.066141255221477   0.222179115388070   0.332514544433706
                0.066141255221477   0.044194173824159  -0.332514544433706   0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                0.044194173824159  -0.066141255221477  -0.222179115388070  -0.332514544433706
                -0.066141255221477  -0.044194173824159   0.332514544433706  -0.222179115388070
                0.029529602869795  -0.044194173824159  -0.148455338694115  -0.222179115388070
                -0.044194173824159  -0.029529602869795   0.222179115388070  -0.148455338694115
                -0.044194173824159   0.066141255221477   0.222179115388070   0.332514544433706
                0.066141255221477   0.044194173824159  -0.332514544433706   0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                0.044194173824159  -0.066141255221477  -0.222179115388070  -0.332514544433706
                -0.066141255221477  -0.044194173824159   0.332514544433706  -0.222179115388070
                0.029529602869795  -0.044194173824159  -0.148455338694115  -0.222179115388070
                -0.044194173824159  -0.029529602869795   0.222179115388070  -0.148455338694115 ];
            
            coefExpctd(:,5:8,1,2) = [
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                0.044194173824159  -0.066141255221477  -0.222179115388070  -0.332514544433706
                -0.066141255221477  -0.044194173824159   0.332514544433706  -0.222179115388070
                0.029529602869795  -0.044194173824159  -0.148455338694115  -0.222179115388070
                -0.044194173824159  -0.029529602869795   0.222179115388070  -0.148455338694115
                -0.044194173824159   0.066141255221477   0.222179115388070   0.332514544433706
                0.066141255221477   0.044194173824159  -0.332514544433706   0.222179115388070
                -0.029529602869795   0.044194173824159   0.148455338694115   0.222179115388070
                0.044194173824159   0.029529602869795  -0.222179115388070   0.148455338694115
                0.044194173824159  -0.066141255221477  -0.222179115388070  -0.332514544433706
                -0.066141255221477  -0.044194173824159   0.332514544433706  -0.222179115388070
                0.029529602869795  -0.044194173824159  -0.148455338694115  -0.222179115388070
                -0.044194173824159  -0.029529602869795   0.222179115388070  -0.148455338694115
                -0.044194173824159   0.066141255221477   0.222179115388070   0.332514544433706
                0.066141255221477   0.044194173824159  -0.332514544433706   0.222179115388070 ];
            
            coefExpctd(:,9:12,1,2) = [
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                -0.005873803214612   0.008790767739752   0.029529602869795   0.044194173824159
                0.008790767739752   0.005873803214612  -0.044194173824159   0.029529602869795
                0.008790767739752  -0.013156313657566  -0.044194173824159  -0.066141255221477
                -0.013156313657566  -0.008790767739752   0.066141255221477  -0.044194173824159
                0.005873803214612  -0.008790767739752  -0.029529602869795  -0.044194173824159
                -0.008790767739752  -0.005873803214612   0.044194173824159  -0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                -0.005873803214612   0.008790767739752   0.029529602869795   0.044194173824159
                0.008790767739752   0.005873803214612  -0.044194173824159   0.029529602869795
                0.008790767739752  -0.013156313657566  -0.044194173824159  -0.066141255221477
                -0.013156313657566  -0.008790767739752   0.066141255221477  -0.044194173824159
                0.005873803214612  -0.008790767739752  -0.029529602869795  -0.044194173824159
                -0.008790767739752  -0.005873803214612   0.044194173824159  -0.029529602869795 ];
            
            coefExpctd(:,13:16,1,2) = [
                0.005873803214612  -0.008790767739752  -0.029529602869795  -0.044194173824159
                -0.008790767739752  -0.005873803214612   0.044194173824159  -0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                -0.005873803214612   0.008790767739752   0.029529602869795   0.044194173824159
                0.008790767739752   0.005873803214612  -0.044194173824159   0.029529602869795
                0.008790767739752  -0.013156313657566  -0.044194173824159  -0.066141255221477
                -0.013156313657566  -0.008790767739752   0.066141255221477  -0.044194173824159
                0.005873803214612  -0.008790767739752  -0.029529602869795  -0.044194173824159
                -0.008790767739752  -0.005873803214612   0.044194173824159  -0.029529602869795
                -0.008790767739752   0.013156313657566   0.044194173824159   0.066141255221477
                0.013156313657566   0.008790767739752  -0.066141255221477   0.044194173824159
                -0.005873803214612   0.008790767739752   0.029529602869795   0.044194173824159
                0.008790767739752   0.005873803214612  -0.044194173824159   0.029529602869795
                0.008790767739752  -0.013156313657566  -0.044194173824159  -0.066141255221477
                -0.013156313657566  -0.008790767739752   0.066141255221477  -0.044194173824159 ];
            
            coefExpctd(:,1:4,2,2) = [
                0.332514544433706   0.222179115388070   0.066141255221477  -0.044194173824159
                0.222179115388070  -0.332514544433706   0.044194173824159   0.066141255221477
                0.222179115388070   0.148455338694115   0.044194173824159  -0.029529602869795
                0.148455338694115  -0.222179115388070   0.029529602869795   0.044194173824159
                0.332514544433706   0.222179115388070   0.066141255221477  -0.044194173824159
                0.222179115388070  -0.332514544433706   0.044194173824159   0.066141255221477
                0.222179115388070   0.148455338694115   0.044194173824159  -0.029529602869795
                0.148455338694115  -0.222179115388070   0.029529602869795   0.044194173824159
                -0.332514544433706  -0.222179115388070  -0.066141255221477   0.044194173824159
                -0.222179115388070   0.332514544433706  -0.044194173824159  -0.066141255221477
                -0.222179115388070  -0.148455338694115  -0.044194173824159   0.029529602869795
                -0.148455338694115   0.222179115388070  -0.029529602869795  -0.044194173824159
                -0.332514544433706  -0.222179115388070  -0.066141255221477   0.044194173824159
                -0.222179115388070   0.332514544433706  -0.044194173824159  -0.066141255221477
                -0.222179115388070  -0.148455338694115  -0.044194173824159   0.029529602869795
                -0.148455338694115   0.222179115388070  -0.029529602869795  -0.044194173824159 ];
            
            coefExpctd(:,5:8,2,2) = [
                0.222179115388070   0.148455338694115   0.044194173824159  -0.029529602869795
                0.148455338694115  -0.222179115388070   0.029529602869795   0.044194173824159
                -0.332514544433706  -0.222179115388070  -0.066141255221477   0.044194173824159
                -0.222179115388070   0.332514544433706  -0.044194173824159  -0.066141255221477
                0.222179115388070   0.148455338694115   0.044194173824159  -0.029529602869795
                0.148455338694115  -0.222179115388070   0.029529602869795   0.044194173824159
                -0.332514544433706  -0.222179115388070  -0.066141255221477   0.044194173824159
                -0.222179115388070   0.332514544433706  -0.044194173824159  -0.066141255221477
                -0.222179115388070  -0.148455338694115  -0.044194173824159   0.029529602869795
                -0.148455338694115   0.222179115388070  -0.029529602869795  -0.044194173824159
                0.332514544433706   0.222179115388070   0.066141255221477  -0.044194173824159
                0.222179115388070  -0.332514544433706   0.044194173824159   0.066141255221477
                -0.222179115388070  -0.148455338694115  -0.044194173824159   0.029529602869795
                -0.148455338694115   0.222179115388070  -0.029529602869795  -0.044194173824159
                0.332514544433706   0.222179115388070   0.066141255221477  -0.044194173824159
                0.222179115388070  -0.332514544433706   0.044194173824159   0.066141255221477 ];
            
            coefExpctd(:,9:12,2,2) = [
                0.066141255221477   0.044194173824159   0.013156313657566  -0.008790767739752
                0.044194173824159  -0.066141255221477   0.008790767739752   0.013156313657566
                0.044194173824159   0.029529602869795   0.008790767739752  -0.005873803214612
                0.029529602869795  -0.044194173824159   0.005873803214612   0.008790767739752
                0.066141255221477   0.044194173824159   0.013156313657566  -0.008790767739752
                0.044194173824159  -0.066141255221477   0.008790767739752   0.013156313657566
                0.044194173824159   0.029529602869795   0.008790767739752  -0.005873803214612
                0.029529602869795  -0.044194173824159   0.005873803214612   0.008790767739752
                -0.066141255221477  -0.044194173824159  -0.013156313657566   0.008790767739752
                -0.044194173824159   0.066141255221477  -0.008790767739752  -0.013156313657566
                -0.044194173824159  -0.029529602869795  -0.008790767739752   0.005873803214612
                -0.029529602869795   0.044194173824159  -0.005873803214612  -0.008790767739752
                -0.066141255221477  -0.044194173824159  -0.013156313657566   0.008790767739752
                -0.044194173824159   0.066141255221477  -0.008790767739752  -0.013156313657566
                -0.044194173824159  -0.029529602869795  -0.008790767739752   0.005873803214612
                -0.029529602869795   0.044194173824159  -0.005873803214612  -0.008790767739752 ];
            
            coefExpctd(:,13:16,2,2) = [
                -0.044194173824159  -0.029529602869795  -0.008790767739752   0.005873803214612
                -0.029529602869795   0.044194173824159  -0.005873803214612  -0.008790767739752
                0.066141255221477   0.044194173824159   0.013156313657566  -0.008790767739752
                0.044194173824159  -0.066141255221477   0.008790767739752   0.013156313657566
                -0.044194173824159  -0.029529602869795  -0.008790767739752   0.005873803214612
                -0.029529602869795   0.044194173824159  -0.005873803214612  -0.008790767739752
                0.066141255221477   0.044194173824159   0.013156313657566  -0.008790767739752
                0.044194173824159  -0.066141255221477   0.008790767739752   0.013156313657566
                0.044194173824159   0.029529602869795   0.008790767739752  -0.005873803214612
                0.029529602869795  -0.044194173824159   0.005873803214612   0.008790767739752
                -0.066141255221477  -0.044194173824159  -0.013156313657566   0.008790767739752
                -0.044194173824159   0.066141255221477  -0.008790767739752  -0.013156313657566
                0.044194173824159   0.029529602869795   0.008790767739752  -0.005873803214612
                0.029529602869795  -0.044194173824159   0.005873803214612   0.008790767739752
                -0.066141255221477  -0.044194173824159  -0.013156313657566   0.008790767739752
                -0.044194173824159   0.066141255221477  -0.008790767739752  -0.013156313657566 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 4 4 order 2 2
        function this = testConstructorWithDec44Ord22(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                ];
            
            coefExpctd(:,:,2,1) = [
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                ];
            
            coefExpctd(:,:,3,1) = [
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                ];
            
            coefExpctd(:,:,1,2) = [
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                ];
            
            coefExpctd(:,1:4,2,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549 ];
            
            coefExpctd(:,5:8,2,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094 ];
            
            coefExpctd(:,9:12,2,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094 ];
            
            coefExpctd(:,13:16,2,2) = [
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
            
            
            coefExpctd(:,:,3,2) = [
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                ];
            
            coefExpctd(:,:,1,3) = [
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                ];
            
            coefExpctd(:,:,2,3) = [
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                ];
            
            coefExpctd(:,:,3,3) = [
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0
                ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 4 4 order 1 1
        function this = testConstructorWithDec44Ord11Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 1 1 ];
            ang = 2*pi*rand(28,4);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 4 4 order 2 2
        function this = testConstructorWithDec44Ord22Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 2 ];
            ang = 2*pi*rand(28,6);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 4 4 order 3 3
        function this = testConstructorWithDec44Ord33Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 3 3 ];
            ang = 2*pi*rand(28,8);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test: dec 4 4 order 4 4
        function this = testConstructorWithDec44Ord44Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 4 4 ];
            ang = 2*pi*rand(28,10);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test for angle setting
        function this = testSetAngles(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 0 ];
            angPre = [ pi/4 pi/4 ];
            angPst = [ 0 0 ];
            
            % Expected values
            coefExpctd(:,:,1,1) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,angPre);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)...
                /sqrt(numel(coefActual));
            this.assert(coefDist>=1e-15,sprintf('%g',coefDist));
            
            % Set angles
            this.lppufb = setAngles(this.lppufb,angPst);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for angle setting
        function this = testSetMus(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 0 ];
            ang = [ 0 0 ];
            musPre = [ 1 -1 ; 1 -1 ];
            musPst = 1;
            
            % Expected values
            coefExpctd(:,:,1,1) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang,musPre);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)...
                /sqrt(numel(coefActual));
            this.assert(coefDist>=1e-15,sprintf('%g',coefDist));
            
            % Set angles
            this.lppufb = setMus(this.lppufb,musPst);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd-coefActual)...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for char
        function this = testChar(this)
            
            % Expected value
            charExpctd = [...
                '[', 10, ...
                9, '0.5 + 0.5*y^(-1) + 0.5*x^(-1) + 0.5*y^(-1)*x^(-1);', 10, ...
                9, '0.5 - 0.5*y^(-1) - 0.5*x^(-1) + 0.5*y^(-1)*x^(-1);', 10, ...
                9, '-0.5 + 0.5*y^(-1) - 0.5*x^(-1) + 0.5*y^(-1)*x^(-1);', 10, ...
                9, '-0.5 - 0.5*y^(-1) + 0.5*x^(-1) + 0.5*y^(-1)*x^(-1)', 10, ...
                ']' ...
                ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0();
            
            % Actual values
            charActual = char(this.lppufb);
            
            % Evaluation
            this.assertEquals(charExpctd, charActual);
            
        end
        
        % Test for subsref
        function this = testSubsRef(this)
            
            % Expected value
            anFiltExpctd1 = 1/2*[ 1 1 ;  1 1 ];
            anFiltExpctd2 = 1/2*[ 1 -1 ; -1 1 ];
            anFiltExpctd3 = 1/2*[-1 -1 ;  1  1 ];
            anFiltExpctd4 = 1/2*[-1  1 ; -1  1 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0();
            
            % Actual values
            anFiltActual1 = this.lppufb(1);
            anFiltActual2 = this.lppufb(2);
            anFiltActual3 = this.lppufb(3);
            anFiltActual4 = this.lppufb(4);
            
            % Evaluation
            dist = norm(anFiltExpctd1(:)-anFiltActual1(:))/2;
            this.assert(dist<1e-15,sprintf('%g',dist));
            dist = norm(anFiltExpctd2(:)-anFiltActual2(:))/2;
            this.assert(dist<1e-15,sprintf('%g',dist));
            dist = norm(anFiltExpctd3(:)-anFiltActual3(:))/2;
            this.assert(dist<1e-15,sprintf('%g',dist));
            dist = norm(anFiltExpctd4(:)-anFiltActual4(:))/2;
            this.assert(dist<1e-15,sprintf('%g',dist));
            
            
        end
        
        % Test dec 2 2 order 0 1
        function this = testConstructorWithDec22Ord01(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 1 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = 1/2 * [...
                0 0  1  1;
                0 0 -1  1;
                0 0 -1  1;
                0 0  1  1];
            
            coefExpctd(:,:,1,2) = 1/2 * [...
                1  1 0 0;
                1 -1 0 0;
                -1  1 0 0;
                -1 -1 0 0];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 0 1
        function this = testConstructorWithDec22Ord01Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 1 ];
            ang = 2*pi*rand(1,3);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 1 0
        function this = testConstructorWithDec22Ord10(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 1 0 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1) = 1/2 * [...
                0  1  0  1;
                0 -1  0  1;
                0  1  0  1;
                0 -1  0  1];
            
            coefExpctd(:,:,2) = 1/2 * [...
                1  0  1  0;
                1  0 -1  0;
                -1  0 -1  0;
                -1  0  1  0];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 1 0
        function this = testConstructorWithDec22Ord10Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 1 0 ];
            ang = 2*pi*rand(1,3);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 1 1
        function this = testConstructorWithDec22Ord11(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 1 1 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = [...
                0 0 0  1;
                0 0 0  1;
                0 0 0  1;
                0 0 0  1]/2;
            
            coefExpctd(:,:,2,1) = [...
                0 0  1 0;
                0 0 -1 0;
                0 0 -1 0;
                0 0  1 0]/2;
            
            coefExpctd(:,:,1,2) = [...
                0  1 0 0;
                0 -1 0 0;
                0  1 0 0;
                0 -1 0 0]/2;
            
            coefExpctd(:,:,2,2) = [...
                1 0 0 0;
                1 0 0 0;
                -1 0 0 0;
                -1 0 0 0]/2;
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 2 2 order 1 1
        function this = testConstructorWithDec22Ord11Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 1 1 ];
            ang = 2*pi*rand(1,4);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 0 2
        function this = testConstructorWithDec22Ord02(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 2 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,2) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            coefExpctd(:,:,1,3) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 0 2
        function this = testConstructorWithDec22Ord02Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 2 ];
            ang = 2*pi*rand(1,4);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 2 0
        function this = testConstructorWithDec22Ord20(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 0 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            coefExpctd(:,:,3) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 2 0
        function this = testConstructorWithDec22Ord20Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 0 ];
            ang = 2*pi*rand(1,4);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 2 2
        function this = testConstructorWithDec22Ord22(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,3,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,2) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2,2) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            coefExpctd(:,:,3,2) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,3) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2,3) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,3,3) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 2 2 order 2 2
        function this = testConstructorWithDec22Ord22Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 2 ];
            ang = 2*pi*rand(1,6);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 0 4
        function this = testConstructorWithDec22Ord04(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 4 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,2) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,3) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            coefExpctd(:,:,1,4) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,5) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 0 4
        function this = testConstructorWithDec22Ord04Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 0 4 ];
            ang = 2*pi*rand(1,6);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 0 4
        function this = testConstructorWithDec22Ord40(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 0 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,3) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            coefExpctd(:,:,4) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,5) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test for construction with order 4 0
        function this = testConstructorWithDec22Ord40Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 0 ];
            ang = 2*pi*rand(1,6);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 2 2
        function this = testConstructorWithDec22Ord44(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 4 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,3,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,4,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,5,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,2) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2,2) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,3,2) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,4,2) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,5,2) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,3) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2,3) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,3,3) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            coefExpctd(:,:,4,3) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,5,3) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,1) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2,4) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,3,4) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,4,4) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,5,4) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,1,5) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,2,5) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,3,5) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,4,5) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            coefExpctd(:,:,5,5) = [
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ;
                0  0  0  0 ];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 2 2 order 2 2
        function this = testConstructorWithDec22Ord44Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 4 ];
            ang = 2*pi*rand(1,10);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 4 4 order 0 2
        function this = testConstructorWithDec44Ord02(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 0 2 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = zeros(16,16);
            
            coefExpctd(:,1:4,1,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549 ];
            
            coefExpctd(:,5:8,1,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094 ];
            
            coefExpctd(:,9:12,1,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094 ];
            
            coefExpctd(:,13:16,1,2) = [
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
            
            coefExpctd(:,:,1,3) = zeros(16,16);
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 2 2 order 0 2
        function this = testConstructorWithDec44Ord02Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 0 2 ];
            ang = 2*pi*rand(28,4);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 4 4 order 2 0
        function this = testConstructorWithDec44Ord20(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 0 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1) = zeros(16,16);
            
            coefExpctd(:,1:4,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549 ];
            
            coefExpctd(:,5:8,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094 ];
            
            coefExpctd(:,9:12,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094 ];
            
            coefExpctd(:,13:16,2) = [
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
            
            coefExpctd(:,:,3) = zeros(16,16);
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 4 4 order 2 0
        function this = testConstructorWithDec44Ord20Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 0 ];
            ang = 2*pi*rand(28,4);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 4 4 order 0 4
        function this = testConstructorWithDec44Ord04(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 0 4 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = zeros(16,16);
            
            coefExpctd(:,:,1,2) = zeros(16,16);
            
            coefExpctd(:,1:4,1,3) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549 ];
            
            coefExpctd(:,5:8,1,3) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094 ];
            
            coefExpctd(:,9:12,1,3) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094 ];
            
            coefExpctd(:,13:16,1,3) = [
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
            
            coefExpctd(:,:,1,4) = zeros(16,16);
            
            coefExpctd(:,:,1,5) = zeros(16,16);
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 4 4 order 0 4
        function this = testConstructorWithDec44Ord04Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 0 4 ];
            ang = 2*pi*rand(28,6);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 4 4 order 4 0
        function this = testConstructorWithDec44Ord40(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 4 0 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1) = zeros(16,16);
            
            coefExpctd(:,:,2) = zeros(16,16);
            
            coefExpctd(:,1:4,3) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549 ];
            
            coefExpctd(:,5:8,3) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094 ];
            
            coefExpctd(:,9:12,3) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094 ];
            
            coefExpctd(:,13:16,3) = [
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
            
            coefExpctd(:,:,4) = zeros(16,16);
            
            coefExpctd(:,:,5) = zeros(16,16);
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 4 4 order 4 0
        function this = testConstructorWithDec44Ord40Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 4 0 ];
            ang = 2*pi*rand(28,6);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 2 4
        function this = testConstructorWithDec22Ord24(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 4 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = zeros(4,4);
            
            coefExpctd(:,:,2,1) = zeros(4,4);
            
            coefExpctd(:,:,3,1) = zeros(4,4);
            
            coefExpctd(:,:,1,2) = zeros(4,4);
            
            coefExpctd(:,:,2,2) = zeros(4,4);
            
            coefExpctd(:,:,3,2) = zeros(4,4);
            
            coefExpctd(:,:,1,3) = zeros(4,4);
            
            coefExpctd(:,:,2,3) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            coefExpctd(:,:,3,3) = zeros(4,4);
            
            coefExpctd(:,:,1,4) = zeros(4,4);
            
            coefExpctd(:,:,2,4) = zeros(4,4);
            
            coefExpctd(:,:,3,4) = zeros(4,4);
            
            coefExpctd(:,:,1,5) = zeros(4,4);
            
            coefExpctd(:,:,2,5) = zeros(4,4);
            
            coefExpctd(:,:,3,5) = zeros(4,4);
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 2 2 order 2 4
        function this = testConstructorWithDec22Ord24Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 2 4 ];
            ang = 2*pi*rand(1,8);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 4 4 order 2 4
        function this = testConstructorWithDec44Ord24(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 4 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = zeros(16,16);
            
            coefExpctd(:,:,2,1) = zeros(16,16);
            
            coefExpctd(:,:,3,1) = zeros(16,16);
            
            coefExpctd(:,:,1,2) = zeros(16,16);
            
            coefExpctd(:,:,2,2) = zeros(16,16);
            
            coefExpctd(:,:,3,2) = zeros(16,16);
            
            coefExpctd(:,:,1,3) = zeros(16,16);
            
            coefExpctd(:,1:4,2,3) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549 ];
            
            coefExpctd(:,5:8,2,3) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094 ];
            
            coefExpctd(:,9:12,2,3) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094 ];
            
            coefExpctd(:,13:16,2,3) = [
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
            
            coefExpctd(:,:,3,3) = zeros(16,16);
            
            coefExpctd(:,:,1,4) = zeros(16,16);
            
            coefExpctd(:,:,2,4) = zeros(16,16);
            
            coefExpctd(:,:,3,4) = zeros(16,16);
            
            coefExpctd(:,:,1,5) = zeros(16,16);
            
            coefExpctd(:,:,2,5) = zeros(16,16);
            
            coefExpctd(:,:,3,5) = zeros(16,16);
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 4 4 order 2 4
        function this = testConstructorWithDec44Ord24Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 2 4 ];
            ang = 2*pi*rand(28,8);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 2 2 order 4 2
        function this = testConstructorWithDec22Ord42(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 2 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = zeros(4,4);
            
            coefExpctd(:,:,2,1) = zeros(4,4);
            
            coefExpctd(:,:,3,1) = zeros(4,4);
            
            coefExpctd(:,:,4,1) = zeros(4,4);
            
            coefExpctd(:,:,5,1) = zeros(4,4);
            
            coefExpctd(:,:,1,2) = zeros(4,4);
            
            coefExpctd(:,:,2,2) = zeros(4,4);
            
            coefExpctd(:,:,3,2) = 1/2 * [
                1  1  1  1 ;
                1 -1 -1  1 ;
                -1  1 -1  1 ;
                -1 -1  1  1 ];
            
            coefExpctd(:,:,4,2) = zeros(4,4);
            
            coefExpctd(:,:,5,2) = zeros(4,4);
            
            coefExpctd(:,:,1,3) = zeros(4,4);
            
            coefExpctd(:,:,2,3) = zeros(4,4);
            
            coefExpctd(:,:,3,3) = zeros(4,4);
            
            coefExpctd(:,:,4,3) = zeros(4,4);
            
            coefExpctd(:,:,5,3) = zeros(4,4);
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 2 2 order 4 2
        function this = testConstructorWithDec22Ord42Ang(this)
            
            % Parameters
            dec = [ 2 2 ];
            ord = [ 4 2 ];
            ang = 2*pi*rand(1,8);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
        % Test dec 4 4 order 4 2
        function this = testConstructorWithDec44Ord42(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 4 2 ];
            ang = 0;
            
            % Expected values
            coefExpctd(:,:,1,1) = zeros(16,16);
            
            coefExpctd(:,:,2,1) = zeros(16,16);
            
            coefExpctd(:,:,3,1) = zeros(16,16);
            
            coefExpctd(:,:,4,1) = zeros(16,16);
            
            coefExpctd(:,:,5,1) = zeros(16,16);
            
            coefExpctd(:,:,1,2) = zeros(16,16);
            
            coefExpctd(:,:,2,2) = zeros(16,16);
            
            coefExpctd(:,1:4,3,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549 ];
            
            coefExpctd(:,5:8,3,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094 ];
            
            coefExpctd(:,9:12,3,2) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094 ];
            
            coefExpctd(:,13:16,3,2) = [
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
            
            coefExpctd(:,:,4,2) = zeros(16,16);
            
            coefExpctd(:,:,5,2) = zeros(16,16);
            
            coefExpctd(:,:,1,3) = zeros(16,16);
            
            coefExpctd(:,:,2,3) = zeros(16,16);
            
            coefExpctd(:,:,3,3) = zeros(16,16);
            
            coefExpctd(:,:,4,3) = zeros(16,16);
            
            coefExpctd(:,:,5,3) = zeros(16,16);
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
            % Actual values
            coefActual = double(this.lppufb);
            
            % Evaluation
            coefDist = norm(coefExpctd(:)-coefActual(:))...
                /sqrt(numel(coefActual));
            this.assert(coefDist<1e-15,sprintf('%g',coefDist));
            
        end
        
        % Test dec 4 4 order 4 2
        function this = testConstructorWithDec44Ord42Ang(this)
            
            % Parameters
            dec = [ 4 4 ];
            ord = [ 4 2 ];
            ang = 2*pi*rand(28,8);
            
            % Expected values
            nDecs = prod(dec);
            dimExpctd = [nDecs nDecs ord(1)+1 ord(2)+1];
            
            % Instantiation of target class
            this.lppufb = LpPuFb2dVm0(dec,ord,ang);
            
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
            
        end
        
    end
    
end
