classdef PassBandErrorStopBandEnergy1dTestCase < TestCase
    %PASSBANDERRORSTOPBANDENERGY1DTESTCASE Test case for PassBandErrrorStopBandEnergy1d
    %
    % SVN identifier:
    % $Id: PassBandErrorStopBandEnergy1dTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        spp
    end
    
    methods
        
        function this = tearDown(this)
            delete(this.spp)
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Parameters
            dec = 4;
            nPoints = 16;
            this.spp = SubbandSpecification1d(dec);
            
            % Synthesis filters for test
            spcRos = zeros(dec,nPoints);
            filtImp = cell(dec,1);
            for idx = 1:dec
                ros = getSubbandLocation(this.spp,nPoints,1);
                filtImp{idx} = ifft(ifftshift(ros));
                spcRos(idx,:) = 2*ros-1;
            end
            
            % Band specification
            specBand = cell(dec,1);
            for idx = 1:dec
                specBand{idx} = spcRos(idx,:);
            end
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            sbe = PassBandErrorStopBandEnergy1d(specBand);
            
            % Actual values
            energyActual = getCost(sbe,filtImp);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end

        % Test for default construction
        function this = testConstructorPnt64(this)
            
            % Parameters
            dec = 4;
            nPoints = 64;
            this.spp = SubbandSpecification1d(dec);
            
            % Synthesis filters for test
            spc = zeros(dec,nPoints);
            filtImp = cell(dec,nPoints);
            for idx = 1:dec
                ros = getSubbandLocation(this.spp,nPoints,idx);
                filtImp{idx} = ifft(ifftshift(ros));
                spc(idx,:) = 2*ros-1;
            end
            
            % PassBand specification
            specBand = cell(dec,1);
            for idx = 1:dec
                specBand{idx} = spc(idx,:);
            end
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            sbe = PassBandErrorStopBandEnergy1d(specBand);
            
            % Actual values
            energyActual = getCost(sbe,filtImp);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testConstructorDec8Pnt64(this)
            
            % Parameters
            dec = 8;
            nPoints = 64;
            this.spp = SubbandSpecification1d(dec);
            
            % Synthesis filters for test
            spc = zeros(dec,nPoints);
            filtImp = cell(dec,nPoints);
            for idx = 1:dec
                ros = getSubbandLocation(this.spp,nPoints,idx);
                filtImp{idx} = ifft(ifftshift(ros));
                spc(idx,:) = 2*ros-1;
            end
            
            % PassBand specification
            specBand = cell(dec,1);
            for idx = 1:dec
                specBand{idx} = spc(idx,:);
            end
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            sbe = PassBandErrorStopBandEnergy1d(specBand);
            
            % Actual values
            energyActual = getCost(sbe,filtImp);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testGetCostAt(this)
            
            % Parameters
            dec = 4;
            nPoints = 16;
            this.spp = SubbandSpecification1d(dec);
            
            % Synthesis filters for test
            spc = zeros(dec,nPoints);
            for idx = 1:dec
                ros = getSubbandLocation(this.spp,nPoints,idx);
                spc(idx,:) = 2*ros-1;
            end
            filtImp = ifft(ifftshift(ros));
            
            % PassBand specification
            specBand = cell(dec,1);
            for idx = 1:dec
                specBand{idx} = spc(idx,:);
            end
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            pbesbe = PassBandErrorStopBandEnergy1d(specBand);
            
            % Actual values
            energyActual = getCostAt(pbesbe,filtImp,dec);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end

        % Test for default construction
        function this = testGetCostAtWithNullAssignment(this)
            
            % Parameters
            dec = 4;
            nPoints = 16;
            this.spp = SubbandSpecification1d(dec);
            
            % Synthesis filters for test
            filtImp = randn(nPoints);
            
            % PassBand specification
            specBand{1} = [];
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            pbesbe = PassBandErrorStopBandEnergy1d(specBand);
            
            % Actual values
            energyActual = getCostAt(pbesbe,filtImp,1);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end

    end
end
