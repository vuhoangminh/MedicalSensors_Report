classdef ForwardBlockDct2dFixd < matlab.System %#codegen
    %FORWARDBLOCKDCT2DFIXD 2-D forward block discrete cosine transform class for fixed-point arithmetic
    %
    % SVN identifier:
    % $Id: ForwardBlockDct2dFixd.m 348 2012-10-31 06:10:34Z harashin $
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
        e0;
        blc = fi(zeros(2),1,20,6);;
        blcRow = fi(zeros(4,1),1,20,6);
    end
    
    methods 
        function obj = ForwardBlockDct2dFixd()
            obj.e0 = fi([
                0.5000    0.5000    0.5000    0.5000;
                0.5000   -0.5000   -0.5000    0.5000;
                -0.5000    0.5000   -0.5000    0.5000;
                -0.5000   -0.5000    0.5000    0.5000
                ],1,20,6);
        end
    end
    
    methods (Access = protected)
        function value = stepImpl(obj,src)
            [nRows, nCols] = size(src);
            value = zeros(nRows,nCols);
            for iCol = 1:obj.dec:nCols
                for iRow = 1:obj.dec:nRows
                    obj.blc = src(iRow:iRow+1,iCol:iCol+1);
                    obj.blcRow(1:2) = obj.blc(1:2,1);
                    obj.blcRow(3:4)= obj.blc(1:2,2);
                    value(iRow:iRow+2-1,iCol:iCol+2-1) = ...
                        reshape(obj.e0*flipud(obj.blcRow),2,2);
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

