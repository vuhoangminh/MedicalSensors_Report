classdef CodingGain1dTestCase <  TestCase
    %CODINGGAIN1DTESTCASE Test case for CodingGain1d
    %
    % SVN identifier:
    % $Id: CodingGain1dTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        cg;
    end
    
    methods
        
        function this = tearDown(this)
            delete(this.cg);
        end
        
        % Test for default construction
        function this = testGetCorrelationMatrix(this)
            
            % Parameters
            nTaps = 4;
            rho = 0.95;
            
            % Expected values
            c = rho.^(0:nTaps-1).';            
            corExpctd = toeplitz(c);
            
            % Instantiation of target class
            this.cg = CodingGain1d(nTaps);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end

        function this = testGetCorrelationWithRho(this)
            
            % Parameters
            nTaps = 4;
            rho = 0.98;
            
            % Expected values
            c = rho.^(0:nTaps-1).';
            corExpctd = toeplitz(c);
            
            % Instantiation of target class
            this.cg = CodingGain1d(nTaps,rho);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end

        % Test for default construction
        function this = testGetCost(this)
            
            % Parameters
            nTaps = 4;
            filters = ...
                [0.500000000000000,0.500000000000000,0.500000000000000,0.500000000000000;0.500000000000000,-0.500000000000000,-0.500000000000000,0.500000000000000;-0.653281482438188,-0.270598050073099,0.270598050073099,0.653281482438188;-0.270598050073099,0.653281482438188,-0.653281482438188,0.270598050073099;];

            % Expected values
            costExpctd =   -7.570128474226184;
            
            % Instantiation of target class
            this.cg = CodingGain1d(nTaps);
            
            % Actual values
            costActual = getCost(this.cg,filters);
            
            % Evaluation
            diff = norm(costExpctd - costActual);
            this.assert(diff<1e-3,sprintf('%g',diff));
            
        end

        % Test for getCost
        function this = testGetCostByLpPuFb1d(this)
            
            % Parameters
            nTaps = 4;
            lppufb = LpPuFb1dVm0();
            
            % Expected values
            costExpctd = -7.570128474226184;
            
            % Instantiation of target class
            this.cg = CodingGain1d(nTaps);
            
            % Actual values
            costActual = getCost(this.cg,lppufb);
            
            % Evaluation
            diff = norm(costExpctd - costActual);
            this.assert(diff<1e-3,sprintf('%g',diff));
            
        end
        
        % Test for getCorrelationMatrixTaps8
        function this = testGetCorrelationMatrixTaps8(this)
            
            % Parameters
            nTaps = 8;
            rho = 0.95;
            
            % Expected values
            c = rho.^(0:nTaps-1).';
            corExpctd = toeplitz(c);
            
            % Instantiation of target class
            this.cg = CodingGain1d(nTaps);
            
            % Actual values
            corActual = getCorrelationMatrix(this.cg);
            
            % Evaluation
            diff = norm(corExpctd - corActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for taps=8, dec=8
        function this = testGetCostWithTaps8Dec8(this)
            
            % Parameters
            nTaps = 8;
            dec = 8;
            
            % Filters (1-D DCT)
            filters = dctmtx(dec);

            % Expected values
            costExpctd = -8.825909175731962;
            
            % Instantiation of target class
            this.cg = CodingGain1d(nTaps);
            
            % Actual values
            costActual = getCost(this.cg,filters);
            
            % Evaluation
            diff = norm(costExpctd - costActual);
            this.assert(diff<1e-3,sprintf('%g',diff));
            
        end
        
    end
end
