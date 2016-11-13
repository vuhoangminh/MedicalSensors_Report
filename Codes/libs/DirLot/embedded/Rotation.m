classdef Rotation < matlab.System %#codegen
    %ROTATION Rotation class
    %
    % SVN identifier:
    % $Id: Rotation.m 384 2013-10-18 23:50:03Z sho $
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
        matrixW;
        matrixU;
        matrixNegI = -eye(2);
        dec = 2;
        %matrixR;
        %matrixRb = zeros(4);
        BorderProcess = 'circular';
        DirectionOfTermination = 'default';
    end
    
    properties (Logical)
        isTermination = false;
        isVertical = false;
        isHorizontal = false;
    end
    
    methods
        function obj = Rotation(varargin)
            setProperties(obj,nargin,varargin{:});
            %obj.matrixR = blkdiag(obj.matrixW,obj.matrixU);
            if strcmp(obj.BorderProcess,'termination')
                obj.isTermination = true;
                %obj.matrixRb = blkdiag(obj.matrixW,matrixNegI);
                if strcmp(obj.DirectionOfTermination,'vertical')
                    obj.isVertical = true;
                elseif strcmp(obj.DirectionOfTermination,'horizontal')
                    obj.isHorizontal = true;
                end
            end
        end
    end
    
    methods (Access = protected)
        function value = stepImpl(obj,src)
            [nRows, nCols] = size(src);
            value = zeros(nRows,nCols);
            for iCol = 1:obj.dec:nCols
                for iRow = 1:obj.dec:nRows
                    sIdx = iRow;
                    eIdx = iRow+obj.dec-1;
                    xu = src(sIdx:eIdx,iCol);
                    xl = src(sIdx:eIdx,iCol+1);
                    if obj.isTermination && obj.isVertical && iRow == 1
                        % upper
                        value(iRow:iRow+obj.dec-1,iCol) = ...
                            obj.matrixW*(xu(:));
                        % lower
                        value(iRow:iRow+obj.dec-1,iCol+1) = ...
                            obj.matrixNegI*(xl(:));
                    elseif obj.isTermination && obj.isHorizontal && iCol == 1
                        % upper
                        value(iRow:iRow+obj.dec-1,iCol) = ...
                            obj.matrixW*(xu(:));
                        % lower
                        value(iRow:iRow+obj.dec-1,iCol+1) = ...
                            obj.matrixNegI*(xl(:));
                    else
                        % upper
                        value(iRow:iRow+obj.dec-1,iCol) = ...
                            obj.matrixW*(xu(:));
                        % lower
                        value(iRow:iRow+obj.dec-1,iCol+1) = ...
                            obj.matrixU*(xl(:));
                    end
                end
            end
        end
    end
    
end

