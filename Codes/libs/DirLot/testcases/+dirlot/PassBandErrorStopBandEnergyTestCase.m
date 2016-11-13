classdef PassBandErrorStopBandEnergyTestCase < TestCase
    %PASSBANDERRORSTOPBANDENERGYTESTCASE Test case for PassBandErrrorStopBandEnergy
    %
    % SVN identifier:
    % $Id: PassBandErrorStopBandEnergyTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        spp
    end
    
    methods
      
        function this = tearDown(this)
            delete(this.spp)
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Parameters
            nPoints = [16 16];
            dir = Direction.VERTICAL;
            alpha = 0.0;
            this.spp = SubbandSpecification(alpha,dir);
            
            % Synthesis filters for test
            rosLyLx = getSubbandLocation(this.spp,nPoints,Subband.LyLx);
            filtImp{Subband.LyLx} = ifft2(ifftshift(rosLyLx));
            spcRosLyLx = 2*rosLyLx-1;
            rosHyLx = getSubbandLocation(this.spp,nPoints,Subband.HyLx);
            filtImp{Subband.HyLx} = ifft2(ifftshift(rosHyLx));
            spcRosHyLx = 2*rosHyLx-1;
            rosLyHx = getSubbandLocation(this.spp,nPoints,Subband.LyHx);
            filtImp{Subband.LyHx} = ifft2(ifftshift(rosLyHx));
            spcRosLyHx = 2*rosLyHx-1;
            rosHyHx = getSubbandLocation(this.spp,nPoints,Subband.HyHx);
            filtImp{Subband.HyHx} = ifft2(ifftshift(rosHyHx));
            spcRosHyHx = 2*rosHyHx-1;
            
            % Band specification
            specBand{Subband.LyLx} = spcRosLyLx;
            specBand{Subband.HyLx} = spcRosHyLx;
            specBand{Subband.LyHx} = spcRosLyHx;
            specBand{Subband.HyHx} = spcRosHyHx;
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            sbe = PassBandErrorStopBandEnergy(specBand);
            
            % Actual values
            energyActual = getCost(sbe,filtImp);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testConstructorHorPlusOne6464(this)
            
            % Parameters
            nPoints = [64 64];
            dir = Direction.HORIZONTAL;
            alpha = 1.0;
            this.spp = SubbandSpecification(alpha,dir);
            
            % Synthesis filters for test
            rosLyLx = getSubbandLocation(this.spp,nPoints,Subband.LyLx);
            filtImp{Subband.LyLx} = ifft2(ifftshift(rosLyLx));
            spcRosLyLx = 2*rosLyLx-1;
            rosHyLx = getSubbandLocation(this.spp,nPoints,Subband.HyLx);
            filtImp{Subband.HyLx} = ifft2(ifftshift(rosHyLx));
            spcRosHyLx = 2*rosHyLx-1;
            rosLyHx = getSubbandLocation(this.spp,nPoints,Subband.LyHx);
            filtImp{Subband.LyHx} = ifft2(ifftshift(rosLyHx));
            spcRosLyHx = 2*rosLyHx-1;
            rosHyHx = getSubbandLocation(this.spp,nPoints,Subband.HyHx);
            filtImp{Subband.HyHx} = ifft2(ifftshift(rosHyHx));
            spcRosHyHx = 2*rosHyHx-1;
            
            % PassBand specification
            specBand{Subband.LyLx} = spcRosLyLx;
            specBand{Subband.HyLx} = spcRosHyLx;
            specBand{Subband.LyHx} = spcRosLyHx;
            specBand{Subband.HyHx} = spcRosHyHx;
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            sbe = PassBandErrorStopBandEnergy(specBand);
            
            % Actual values
            energyActual = getCost(sbe,filtImp);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        
        % Test for default construction
        function this = testGetCostAt(this)
            
            % Parameters
            nPoints = [16 16];
            dir = Direction.VERTICAL;
            alpha = 0.0;
            this.spp = SubbandSpecification(alpha,dir);
            
            % Synthesis filters for test
            rosLyLx = getSubbandLocation(this.spp,nPoints,Subband.LyLx);
            spcRosLyLx = 2*rosLyLx-1;
            rosHyLx = getSubbandLocation(this.spp,nPoints,Subband.HyLx);
            spcRosHyLx = 2*rosHyLx-1;
            rosLyHx = getSubbandLocation(this.spp,nPoints,Subband.LyHx);
            spcRosLyHx = 2*rosLyHx-1;
            rosHyHx = getSubbandLocation(this.spp,nPoints,Subband.HyHx);
            filtImp = ifft2(ifftshift(rosLyLx));
            spcRosHyHx = 2*rosHyHx-1;
            
            % PassBand specification
            specBand{Subband.LyLx} = spcRosLyLx;
            specBand{Subband.HyLx} = spcRosHyLx;
            specBand{Subband.LyHx} = spcRosLyHx;
            specBand{Subband.HyHx} = spcRosHyHx;
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            pbesbe = PassBandErrorStopBandEnergy(specBand);
            
            % Actual values
            energyActual = getCostAt(pbesbe,filtImp,Subband.LyLx);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
        % Test for default construction
        function this = testGetCostAtWithNullAssignment(this)
            
            % Parameters
            nPoints = [16 16];
            dir = Direction.VERTICAL;
            alpha = 0.0;
            this.spp = SubbandSpecification(alpha,dir);
            
            % Synthesis filters for test
            filtImp = randn(nPoints);
            
            % PassBand specification
            specBand{Subband.LyLx} = [];
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            pbesbe = PassBandErrorStopBandEnergy(specBand);
            
            % Actual values
            energyActual = getCostAt(pbesbe,filtImp,Subband.LyLx);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        
    end
end
