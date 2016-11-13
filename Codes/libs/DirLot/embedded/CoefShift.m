classdef CoefShift < matlab.System %#codegen
    %COEFSHIFT CoefficientShift class
    %
    % SVN identifier:
    % $Id: CoefShift.m 348 2012-10-31 06:10:34Z harashin $
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
    properties (Nontunable)
        dec = 2;
        DirectionOfShift;
        UpperOrLower;
    end
    
    methods
        function obj = CoefShift(varargin)
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    methods (Access = protected)
        function value = stepImpl(obj,src)
            [nRows, nCols] = size(src);
            value = zeros(nRows,nCols);
            if strcmp(obj.DirectionOfShift,'up') && strcmp(obj.UpperOrLower,'upper')
                value(1:nRows,2:obj.dec:nCols) = src(1:nRows,2:obj.dec:nCols);
                value(nRows-obj.dec+1:nRows,1:obj.dec:nCols) = src(1:obj.dec,1:obj.dec:nCols);
                value(1:nRows-2,1:obj.dec:nCols) = src(obj.dec+1:nRows,1:obj.dec:nCols);
            elseif strcmp(obj.DirectionOfShift,'down') && strcmp(obj.UpperOrLower,'upper')
                value(1:nRows,2:obj.dec:nCols) = src(1:nRows,2:obj.dec:nCols);
                value(1:obj.dec,1:obj.dec:nCols) = src(nRows-obj.dec+1:nRows,1:obj.dec:nCols);
                value(obj.dec+1:nRows,1:obj.dec:nCols) = src(1:nRows-2,1:obj.dec:nCols);
            elseif strcmp(obj.DirectionOfShift,'up') && strcmp(obj.UpperOrLower,'lower')
                value(1:nRows,1:obj.dec:nCols) = src(1:nRows,1:obj.dec:nCols);
                value(1:nRows-obj.dec,2:obj.dec:nCols) = src(obj.dec+1:nRows,2:obj.dec:nCols);
                value(nRows-obj.dec+1:nRows,2:obj.dec:nCols) = src(1:obj.dec,2:obj.dec:nCols);
            elseif strcmp(obj.DirectionOfShift,'down') && strcmp(obj.UpperOrLower,'lower')
                value(1:nRows,1:obj.dec:nCols) = src(1:nRows,1:obj.dec:nCols);
                value(1:obj.dec,2:obj.dec:nCols) = src(nRows-obj.dec+1:nRows,2:obj.dec:nCols);
                value(obj.dec+1:nRows,2:obj.dec:nCols) = src(1:nRows-obj.dec,2:obj.dec:nCols);
            elseif strcmp(obj.DirectionOfShift,'right') && strcmp(obj.UpperOrLower,'upper')
                value(1:nRows,2:obj.dec:nCols) = src(1:nRows,2:obj.dec:nCols);
                value(1:nRows,1) = src(1:nRows,nCols-obj.dec+1);
                value(1:nRows,obj.dec+1:obj.dec:nCols) = src(1:nRows,1:obj.dec:nCols-obj.dec);
            elseif strcmp(obj.DirectionOfShift,'left') && strcmp(obj.UpperOrLower,'upper')
                value(1:nRows,2:obj.dec:nCols) = src(1:nRows,2:obj.dec:nCols);
                value(1:nRows,1:obj.dec:nCols-obj.dec) = src(1:nRows,obj.dec+1:obj.dec:nCols);
                value(1:nRows,nCols-obj.dec+1) = src(1:nRows,1);
            elseif strcmp(obj.DirectionOfShift,'right') && strcmp(obj.UpperOrLower,'lower')
                value(1:nRows,1:obj.dec:nCols) = src(1:nRows,1:obj.dec:nCols);
                value(1:nRows,2*obj.dec:obj.dec:nCols) = src(1:nRows,obj.dec:obj.dec:nCols-obj.dec);
                value(1:nRows,obj.dec) = src(1:nRows,nCols);
            elseif strcmp(obj.DirectionOfShift,'left') && strcmp(obj.UpperOrLower,'lower')
                value(1:nRows,1:obj.dec:nCols) = src(1:nRows,1:obj.dec:nCols);
                value(1:nRows,obj.dec:obj.dec:nCols-obj.dec) = src(1:nRows,2*obj.dec:obj.dec:nCols);
                value(1:nRows,nCols) = src(1:nRows,obj.dec);
            else
                error('CoefficientShift:unexpectedError', ...
                    '%s', 'Unexpected logic error.')
            end
        end
    end
    
end

