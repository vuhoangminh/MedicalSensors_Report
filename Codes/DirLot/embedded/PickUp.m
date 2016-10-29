classdef PickUp < matlab.System %#codegen
    %PICKUP PickUp class
    %
    % SVN identifier:
    % $Id: PickUp.m 348 2012-10-31 06:10:34Z harashin $
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
        
        function obj = PickUp(varargin)
            
        end
    end
    
    methods (Access = protected)
        function value = stepImpl(obj,src)
            [nRows, nCols] = size(src);
            %                 value = zeros(nRows/2,nCols/2);
            value = src(1:2:nRows,1:2:nCols);
        end
    end
end

