classdef GenLotTestSuite < TestSuite
    %GENLOTTESTSUITE Test suite for genlot
    %
    % SVN identifier:
    % $Id: GenLotTestSuite.m 249 2011-11-27 01:55:42Z sho $
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
    end
    
    methods
        function ste = suite(this)
            ste = {
                'genlot.LpPuFb1dVm0TestCase',...
                'genlot.LpPuFb1dVm1TestCase',...
                'genlot.LpPuFb1dVm2TestCase',...
                'genlot.LpPuFb1dFactoryTestCase',...
                'genlot.ForwardGenLotTestCase',...
                'genlot.InverseGenLotTestCase',...
                'genlot.ForwardGenLot2dTestCase',...
                'genlot.InverseGenLot2dTestCase',...
                'genlot.SubbandSpecification1dTestCase',...
                'genlot.PassBandErrorStopBandEnergy1dTestCase',...
                'genlot.LpPuFb1dDesignerFrTestCase',...
                'genlot.CodingGain1dTestCase',...
                'genlot.LpPuFb1dDesignerCgTestCase'
                };
        end
    end
end
