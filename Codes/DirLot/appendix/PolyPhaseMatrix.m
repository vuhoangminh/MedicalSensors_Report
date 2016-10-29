classdef PolyPhaseMatrix < handle
    %POLYPHASEMATRIX Polyphae matrix
    %
    % SVN identifier:
    % $Id: PolyPhaseMatrix.m 184 2011-08-17 14:13:14Z sho $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2010, Shogo MURAMATSU
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
        function this = PolyPhaseMatrix(varargin)
            if nargin == 1
                obj = varargin{1};
                if isa(obj,'PolyPhaseMatrix')
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
                            this.coef(iRowPhs,iColPhs,:,:),[3 1 2]);
                        nOrds = size(coefMatrix,1) - 1;
                        strelm = '0';
                        for iOrd = 0:nOrds
                            elm = coefMatrix(iOrd+1);
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
                                if elm ~= 1 || (iOrd == 0 )
                                    strelm = [strelm num2str(elm)];
                                    if iOrd > 0
                                        strelm = [strelm '*'];
                                    end
                                end
                                if iOrd >=1
                                    strelm = [strelm 'z^(-' int2str(iOrd) ')'];
                                end
                            end % for strelm ~= 0
                        end % for iOrd
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
                    value = permute(this.coef(r,c,:),[2 3 1]);
                otherwise
                    error('Specify polyphase index for r,c as obj(r,c)')
            end
        end % subsref
        
        function value = plus(this,another)
            % Plus Implement obj1 + obj2 for PolyPhaseMatrix
            coef1 = double(this);
            coef2 = double(another);
            if size(coef1,1) ~= size(coef2,1) || size(coef1,2) ~= size(coef2,2)
                %                if (size(coef1,1) == 1 && size(coef1,2) == 1) ||...
                %                        (size(coef2,1) == 1 && size(coef2,2) == 1)
                if ( ~any(size(coef1)-1) || ~all(size(coef2)-1) )
                    value = PolyPhaseMatrix(coef1+coef2);
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
                value = PolyPhaseMatrix(coef3);
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
                nTap = size(coef1,3)+size(coef2,3)-1;
                pcoef1 = permute(coef1,[3 1 2]);
                pcoef2 = permute(coef2,[3 1 2]);
                pcoef3 = zeros(nTap,nRows,nCols);
                for iCol = 1:nCols
                    for iRow = 1:nRows
                        seq3 = zeros(nTap,1);
                        for iDim = 1:nDims
                            seq1 = pcoef1(:,iRow,iDim);
                            seq2 = pcoef2(:,iDim,iCol);
                            seq3 = seq3 + conv(seq1(:),seq2(:));
                        end
                        pcoef3(1:nTap,iRow,iCol) = seq3;
                    end
                end
                coef3 = permute(pcoef3,[2 3 1]);
            end
            value = PolyPhaseMatrix(coef3);
        end
        
        function value = ctranspose(this)
            coefTmp = double(this);
            coefTmp = permute(coefTmp,[2 1 3]);
            coefTmp = flipdim(coefTmp,3);
            coefTmp = conj(coefTmp);
            value = PolyPhaseMatrix(coefTmp);
        end
        
        function value = transpose(this)
            coefTmp = double(this);
            coefTmp = permute(coefTmp,[2 1 3 4]);
            coefTmp = flipdim(coefTmp,3);
            coefTmp = flipdim(coefTmp,4);
            value = PolyPhaseMatrix(coefTmp);
        end
        
        function value = upsample(this,ufactor)
            coefTmp = double(this);
            if size(this.coef,3) ~= 1
                uLength = size(coefTmp,3);
                uLength = ufactor*(uLength - 1) + 1;
                usize = size(coefTmp);
                usize(3) = uLength;
                ucoef = zeros(usize);
                ucoef(:,:,1:ufactor:end) = coefTmp;
            else
                ucoef = coefTmp;
            end
            value = PolyPhaseMatrix(ucoef);
        end
    end
end