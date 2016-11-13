classdef SubbandSpecification1dTestCase < TestCase
    %SUBBANDSPECIFICATION1DTESTCASE Test case for 1-D SubbandSpecification
    %
    % SVN identifier:
    % $Id: SubbandSpecification1dTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        sbsp
    end
    
    methods
      
        function this = tearDown(this)
            delete(this.sbsp);
        end
        
        % Test for default setting
        function this = testDefaultRegionOfSupport(this)
            
            % Input argument
            nPoints = 16;
            
            % Expected array
            rosExpctd = [
                0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 ];
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d();
            rosActual = getRegionOfSupport(this.sbsp,nPoints);
            
            % Evaluation
            message = 'Actual array is not an expected one.';
            this.assertEquals(rosExpctd, rosActual, message);
        end

        % Test for default setting
        function this = testDefaultSmallRegionOfSupport(this)
            
            % Input argument
            nPoints = 8;
            
            % Expected array
            rosExpctd = [
                0 0 0 1 1 0 0 0 ];
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d();
            rosActual = getRegionOfSupport(this.sbsp,nPoints);
            
            % Evaluation
            message = 'Actual array is not an expected one.';
            this.assertEquals(rosExpctd, rosActual, message);
        end
        
        % Test for default setting
        function this = testDefaultRegionOfSupportDec8(this)
            
            % Input argument
            dec = 8;
            nPoints = 32;
            
            % Expected array
            rosExpctd = [
                0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d(dec);
            rosActual = getRegionOfSupport(this.sbsp,nPoints);
            
            % Evaluation
            message = 'Actual array is not an expected one.';
            this.assertEquals(rosExpctd, rosActual, message);
        end
        
        % Test for horizontal positive setting
        function this = testRosWithTransition(this)
            
            % Input argument
            nPoints = 32;
            transition = 0.25;
            
            % Expected array
            rosExpctd = zeros(1,32);
            rosExpctd(14:19) = 1;
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d();
            this.sbsp = setTransition(this.sbsp,transition);
            rosActual = getRegionOfSupport(this.sbsp,nPoints);
            
            % Evaluation
            message = 'Actual array is not an expected one.';
            this.assertEquals(rosExpctd, rosActual, message);
        end
  
        % Test for horizontal positive setting
        function this = testRosWithTransitionDec8(this)
            
            % Input argument
            dec = 8;
            nPoints = 64;
            transition = 0.25;
            
            % Expected array
            rosExpctd = zeros(1,64);
            rosExpctd(30:35) = 1;
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d(dec);
            this.sbsp = setTransition(this.sbsp,transition);
            rosActual = getRegionOfSupport(this.sbsp,nPoints);
            
            % Evaluation
            message = 'Actual array is not an expected one.';
            this.assertEquals(rosExpctd, rosActual, message);
        end
  
        % Test for vertical positive setting
        function this = testGetSubbandLocation(this)
            
            % Input argument
            nPoints = 16;
            
            % Expected array
            rosExpctd(1,:) = [ 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 ];
            rosExpctd(2,:) = [ 0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 ];            
            rosExpctd(3,:) = [ 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 ];
            rosExpctd(4,:) = [ 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1];
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d();
            
            % Evaluation
            for idx = 1:4
                rosActual = getSubbandLocation(this.sbsp,nPoints,idx);
                message = sprintf(...
                    '%d: Actual array is not an expected one.',idx);
                this.assertEquals(rosExpctd(idx,:), rosActual, ...
                    message);
            end
            
        end
        
        % Test for vertical positive setting
        function this = testGetSubbandLocationPnt32(this)
            
            % Input argument
            nPoints = 32;
            
            % Expected array
            rosExpctd(1,:) = [ 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 ];
            rosExpctd(2,:) = [ 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 ];
            rosExpctd(3,:) = [ 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 ];
            rosExpctd(4,:) = [ 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 ];
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d();
            
            % Evaluation
            for idx = 1:4
                rosActual = getSubbandLocation(this.sbsp,nPoints,idx);
                message = sprintf(...
                    '%d: Actual array is not an expected one.',idx);
                this.assertEquals(rosExpctd(idx,:), rosActual, ...
                    message);
            end
            
        end
        
        % Test for vertical positive setting
        function this = testGetSubbandLocationDec8Pnt32(this)
            
            % Input argument
            dec = 8;
            nPoints = 32;
            
            % Expected array
            rosExpctd(1,:) = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
            rosExpctd(2,:) = [ 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 ];
            rosExpctd(3,:) = [ 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 ];
            rosExpctd(4,:) = [ 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 ];
            rosExpctd(5,:) = [ 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 ];            
            rosExpctd(6,:) = [ 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 ];            
            rosExpctd(7,:) = [ 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 ];            
            rosExpctd(8,:) = [ 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 ];            
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d(dec);
            
            % Evaluation
            for idx = 1:dec
                rosActual = getSubbandLocation(this.sbsp,nPoints,idx);
                message = sprintf(...
                    '%d: Actual array is not an expected one.',idx);
                this.assertEquals(rosExpctd(idx,:), rosActual, ...
                    message);
            end
            
        end
        
        % Test for vertical positive setting
        function this = testSubbandAssignment(this)
            
            % Input argument
            nPoints = 32;
            transition = 0.25;
            
            % Expected array
            saExpctd = [
                4 4 4 0 0 2 2 0 0 3 3 0 0 1 1 1 1 1 1 0 0 3 3 0 0 2 2 0 0 4 4 4 ];
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d();
            this.sbsp = setTransition(this.sbsp,transition);
            saActual = getSubbandAssignment(this.sbsp,nPoints);
            
            % Evaluation
            message = 'Actual array is not an expected one.';
            this.assertEquals(saExpctd, saActual, message);
            
        end
        
        % Test for getPassStopAssignment
        function this = testGetPassStopAssignment(this)
            
            % Input argument
            dec = 4;
            nPoints = 32;
            transition = 0.25;
            
            % Expected array
            psaExpctd(1,:) = [
                -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0  0  1  1  1  1  1  1  0  0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ];
            psaExpctd(2,:) = [
                -1 -1 -1  0  0  1  1  0  0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0  0  1  1  0  0 -1 -1 -1 ]; 
            psaExpctd(3,:) = [
                -1 -1 -1 -1 -1 -1 -1  0  0  1  1  0  0 -1 -1 -1 -1 -1 -1  0  0  1  1  0  0 -1 -1 -1 -1 -1 -1 -1 ];
            psaExpctd(4,:) = [
                 1  1  1  0  0 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1  0  0  1  1  1 ]; 

            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d(dec);
            this.sbsp = setTransition(this.sbsp,transition);
            psaActual = zeros(dec,nPoints);
            for idx = 1:dec
                psaActual(idx,:) = getPassStopAssignment(this.sbsp,nPoints,idx);
            end

            % Evaluation
            for idx = 1:dec
                message = 'Actual array is not an expected one.';
                this.assertEquals(psaExpctd(idx,:), psaActual(idx,:), message);
            end
        end
        
                % Test for vertical positive setting
        function this = testSubbandAssignmentDec8(this)
            
            % Input argument
            dec = 8;
            nPoints = 64 ;
            transition = 0.25;
            
            % Expected array
            sa = [ 8 8 8 0 0 4 4 0 0 7 7 0 0 3 3 0 0 6 6 0 0 2 2 0 0 5 5 0 0 1 1 1 ] ;
            saExpctd = [sa fliplr(sa)];
            
            % Instantiation of target clas
            this.sbsp = SubbandSpecification1d(dec);
            this.sbsp = setTransition(this.sbsp,transition);
            saActual = getSubbandAssignment(this.sbsp,nPoints);
            
            % Evaluation
            message = 'Actual array is not an expected one.';
            this.assertEquals(saExpctd, saActual, message);
            
        end
        
    end
end
