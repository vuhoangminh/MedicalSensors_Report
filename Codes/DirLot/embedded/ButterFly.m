classdef ButterFly < matlab.System %#codegen
    %BUTTERFLY Butterfly class
    %
    % SVN identifier:
    % $Id: ButterFly.m 346 2012-10-24 05:19:46Z sho $
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
        %matrixB;
        % blc;
        % blcRow;
        xu;
        xl;
    end
    
    methods
        function obj = ButterFly()
            %                 obj.matrixB = [
            %                     1 0 1 0;
            %                     0 1 0 1;
            %                     1 0 -1 0;
            %                     0 1 0 -1
            %                     ];
            %   obj.blc = zeros(2);
            %   obj.blcRow = zeros(4,1);
            obj.xu = zeros(2,1);
            obj.xl = zeros(2,1);
        end
        
    end
    
    
    methods (Access = protected)
        function value = stepImpl(obj,src)
            [nRows nCols] = size(src);
            value = zeros(nRows,nCols);
            for iCol = 1:2:nCols
                for iRow = 1:2:nRows
                    obj.xu = src(iRow:iRow+1,iCol);
                    obj.xl = src(iRow:iRow+1,iCol+1);
                    value(iRow:iRow+1,iCol) = double(obj.xu+obj.xl);
                    value(iRow:iRow+1,iCol+1) = double(obj.xu-obj.xl);
                    %{
                        obj.blc = src(iRow:iRow+1,iCol:iCol+1);
                        obj.blcRow(1:2) = obj.blc(1:2,1);
                        obj.blcRow(3:4)= obj.blc(1:2,2);
                    %}
                    % value(iRow:iRow+2-1,iCol:iCol+2-1) = ...
                    %     reshape(obj.matrixB*(obj.blcRow),2,2);
                    %                         obj.blc = src(iRow:iRow+obj.dec-1,iCol:iCol+obj.dec-1);
                    
                    %                     obj.blcRow(1:obj.dec) = obj.blc(:,1);
                    %                     obj.blcRow(obj.dec+1:obj.dec+obj.dec)= obj.blc(:,2);
                    %                     value(iRow:iRow+obj.dec-1,iCol:iCol+obj.dec-1) = ...
                    %                         reshape(obj.matrixB*(obj.blcRow),obj.dec,obj.dec);
                end
            end
            
        end
    end
end

