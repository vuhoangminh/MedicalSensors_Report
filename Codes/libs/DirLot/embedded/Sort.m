classdef Sort < matlab.System %#codegen
    %SORT Sort class
    %
    % SVN identifier:
    % $Id: Sort.m 348 2012-10-31 06:10:34Z harashin $
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
    
        methods
            function obj = Sort(varargin)

            end
    
        end
    
        methods (Access = protected)
            function value = stepImpl(obj,src)
                [nRows, nCols] = size(src);
                value = zeros(nRows,nCols);
                value(1:nRows/2,1:nCols/2) = src(1:2:nRows,1:2:nCols);
                value(1+nRows/2:nRows,1:nCols/2) = src(2:2:nRows,1:2:nCols);
                value(1:nRows/2,1+nCols/2:nCols) = src(1:2:nRows,2:2:nCols);
                value(1+nRows/2:nRows,1+nCols/2:nCols) = src(2:2:nRows,2:2:nCols);                
            end
        end
end

