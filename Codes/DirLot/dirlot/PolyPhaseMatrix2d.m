classdef PolyPhaseMatrix2d < handle
    %POLYPHASEMATRIX2D 2-D polyphase matrix
    %
    % SVN identifier:
    % $Id: PolyPhaseMatrix2d.m 184 2011-08-17 14:13:14Z sho $
    %
    % Requirements: MATLAB R2008a
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
    
    properties (GetAccess = private, SetAccess = private)
        coef = [];
    end
    
    methods
        function this = PolyPhaseMatrix2d(varargin)
            if nargin == 1
                obj = varargin{1};
                if isa(obj,'PolyPhaseMatrix2d')
                    this.coef = obj.coef;
                else
                    this.coef = obj;
                end
            end
        end
        
        function value = double(this)
            value = double(this.coef);
        end
        
        function value = char(this)
            nRowsPhs = size(this.coef,1);
            nColsPhs = size(this.coef,2);
            value = ['[' 10]; % 10 -> \n
            if all(this.coef(:) == 0)
                value = '0';
            else
                for iRowPhs = 1:nRowsPhs
                    strrow = 9; % 9 -> \t
                    for iColPhs = 1:nColsPhs
                        coefMatrix = permute(...
                            this.coef(iRowPhs,iColPhs,:,:),[3 4 1 2]);
                        nOrdsY = size(coefMatrix,1) - 1;
                        nOrdsX = size(coefMatrix,2) - 1;
                        strelm = '0';
                        for iOrdX = 0:nOrdsX
                            for iOrdY = 0:nOrdsY
                                elm = coefMatrix(iOrdY+1,iOrdX+1);
                                if elm ~= 0
                                    if strelm == '0'
                                        strelm = [];
                                    end
                                    if ~isempty(strelm)
                                        if elm > 0
                                            strelm = [strelm ' + ' ];
                                        else
                                            strelm = [strelm ' - ' ];
                                            elm = -elm;
                                        end
                                    end
                                    if elm ~= 1 || (iOrdX == 0 && iOrdY == 0)
                                        strelm = [strelm num2str(elm)];
                                        if iOrdX > 0 || iOrdY > 0
                                            strelm = [strelm '*'];
                                        end
                                    end
                                    if iOrdY >=1
                                        strelm = [strelm 'y^(-' int2str(iOrdY) ')'];
                                        if iOrdX >=1
                                            strelm = [strelm '*'];
                                        end
                                    end
                                    if iOrdX >=1
                                        strelm = [strelm 'x^(-' int2str(iOrdX) ')'];
                                    end
                                end % for strelm ~= 0
                            end % for iOrdY
                        end % for iOrdX
                        strrow = [strrow strelm];
                        if iColPhs ~= nColsPhs
                            strrow = [strrow ',' 9]; % 9 -> \t
                        end
                    end % for iColPhs
                    if iRowPhs == nRowsPhs
                        value = [value strrow 10 ']']; % 10 -> \n
                    else
                        value = [value strrow ';' 10]; % 10 -> \n
                    end
                end % for iRowPhs
            end
        end
        
        function disp(this)
            disp([char(this) 10]);
        end
        
        function value = subsref(this,sub)
            % Implement a special subscripted assignment
            switch sub.type
                case '()'
                    r = sub.subs{1};
                    c = sub.subs{2};
                    value = permute(this.coef(r,c,:,:),[3 4 1 2]);
                    %                 case '.'
                    %                     switch sub.subs
                    %                         case 'coef'
                    %                             value = this.coef;
                    %                         otherwise
                    %                             error(['''' sub.subs '''' ' is not a property'])
                    %                     end
                otherwise
                    error('Specify polyphase index for r,c as obj(r,c)')
            end
        end % subsref
        
        function value = plus(this,another)
            % Plus Implement obj1 + obj2 for PolyPhaseMatrix2d
            coef1 = double(this);
            coef2 = double(another);
            if size(coef1,1) ~= size(coef2,1) || size(coef1,2) ~= size(coef2,2)
                %                if (size(coef1,1) == 1 && size(coef1,2) == 1) ||...
                %                        (size(coef2,1) == 1 && size(coef2,2) == 1)
                if ( ~any(size(coef1)-1) || ~all(size(coef2)-1) )
                    value = PolyPhaseMatrix2d(coef1+coef2);
                else
                    error('Matrix dimensions must be the same as each other.');
                end
            else
                coef3 = zeros( max( [size(coef1) ; size(coef2)] ) );
                for iCol = 1:size(coef1,4)
                    for iRow = 1:size(coef1,3)
                        coef3(:,:,iRow,iCol) = coef1(:,:,iRow,iCol);
                    end
                end
                for iCol = 1:size(coef2,4)
                    for iRow = 1:size(coef2,3)
                        coef3(:,:,iRow,iCol) = ...
                            coef3(:,:,iRow,iCol) + coef2(:,:,iRow,iCol);
                    end
                end
                value = PolyPhaseMatrix2d(coef3);
            end
        end % plus
        
        function value = minus(this,another)
            value = plus(this,-double(another));
        end % minus
        
        function value = mtimes(this,another)
            coef1 = double(this);
            coef2 = double(another);
            if size(coef1,2) ~= size(coef2,1)
                if ( ~any(size(coef1)-1) || ~all(size(coef2)-1) )
                    coef3 = coef1 * coef2;
                else
                    error('Inner dimensions must be the same as each other.');
                end
            else
                nDims = size(coef1,2);
                nRows = size(coef1,1);
                nCols = size(coef2,2);
                nTapY = size(coef1,3)+size(coef2,3)-1;
                nTapX = size(coef1,4)+size(coef2,4)-1;
                pcoef1 = permute(coef1,[3 4 1 2]);
                pcoef2 = permute(coef2,[3 4 1 2]);
                pcoef3 = zeros(nTapY,nTapX,nRows,nCols);
                for iCol = 1:nCols
                    for iRow = 1:nRows
                        array3 = zeros(nTapY,nTapX);
                        for iDim = 1:nDims
                            array1 = pcoef1(:,:,iRow,iDim);
                            array2 = pcoef2(:,:,iDim,iCol);
                            array3 = array3 + conv2(array1,array2);
                            %pcoef3(1:nTapY,1:nTapX,iRow,iCol) = ...
                            %   pcoef3(1:nTapY,1:nTapX,iRow,iCol) + ...
                            %  conv2(array1,array2);conv2(array1,array2);
                        end
                        pcoef3(1:nTapY,1:nTapX,iRow,iCol) = array3;
                    end
                end
                coef3 = permute(pcoef3,[3 4 1 2]);
            end
            value = PolyPhaseMatrix2d(coef3);
        end
        
        function value = ctranspose(this)
            coefTmp = double(this);
            coefTmp = permute(coefTmp,[2 1 3 4]);
            coefTmp = flipdim(coefTmp,3);
            coefTmp = flipdim(coefTmp,4);
            coefTmp = conj(coefTmp);
            value = PolyPhaseMatrix2d(coefTmp);
        end
        
        function value = transpose(this)
            coefTmp = double(this);
            coefTmp = permute(coefTmp,[2 1 3 4]);
            coefTmp = flipdim(coefTmp,3);
            coefTmp = flipdim(coefTmp,4);
            value = PolyPhaseMatrix2d(coefTmp);
        end
        
        function value = upsample(this,ufactors,direction)
            value = this;
            ucoef = this.coef;
            for iDirection = direction
                coefTmp = double(value);
                ufactor = ufactors(direction==iDirection);
                if (iDirection == Direction.VERTICAL) && ...
                        size(this.coef,3) ~= 1
                    uLength = size(coefTmp,3);
                    uLength = ufactor*(uLength - 1) + 1;
                    usize = size(coefTmp);
                    usize(3) = uLength;
                    ucoef = zeros(usize);
                    ucoef(:,:,1:ufactor:end,:) = coefTmp;
                elseif iDirection == Direction.HORIZONTAL && ...
                        size(this.coef,4) ~= 1
                    uLength = size(coefTmp,4);
                    uLength = ufactor*(uLength - 1) + 1;
                    usize = size(coefTmp);
                    usize(4) = uLength;
                    ucoef = zeros(usize);
                    ucoef(:,:,:,1:ufactor:end) = coefTmp;
                end
                value = PolyPhaseMatrix2d(ucoef);
            end
        end
    end
end