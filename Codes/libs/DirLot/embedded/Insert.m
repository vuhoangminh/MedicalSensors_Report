classdef Insert < matlab.System %#codegen
    %INSERT CoefficientInsert class
    %
    % SVN identifier:
    % $Id: Insert.m 348 2012-10-31 06:10:34Z harashin $
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
        function obj = Insert(varargin)
            
        end
        
    end
    
    methods (Access = protected)
        function value = stepImpl(~,src1,src2)
            [nRows, nCols] = size(src2);
            value = src2;
            value(1:2:nRows,1:2:nCols) = src1;
            
        end
        function num = getNumInputsImpl(~)
            num = 2;
        end
    end
end

