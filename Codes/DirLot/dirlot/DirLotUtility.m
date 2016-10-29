classdef DirLotUtility
    %DIRLOTUTILITY Utility class for DirLOT Project
    %
    % SVN identifier:
    % $Id: DirLotUtility.m 184 2011-08-17 14:13:14Z sho $
    %
    % Requirements: MATLAB R2008a, mlunit-2.0-beta1
    %
    % Copyright (c) 2008-2009, Shogo MURAMATSU, Tomoya KOBAYASHI
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
    
    methods (Static = true)
        
        function value = blockproc(varargin)
            if exist('blockproc','file') == 2
                fun = @(x) varargin{end}(x.data);
                varargin{end} = fun;
                value = blockproc(varargin{:});
            else
                value = blkproc(varargin{:});
            end
        end
        
        function value = bphix(phi,dec)
            M = prod(dec);
            value = DirLotUtility.bphi(phi,dec)/(sqrt(M)*cos(pi*phi/180));
        end
        
        function value = bphiy(phi,dec)
            M = prod(dec);
            value = DirLotUtility.bphi(phi,dec)/(sqrt(M)*sin(pi*phi/180));
        end
        
        function value = bphi(phi,dec)
            E0 = double(LpPuFb2d(dec));
            M = prod(dec);
            L = M/2;
            Z = zeros(L);
            I = eye(L);
            My = dec(Direction.VERTICAL);
            phi = pi * phi /180.0;
            dy = -mod(0:M-1,My).';
            dx = -floor((0:M-1)/My).';
            by = 2/sqrt(M)*[Z I]*E0*dy;
            bx = 2/sqrt(M)*[Z I]*E0*dx;
            value = by*sin(phi)+bx*cos(phi);
        end
        
        function value = trendSurface(phi,dim)
            phi = pi*phi/180;
            nRows = dim(Direction.VERTICAL);
            nCols = dim(Direction.HORIZONTAL);
            I = zeros(nRows,nCols);
            for iCol = 1:nCols
                for iRow = 1:nRows
                    I(iRow,iCol) = ...
                        (iRow-nRows/2)*sin(phi)+(iCol-nCols/2)*cos(phi);
                end
            end
            theta = atan(nRows/nCols);
            value = I/((nRows*sin(theta)+nCols*cos(theta)))+0.5;
        end
        
        function value = rampEdge(phi,slope,dim)
            phi = pi*phi/180;
            nRows = dim(Direction.VERTICAL);
            nCols = dim(Direction.HORIZONTAL);
            I = zeros(nRows,nCols);
            for iCol = 1:nCols
                for iRow = 1:nRows
                    I(iRow,iCol) = slope * ...
                        ((iRow-nRows/2)*sin(phi)+(iCol-nCols/2)*cos(phi));
                end
            end
            theta = atan(nRows/nCols);
            value = I/((nRows*sin(theta)+nCols*cos(theta)))+0.5;
            value(0.9<value)=0.9;
            value(0.1>value)=0.1;
        end
        
        function value = coswave(phi,f,dim)
            phi = pi*phi/180;
            nRows = dim(Direction.VERTICAL);
            nCols = dim(Direction.HORIZONTAL);
            [x,y] = meshgrid(0:1/nCols:(1-1/nCols),0:1/nRows:(1-1/nRows));
            fx = cos(phi)*f;
            fy = sin(phi)*f;
            value = 0.5*cos(2*pi*(fx*x+fy*y))+0.5;
        end
        
    end
end

