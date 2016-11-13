classdef EmbeddedTestSuite < TestSuite
    %EMBEDDEDTESTSUITE Test suite for embedded
    %
    % SVN identifier:
    % $Id: EmbeddedTestSuite.m 349 2012-10-31 06:11:57Z harashin $
    %
    % Requirements: MATLAB R2008a, mlunit_2008a
    %
    % Copyright (c) 2012, Shogo MURAMATSU and Shintaro HARA
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
                'embedded.ForwardBlockDct2dTestCase',...
                'embedded.InverseBlockDct2dTestCase',...
                'embedded.ButterFlyTestCase',...
                'embedded.RotationTestCase',...
                'embedded.CoefShiftTestCase',...
                'embedded.ForwardDirLotEmbTestCase',...
                'embedded.SortTestCase',...
                'embedded.InverseDirLotEmbTestCase',...
                'embedded.PickUpTestCase'...
                'embedded.InsertTestCase'
                };
        end
    end
end
