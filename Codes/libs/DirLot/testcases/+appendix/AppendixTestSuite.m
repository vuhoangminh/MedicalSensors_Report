classdef AppendixTestSuite < TestSuite
    %APPENDIXTESTSUITE Test suite for appendix
    %
    % SVN identifier:
    % $Id: AppendixTestSuite.m 249 2011-11-27 01:55:42Z sho $
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
                'appendix.ForwardDwt97TestCase',...
                'appendix.InverseDwt97TestCase',...
                'appendix.ForwardDwt53TestCase',...
                'appendix.InverseDwt53TestCase',...                
                'appendix.Dwt97QuantizerTestCase',...
                'appendix.Dwt53QuantizerTestCase',...
                'appendix.PolyPhaseMatrixTestCase'
                };
        end
    end
end
