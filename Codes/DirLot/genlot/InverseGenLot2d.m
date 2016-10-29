classdef InverseGenLot2d < handle
    %INVERSEGENLOT2D Inverse 2-D generalized lapped orthogoal transform
    %
    % NOTE:
    % The number of decomposition should be even.
    % The order should be even.
    %
    % SVN identifier:
    % $Id: InverseGenLot2d.m 316 2012-04-24 07:07:44Z harashin $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2011, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    %
    properties (GetAccess = private, SetAccess = private)
        igenlot
        recImg
        nRows
        nCols
    end
    
    methods
        
        % Constructor
        function this = InverseGenLot2d(varargin)
            
            %iptchecknargin(0,2,nargin,mfilename);
            narginchk(0,2);
                
            if nargin == 0
                this.igenlot = InverseGenLot();
            elseif nargin > 0 && isa(varargin{1},'AbstLpPuFb1d')                
                if nargin == 1
                    this.igenlot = InverseGenLot(varargin{1});
                else 
                    this.igenlot = InverseGenLot(varargin{1},varargin{2});
                end
            else
                error('GenLot:InverseGenLot2d:unexpectedError', ...
                    '%s', 'Unexpected logic error.')
            end
        end
        
        function this = inverseTransform(this,subCoef,varargin)
            
            %iptchecknargin(2,3,nargin,mfilename);
            narginchk(2,3);
            sbtype = 'default';
            if nargin > 2
                validStrings = { 'natural' 'default' };
%                 string = iptcheckstrs(varargin{1},validStrings,...
%                     mfilename,'SUBBAND ORDER',3);
                string = validatestring(varargin{1},validStrings,...
                    mfilename,'SUBBAND ORDER',3);
                switch string
                    case 'natural'
                        sbtype = 'natural';
                    case 'default'
                        sbtype = 'default';
                    otherwise
                        error('GenLot:InverseGenLot2d:unexpectedError', ...
                            '%s', 'Unexpected logic error.')
                end
            end
            if iscell(subCoef)
                dec = getDec(this.igenlot);
                subCoefInBlk = 0*cell2mat(subCoef);
                for iSubband = 1:dec
                    for jSubband = 1:dec
                        subCoefInBlk(iSubband:dec:end,jSubband:dec:end) = ...
                            subCoef{iSubband,jSubband};
                    end
                end
               subCoef = subCoefInBlk; 
            end
            
            this.nRows = size(subCoef,1);
            this.nCols = size(subCoef,2);
            
            % Horizontal transform
            this.igenlot = inverseTransform(this.igenlot,subCoef.',sbtype);
            this.recImg = getImage(this.igenlot).';
            
            % Vertical transform
            this.igenlot = inverseTransform(this.igenlot,this.recImg,sbtype);
            this.recImg = getImage(this.igenlot);
        end
            
        function value = getImage(this)
            value = this.recImg;
        end
    end
end