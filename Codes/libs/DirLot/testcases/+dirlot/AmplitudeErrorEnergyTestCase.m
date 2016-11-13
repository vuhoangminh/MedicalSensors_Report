classdef AmplitudeErrorEnergyTestCase < TestCase
    %AMPLITUDEERRORENERGYTESTCASE Test case for AmplitudeErrorEnergy
    %
    % SVN identifier:
    % $Id: AmplitudeErrorEnergyTestCase.m 249 2011-11-27 01:55:42Z sho $
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
            nPoints = [16 16];
            dir = Direction.VERTICAL;
            alpha = 0.0;
            this.spp = SubbandSpecification(alpha,dir);
            
            % Synthesis filters for test 
            spcAmpLyLx = rand(nPoints); %getAmplitudeSpecification(this.spp,nPoints,Subband.LyLx); % TODO: Concrete values
            spcAmpHyLx = rand(nPoints); %getAmplitudeSpecification(this.spp,nPoints,Subband.HyLx);
            spcAmpLyHx = rand(nPoints); %getAmplitudeSpecification(this.spp,nPoints,Subband.LyHx);
            spcAmpHyHx = rand(nPoints); %getAmplitudeSpecification(this.spp,nPoints,Subband.HyHx);
            
            % Band specification
            specBand{Subband.LyLx} = spcAmpLyLx;
            specBand{Subband.HyLx} = spcAmpHyLx;
            specBand{Subband.LyHx} = spcAmpLyHx;
            specBand{Subband.HyHx} = spcAmpHyHx;
            
            % Impulse response
            [x,y] = meshgrid(-pi:2*pi/nPoints(2):pi-2*pi/nPoints(2),...
                -pi:2*pi/nPoints(1):pi-2*pi/nPoints(1));
            halfdelay = exp(-1i*(x+y)/2);
            filtImp{Subband.LyLx} = circshift(... % TODO: Concrete values
                ifft2(ifftshift(spcAmpLyLx.*halfdelay)),nPoints/2-1);
            filtImp{Subband.HyLx} = circshift(...
                ifft2(ifftshift(spcAmpHyLx.*halfdelay)),nPoints/2-1);
            filtImp{Subband.LyHx} = circshift(...
                ifft2(ifftshift(spcAmpLyHx.*halfdelay)),nPoints/2-1);
            filtImp{Subband.HyHx} = circshift(...
                ifft2(ifftshift(spcAmpHyHx.*halfdelay)),nPoints/2-1);
            
            % Expected values
            energyExpctd = 0.0;
            
            % Instantiation of target class
            aee = AmplitudeErrorEnergy(specBand);
            
            % Actual values
            energyActual = getCost(aee,filtImp);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
            
        end
        
                % Test for default construction
        function this = testConstructorWithNullBasis(this)
            
            % Parameters
            nPoints = [16 16];
            dir = Direction.VERTICAL;
            alpha = 0.0;
            this.spp = SubbandSpecification(alpha,dir);
            
            % Synthesis filters for test
            spcAmpLyLx = rand(nPoints); %getAmplitudeSpecification(this.spp,nPoints,Subband.LyLx); % TODO: Concrete values
            spcAmpHyLx = rand(nPoints); %getAmplitudeSpecification(this.spp,nPoints,Subband.HyLx);
            spcAmpLyHx = rand(nPoints); %getAmplitudeSpecification(this.spp,nPoints,Subband.LyHx);
            spcAmpHyHx = rand(nPoints); %getAmplitudeSpecification(this.spp,nPoints,Subband.HyHx);
            
            % Band specification
            specBand{Subband.LyLx} = spcAmpLyLx;
            specBand{Subband.HyLx} = spcAmpHyLx;
            specBand{Subband.LyHx} = spcAmpLyHx;
            specBand{Subband.HyHx} = spcAmpHyHx;
            
            % Impulse response
            filtImp{Subband.LyLx} = zeros(nPoints);
            filtImp{Subband.HyLx} = zeros(nPoints);
            filtImp{Subband.LyHx} = zeros(nPoints);
            filtImp{Subband.HyHx} = zeros(nPoints);
            
            % Expected values
            energyExpctd = ...
                spcAmpLyLx(:).'*spcAmpLyLx(:) + ...
                spcAmpHyLx(:).'*spcAmpHyLx(:) + ...
                spcAmpLyHx(:).'*spcAmpLyHx(:) + ...
                spcAmpHyHx(:).'*spcAmpHyHx(:);
            
            % Instantiation of target class
            aee = AmplitudeErrorEnergy(specBand);
            
            % Actual values
            energyActual = getCost(aee,filtImp);
            
            % Evaluation
            diff = abs(energyExpctd - energyActual);
            this.assert(diff<1e-15,sprintf('%g',diff));
            
            
        end
        
        %{
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
            diff = energyExpctd - energyActual;
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
            diff = energyExpctd - energyActual;
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
            diff = energyExpctd - energyActual;
            this.assert(diff<1e-15,sprintf('%g',diff));
            
        end
        %}
    end
end
