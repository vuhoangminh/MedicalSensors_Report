classdef ForwardBlockDct2d < matlab.System %#codegen
    %FORWARDBLOCKDCT2D 2-D forward block discrete cosine transform class
    %
    % SVN identifier:
    % $Id: ForwardBlockDct2d.m 348 2012-10-31 06:10:34Z harashin $
    %
    % Requirements: MATLAB R2008a
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
    %    
    properties(Nontunable)
    dec = 2;    
    end
    
    properties
%         e0;
%         blc = zeros(2);
%         blcRow = zeros(4,1);
        x;
    end
    
    methods 
        function obj = ForwardBlockDct2d()
%             obj.e0 = [
%                 0.5000    0.5000    0.5000    0.5000;
%                 0.5000   -0.5000   -0.5000    0.5000;
%                 -0.5000    0.5000   -0.5000    0.5000;
%                 -0.5000   -0.5000    0.5000    0.5000
%                 ];
            obj.x = zeros(2,2);
        end
    end
    
    methods (Access = protected)
        function value = stepImpl(obj,src)
            [nRows, nCols] = size(src);
            value = zeros(nRows,nCols);
            for iCol = 1:obj.dec:nCols
                for iRow = 1:obj.dec:nRows
                    obj.x = src(iRow:iRow+1,iCol:iCol+1);
                    value(iRow,iCol) = ...
                        double(obj.x(1,1)/2 + obj.x(2,1)/2 + ...
                        obj.x(1,2)/2 + obj.x(2,2)/2);
                    value(iRow+1,iCol) = ...
                        double(obj.x(1,1)/2 - obj.x(2,1)/2 - ...
                        obj.x(1,2)/2 + obj.x(2,2)/2);
                    value(iRow,iCol+1) = ...
                        double(obj.x(1,1)/2 - obj.x(2,1)/2 + ...
                        obj.x(1,2)/2 - obj.x(2,2)/2);
                    value(iRow+1,iCol+1) = ...
                        double(obj.x(1,1)/2 + obj.x(2,1)/2 - ...
                        obj.x(1,2)/2 - obj.x(2,2)/2);
                    
%                     obj.blc = src(iRow:iRow+1,iCol:iCol+1);
%                     obj.blcRow(1:2) = obj.blc(1:2,1);
%                     obj.blcRow(3:4)= obj.blc(1:2,2);
%                     value(iRow:iRow+2-1,iCol:iCol+2-1) = ...
%                         reshape(obj.e0*flipud(obj.blcRow),2,2);
%                     obj.blc = src(iRow:iRow+obj.dec-1,iCol:iCol+obj.dec-1);
%                     obj.blcRow(1:obj.dec) = obj.blc(1:2,1);
%                     obj.blcRow(obj.dec+1:obj.dec+obj.dec)= obj.blc(1:2,2);
%                     value(iRow:iRow+obj.dec-1,iCol:iCol+obj.dec-1) = ...
%                         reshape(obj.e0*flipud(obj.blcRow),obj.dec,obj.dec);
                end
            end
        end
    end
    
end

