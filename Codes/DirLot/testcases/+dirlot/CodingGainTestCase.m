classdef CodingGainTestCase < TestCase
    %CODINGGAINTESTCASE Test case for CodingGain
    %
    % SVN identifier:
    % $Id: CodingGainTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        cg;
    end
    
    methods
               
        function this = tearDown(this)
            delete(this.cg);
        end
        
        % Test for default construction
        function this = testGetCorrelationMatrix(this)
            
            % Parameters
            nTaps = [ 2 2 ];
            rho = 0.95;
            
            %
            rho10 = rho;
            rho01 = rho;
            rho11 = rho^sqrt(2);
            
            % Expected values
            corExpctd = [
                1.0   rho10 rho01 rho11;
                rho10 1.0   rho11 rho01;
                rho01 rho11 1.0   rho10;
                rho11 rho01 rho10 1.0
                ];
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        function this = testGetCorrelationWithRho(this)
            
            % Parameters
            nTaps = [ 2 2 ];
            rho = 0.98;
            
            %
            rho10 = rho;
            rho01 = rho;
            rho11 = rho^sqrt(2);
            
            % Expected values
            corExpctd = [
                1.0   rho10 rho01 rho11;
                rho10 1.0   rho11 rho01;
                rho01 rho11 1.0   rho10;
                rho11 rho01 rho10 1.0
                ];
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps,rho);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testGetCost(this)
            
            % Parameters
            nTaps = [ 2 2 ];
            filters = [
                0.500000000000000   0.500000000000000   0.500000000000000   0.500000000000000;
                0.500000000000000  -0.500000000000000  -0.500000000000000   0.500000000000000;
                0.500000000000000  -0.500000000000000   0.500000000000000  -0.500000000000000;
                0.500000000000000   0.500000000000000  -0.500000000000000  -0.500000000000000
                ];
            
            % Expected values
            costExpctd = -8.1235;
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps);
            
            % Actual values
            costActual = getCost(this.cg,filters);
            
            % Evaluation
            diff = norm(costExpctd - costActual);
            this.assert(diff<1e-3,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testGetCostByLpPuFb2d(this)
            
            % Parameters
            nTaps = [ 2 2 ];
            %lppufb = LpPuFb2d();
            lppufb = LpPuFb2dFactory.createLpPuFb2d();
            
            % Expected values
            costExpctd = -8.1235;
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps);
            
            % Actual values
            costActual = getCost(this.cg,lppufb);
            
            % Evaluation
            diff = norm(costExpctd - costActual);
            this.assert(diff<1e-3,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testGetCorrelationMatrixFor44Taps(this)
            
            % Parameters
            nTaps = [ 4 4 ];
            rho = 0.95;
            
            %
            r10 = rho;
            r20 = rho^2;
            r30 = rho^3;
            %
            r01 = rho;
            r11 = rho^sqrt(2);
            r21 = rho^sqrt(5);
            r31 = rho^sqrt(10);
            %
            r02 = rho^2;
            r12 = rho^sqrt(5);
            r22 = rho^sqrt(8);
            r32 = rho^sqrt(13);
            %
            r03 = rho^3;
            r13 = rho^sqrt(10);
            r23 = rho^sqrt(13);
            r33 = rho^sqrt(18);
            
            % Expected values
            corExpctd = [
                1.0 r10 r20 r30 r01 r11 r21 r31 r02 r12 r22 r32 r03 r13 r23 r33;
                r10 1.0 r10 r20 r11 r01 r11 r21 r12 r02 r12 r22 r13 r03 r13 r23;
                r20 r10 1.0 r10 r21 r11 r01 r11 r22 r12 r02 r12 r23 r13 r03 r13;
                r30 r20 r10 1.0 r31 r21 r11 r01 r32 r22 r12 r02 r33 r23 r13 r03;
                r01 r11 r21 r31 1.0 r10 r20 r30 r01 r11 r21 r31 r02 r12 r22 r32;
                r11 r01 r11 r21 r10 1.0 r10 r20 r11 r01 r11 r21 r12 r02 r12 r22;
                r21 r11 r01 r11 r20 r10 1.0 r10 r21 r11 r01 r11 r22 r12 r02 r12;
                r31 r21 r11 r01 r30 r20 r10 1.0 r31 r21 r11 r01 r32 r22 r12 r02;
                r02 r12 r22 r32 r01 r11 r21 r31 1.0 r10 r20 r30 r01 r11 r21 r31;
                r12 r02 r12 r22 r11 r01 r11 r21 r10 1.0 r10 r20 r11 r01 r11 r21;
                r22 r12 r02 r12 r21 r11 r01 r11 r20 r10 1.0 r10 r21 r11 r01 r11;
                r32 r22 r12 r02 r31 r21 r11 r01 r30 r20 r10 1.0 r31 r21 r11 r01;
                r03 r13 r23 r33 r02 r12 r22 r32 r01 r11 r21 r31 1.0 r10 r20 r30;
                r13 r03 r13 r23 r12 r02 r12 r22 r11 r01 r11 r21 r10 1.0 r10 r20;
                r23 r13 r03 r13 r22 r12 r02 r12 r21 r11 r01 r11 r20 r10 1.0 r10;
                r33 r23 r13 r03 r32 r22 r12 r02 r31 r21 r11 r01 r30 r20 r10 1.0
                ];
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test with 44 taps
        function this = testGetCostFor44Taps44Dec(this)
            
            % Parameters
            nTaps = [ 4 4 ];
            
            % Filters (2-D DCT)
            filters(:,1:4) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                ];
            
            filters(:,5:8) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                0.176776695296637   0.073223304703363  -0.073223304703363  -0.176776695296637
                0.073223304703363  -0.176776695296637   0.176776695296637  -0.073223304703363
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                0.135299025036549   0.135299025036549   0.135299025036549   0.135299025036549
                0.135299025036549  -0.135299025036549  -0.135299025036549   0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094
                ];
            
            filters(:,9:12) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.250000000000000  -0.250000000000000  -0.250000000000000  -0.250000000000000
                -0.250000000000000   0.250000000000000   0.250000000000000  -0.250000000000000
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.426776695296637   0.176776695296637  -0.176776695296637  -0.426776695296637
                0.176776695296637  -0.426776695296637   0.426776695296637  -0.176776695296637
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.326640741219094  -0.135299025036549   0.135299025036549   0.326640741219094
                -0.135299025036549   0.326640741219094  -0.326640741219094   0.135299025036549
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549
                0.326640741219094   0.326640741219094   0.326640741219094   0.326640741219094
                0.326640741219094  -0.326640741219094  -0.326640741219094   0.326640741219094
                ];
            
            filters(:,13:16) = [
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                0.250000000000000   0.250000000000000   0.250000000000000   0.250000000000000
                0.250000000000000  -0.250000000000000  -0.250000000000000   0.250000000000000
                -0.426776695296637  -0.176776695296637   0.176776695296637   0.426776695296637
                -0.176776695296637   0.426776695296637  -0.426776695296637   0.176776695296637
                -0.176776695296637  -0.073223304703363   0.073223304703363   0.176776695296637
                -0.073223304703363   0.176776695296637  -0.176776695296637   0.073223304703363
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                0.326640741219094   0.135299025036549  -0.135299025036549  -0.326640741219094
                0.135299025036549  -0.326640741219094   0.326640741219094  -0.135299025036549
                -0.326640741219094  -0.326640741219094  -0.326640741219094  -0.326640741219094
                -0.326640741219094   0.326640741219094   0.326640741219094  -0.326640741219094
                -0.135299025036549  -0.135299025036549  -0.135299025036549  -0.135299025036549
                -0.135299025036549   0.135299025036549   0.135299025036549  -0.135299025036549
                ];
            
            % Expected values
            costExpctd = -10.7323;
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps);
            
            % Actual values
            costActual = getCost(this.cg,filters);
            
            % Evaluation
            diff = norm(costExpctd - costActual);
            this.assert(diff<1e-3,sprintf('%g',diff));
            
        end
        
        % test with weigt
        function this = testGetCorrelationMatrixWithWeight(this)
            
            % Parameters
            nTaps = [ 2 2 ];
            rho = 0.95;
            wv = sqrt(2);
            wh = 1/wv;
            %
            rho10 = rho^sqrt(1*(1/wv)^2 + 0*(1/wh)^2);
            rho01 = rho^sqrt(0*(1/wv)^2 + 1*(1/wh)^2);
            rho11 = rho^sqrt(1*(1/wv)^2 + 1*(1/wh)^2);
            
            % Expected values
            corExpctd = [
                1.0   rho10 rho01 rho11;
                rho10 1.0   rho11 rho01;
                rho01 rho11 1.0   rho10;
                rho11 rho01 rho10 1.0
                ];
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps,[],wv);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % test with weigt for 44 taps
        function this = testGetCorrelationMatrixWithWeightFor44Taps(this)
            
            % Parameters
            nTaps = [ 4 4 ];
            rho = 0.98;
            wv = sqrt(2);
            wh = 1/wv;
            
            %
            r10 = rho^sqrt(((1/wv)^2 + (0/wh)^2));
            r20 = rho^sqrt(((2/wv)^2 + (0/wh)^2));
            r30 = rho^sqrt(((3/wv)^2 + (0/wh)^2));
            %
            r01 = rho^sqrt(((0/wv)^2 + (1/wh)^2));
            r11 = rho^sqrt(((1/wv)^2 + (1/wh)^2));
            r21 = rho^sqrt(((2/wv)^2 + (1/wh)^2));
            r31 = rho^sqrt(((3/wv)^2 + (1/wh)^2));
            %
            r02 = rho^sqrt(((0/wv)^2 + (2/wh)^2));
            r12 = rho^sqrt(((1/wv)^2 + (2/wh)^2));
            r22 = rho^sqrt(((2/wv)^2 + (2/wh)^2));
            r32 = rho^sqrt(((3/wv)^2 + (2/wh)^2));
            %
            r03 = rho^sqrt(((0/wv)^2 + (3/wh)^2));
            r13 = rho^sqrt(((1/wv)^2 + (3/wh)^2));
            r23 = rho^sqrt(((2/wv)^2 + (3/wh)^2));
            r33 = rho^sqrt(((3/wv)^2 + (3/wh)^2));
            
            % Expected values
            corExpctd = [
                1.0 r10 r20 r30 r01 r11 r21 r31 r02 r12 r22 r32 r03 r13 r23 r33;
                r10 1.0 r10 r20 r11 r01 r11 r21 r12 r02 r12 r22 r13 r03 r13 r23;
                r20 r10 1.0 r10 r21 r11 r01 r11 r22 r12 r02 r12 r23 r13 r03 r13;
                r30 r20 r10 1.0 r31 r21 r11 r01 r32 r22 r12 r02 r33 r23 r13 r03;
                r01 r11 r21 r31 1.0 r10 r20 r30 r01 r11 r21 r31 r02 r12 r22 r32;
                r11 r01 r11 r21 r10 1.0 r10 r20 r11 r01 r11 r21 r12 r02 r12 r22;
                r21 r11 r01 r11 r20 r10 1.0 r10 r21 r11 r01 r11 r22 r12 r02 r12;
                r31 r21 r11 r01 r30 r20 r10 1.0 r31 r21 r11 r01 r32 r22 r12 r02;
                r02 r12 r22 r32 r01 r11 r21 r31 1.0 r10 r20 r30 r01 r11 r21 r31;
                r12 r02 r12 r22 r11 r01 r11 r21 r10 1.0 r10 r20 r11 r01 r11 r21;
                r22 r12 r02 r12 r21 r11 r01 r11 r20 r10 1.0 r10 r21 r11 r01 r11;
                r32 r22 r12 r02 r31 r21 r11 r01 r30 r20 r10 1.0 r31 r21 r11 r01;
                r03 r13 r23 r33 r02 r12 r22 r32 r01 r11 r21 r31 1.0 r10 r20 r30;
                r13 r03 r13 r23 r12 r02 r12 r22 r11 r01 r11 r21 r10 1.0 r10 r20;
                r23 r13 r03 r13 r22 r12 r02 r12 r21 r11 r01 r11 r20 r10 1.0 r10;
                r33 r23 r13 r03 r32 r22 r12 r02 r31 r21 r11 r01 r30 r20 r10 1.0
                ];
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps,rho,wv);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % test with weigt
        function this = testGetCorrelationMatrixWithRotation(this)
            
            % Parameters
            nTaps = [ 2 2 ];
            rho = 0.95;
            wv = sqrt(2);
            wh = 1/wv;
            theta = pi/6;
            %
            wMtx = diag([1/wv 1/wh]);
            rMtx = [ cos(theta) -sin(theta) ;
                sin(theta) cos(theta) ];
            rho10 = rho^norm(wMtx*rMtx*[ 1 0 ].');
            rho01 = rho^norm(wMtx*rMtx*[ 0 1 ].');
            rho11 = rho^norm(wMtx*rMtx*[ 1 1 ].');
            
            % Expected values
            corExpctd = [
                1.0   rho10 rho01 rho11;
                rho10 1.0   rho11 rho01;
                rho01 rho11 1.0   rho10;
                rho11 rho01 rho10 1.0
                ];
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps,rho,wv,theta);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % test with 44 taps
        function this = testGetCorrelationMatrixWithRotationFor44Taps(this)
            
            % Parameters
            nTaps = [ 4 4 ];
            rho = 0.95;
            wv = sqrt(2);
            wh = 1/wv;
            theta = pi/6;
            
            %
            wMtx = diag([1/wv 1/wh]);
            rMtx = [
                cos(theta) -sin(theta) ;
                sin(theta) cos(theta) ];
            
            r10 = rho^(norm(wMtx*rMtx*[1 0].'));
            r20 = rho^(norm(wMtx*rMtx*[2 0].'));
            r30 = rho^(norm(wMtx*rMtx*[3 0].'));
            %
            r01 = rho^(norm(wMtx*rMtx*[0 1].'));
            r11 = rho^(norm(wMtx*rMtx*[1 1].'));
            r21 = rho^(norm(wMtx*rMtx*[2 1].'));
            r31 = rho^(norm(wMtx*rMtx*[3 1].'));
            %
            r02 = rho^(norm(wMtx*rMtx*[0 2].'));
            r12 = rho^(norm(wMtx*rMtx*[1 2].'));
            r22 = rho^(norm(wMtx*rMtx*[2 2].'));
            r32 = rho^(norm(wMtx*rMtx*[3 2].'));
            %
            r03 = rho^(norm(wMtx*rMtx*[0 3].'));
            r13 = rho^(norm(wMtx*rMtx*[1 3].'));
            r23 = rho^(norm(wMtx*rMtx*[2 3].'));
            r33 = rho^(norm(wMtx*rMtx*[3 3].'));
            
            % Expected values
            corExpctd = [
                1.0 r10 r20 r30 r01 r11 r21 r31 r02 r12 r22 r32 r03 r13 r23 r33;
                r10 1.0 r10 r20 r11 r01 r11 r21 r12 r02 r12 r22 r13 r03 r13 r23;
                r20 r10 1.0 r10 r21 r11 r01 r11 r22 r12 r02 r12 r23 r13 r03 r13;
                r30 r20 r10 1.0 r31 r21 r11 r01 r32 r22 r12 r02 r33 r23 r13 r03;
                r01 r11 r21 r31 1.0 r10 r20 r30 r01 r11 r21 r31 r02 r12 r22 r32;
                r11 r01 r11 r21 r10 1.0 r10 r20 r11 r01 r11 r21 r12 r02 r12 r22;
                r21 r11 r01 r11 r20 r10 1.0 r10 r21 r11 r01 r11 r22 r12 r02 r12;
                r31 r21 r11 r01 r30 r20 r10 1.0 r31 r21 r11 r01 r32 r22 r12 r02;
                r02 r12 r22 r32 r01 r11 r21 r31 1.0 r10 r20 r30 r01 r11 r21 r31;
                r12 r02 r12 r22 r11 r01 r11 r21 r10 1.0 r10 r20 r11 r01 r11 r21;
                r22 r12 r02 r12 r21 r11 r01 r11 r20 r10 1.0 r10 r21 r11 r01 r11;
                r32 r22 r12 r02 r31 r21 r11 r01 r30 r20 r10 1.0 r31 r21 r11 r01;
                r03 r13 r23 r33 r02 r12 r22 r32 r01 r11 r21 r31 1.0 r10 r20 r30;
                r13 r03 r13 r23 r12 r02 r12 r22 r11 r01 r11 r21 r10 1.0 r10 r20;
                r23 r13 r03 r13 r22 r12 r02 r12 r21 r11 r01 r11 r20 r10 1.0 r10;
                r33 r23 r13 r03 r32 r22 r12 r02 r31 r21 r11 r01 r30 r20 r10 1.0
                ];
            
            % Instantiation of target class
            this.cg = CodingGain(nTaps,rho,wv,theta);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
        end
        
    end
end
