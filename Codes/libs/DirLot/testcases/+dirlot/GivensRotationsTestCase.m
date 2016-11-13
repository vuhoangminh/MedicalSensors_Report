classdef GivensRotationsTestCase < TestCase
    %GIVENSROTATIONSTESTCASE Test case for GivensRotations
    %
    % SVN identifier:
    % $Id: GivensRotationsTestCase.m 249 2011-11-27 01:55:42Z sho $
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
        gr
    end
    
    methods
   
        function this = tearDown(this)
            delete(this.gr);
        end
        
        % Test for default construction
        function this = testConstructor(this)
            
            % Expected values
            coefExpctd = [
                1 0 ;
                0 1 ];
            
            % Instantiation of target class
            this.gr = GivensRotations();
            
            % Actual values
            coefActual = double(this.gr);
            
            % Evaluation
            this.assertEquals(coefExpctd,coefActual);
        end
        
        % Test for default construction
        function this = testConstructorWithAngles(this)
            
            % Expected values
            coefExpctd = [
                cos(pi/4) -sin(pi/4) ;
                sin(pi/4)  cos(pi/4) ];
            
            % Instantiation of target class
            this.gr = GivensRotations(pi/4);
            
            % Actual values
            coefActual = double(this.gr);
            
            % Evaluation
            this.assertEquals(coefExpctd,coefActual);
        end
        
        % Test for default construction
        function this = testConstructorWithAnglesAndMus(this)
            
            % Expected values
            coefExpctd = [
                cos(pi/4) -sin(pi/4) ;
                -sin(pi/4) -cos(pi/4) ];
            
            % Instantiation of target class
            gr = GivensRotations(pi/4,[ 1 -1 ]);
            
            % Actual values
            coefActual = double(gr);
            
            % Evaluation
            this.assertEquals(coefExpctd,coefActual);
        end
        
        % Test for char
        function this = testChar(this)
            
            % Expected values
            charExpctd = [
                9 '+0.70711' 9 '-0.70711' 10 ...
                9 '+0.70711' 9 '+0.70711' 10 ];
            
            % Instantiation of target class
            this.gr = GivensRotations(pi/4);
            
            % Actual values
            charActual = char(this.gr);
            
            % Evaluation
            this.assertEquals(charExpctd,charActual);
        end
        
        % Test for set angle
        function this = testSetAngles(this)
            
            % Expected values
            coefExpctd = [
                1 0 ;
                0 1 ];
            
            % Instantiation of target class
            this.gr = GivensRotations();
            
            % Actual values
            coefActual = double(this.gr);
            
            % Evaluation
            this.assertEquals(coefExpctd,coefActual);
            
            % Expected values
            coefExpctd = [
                cos(pi/4) -sin(pi/4) ;
                sin(pi/4)  cos(pi/4) ];
            
            % Actual values
            this.gr = setAngles(this.gr,pi/4);
            coefActual = double(this.gr);
            
            % Evaluation
            this.assertEquals(coefExpctd,coefActual);
        end
        
        % Test for set angle
        function this = test4x4(this)
            
            % Expected values
            normExpctd = 1;
            
            % Instantiation of target class
            ang = 2*pi*rand(6,1);
            this.gr = GivensRotations(ang);
            
            % Actual values
            normActual = norm(double(this.gr)*[1 0 0 0].');
            
            % Evaluation
            message = ...
                sprintf('normActual=%g differs from 1',normActual);
            this.assert((normExpctd-normActual)<1e-15,message);
        end
        
        % Test for set angle
        function this = test8x8(this)
            
            % Expected values
            normExpctd = 1;
            
            % Instantiation of target class
            ang = 2*pi*rand(28,1);
            this.gr = GivensRotations(ang);
            
            % Actual values
            normActual = norm(double(this.gr)*[1 0 0 0 0 0 0 0].');
            
            % Evaluation
            message = ...
                sprintf('normActual=%g differs from 1',normActual);
            this.assert((normExpctd-normActual)<1e-15,message);
        end
        
        % Test for set angle
        function this = test4x4red(this)
            
            % Expected values
            ltExpctd = 1;
            
            % Instantiation of target class
            ang = 2*pi*rand(6,1);
            nSize = 4;
            ang(1:nSize-1,1) = zeros(nSize-1,1);
            this.gr = GivensRotations(ang);
            
            % Actual values
            matrix = double(this.gr);
            ltActual = matrix(1,1);
            
            % Evaluation
            message = ...
                sprintf('ltActual=%g differs from 1',ltActual);
            this.assert((ltExpctd-ltActual)<1e-15,message);
        end
        
        
        % Test for set angle
        function this = test8x8red(this)
            
            % Expected values
            ltExpctd = 1;
            
            % Instantiation of target class
            ang = 2*pi*rand(28,1);
            nSize = 8;
            ang(1:nSize-1,1) = zeros(nSize-1,1);
            this.gr = GivensRotations(ang);
            
            % Actual values
            matrix = double(this.gr);
            ltActual = matrix(1,1);
            
            % Evaluation
            message = ...
                sprintf('ltActual=%g differs from 1',ltActual);
            this.assert((ltExpctd-ltActual)<1e-15,message);
        end
        
        % Test for set angle
        function this = testSetMatrix2x2(this)
            
            % Expected values
            mtxExpctd = [
                0 -1 ;
                1  0 ];
            
            % Instantiation of target class
            this.gr = GivensRotations();
            
            % Set matrix
            this.gr = setMatrix(this.gr,mtxExpctd);
            
            % Get matrix
            mtxActual = double(this.gr);
            
            % Evaluation
            message = 'Actual matrix is not the expected one.';
            this.assert(norm(mtxExpctd-mtxActual)<1e-15,message);
        end
        
        % Test for set angle
        function this = testSetMatrix4x4(this)
            
            % Expected values
            mtxExpctd = [
                0  0  1  0 ;
                0  0  0  1 ;
                1  0  0  0 ;
                0  1  0  0 ];
            
            % Instantiation of target class
            this.gr = GivensRotations();
            
            % Set matrix
            this.gr = setMatrix(this.gr,mtxExpctd);
            
            % Get matrix
            mtxActual = double(this.gr);
            
            % Evaluation
            message = 'Actual matrix is not the expected one.';
            this.assert(norm(mtxExpctd-mtxActual)<1e-15,message);
        end
        
        % Test for set angle
        function this = testSetMatrix8x8(this)
            
            % Expected values
            I = eye(4);
            Z = zeros(4);
            mtxExpctd = [
                Z  I ;
                I  Z ];
            
            % Instantiation of target class
            this.gr = GivensRotations();
            
            % Set matrix
            this.gr = setMatrix(this.gr,mtxExpctd);
            
            % Get matrix
            mtxActual = double(this.gr);
            
            % Evaluation
            message = 'Actual matrix is not the expected one.';
            this.assert(norm(mtxExpctd-mtxActual)<1e-15,message);
        end
        
        % Test for set angle
        function this = testSetProjectionOfVector(this)
            
            angleExpctd = -pi/4;
            
            % Vector
            vector = [ 1 -1 ; 1  1 ] * [ 1 ; 0 ];
            
            % Instantiation of target class
            this.gr = GivensRotations();
            
            % Set vector
            this.gr = setProjectionOfVector(this.gr,vector);
            
            % Get angles
            angleActual = getAngles(this.gr);
            
            % Evaluation
            message = 'Actual angle is not the expected one.';
            this.assert((angleExpctd-angleActual)<1e-15,message);
        end
        
    end
end
