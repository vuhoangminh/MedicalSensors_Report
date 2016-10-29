classdef ForwardGenLot2d < handle
    %FORWARDGENLOT2D Forward 2-D generalized lapped orthogoal transform
    %
    % NOTE:
    % The number of decomposition should be even.
    % The order should be even.
    %
    % SVN identifier:
    % $Id: ForwardGenLot2d.m 316 2012-04-24 07:07:44Z harashin $
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
        genlot
        subCoefs
        nRows
        nCols
    end
    
    methods
        
        % Constructor
        function this = ForwardGenLot2d(varargin)
            
%              iptchecknargin(0,2,nargin,mfilename);

             narginchk(0,2);

                
            if nargin == 0
                this.genlot = ForwardGenLot();
            elseif nargin > 0 && isa(varargin{1},'AbstLpPuFb1d')                
                if nargin == 1
                    this.genlot = ForwardGenLot(varargin{1});
                else 
                    this.genlot = ForwardGenLot(varargin{1},varargin{2});
                end
            else
                error('GenLot:ForwardGenLot2d:unexpectedError', ...
                    '%s', 'Unexpected logic error.')
            end
        end
        
        function this = forwardTransform(this,srcImg,varargin)
            
%             iptchecknargin(2,3,nargin,mfilename);

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
                        error('GenLot:ForwardGenLot2d:unexpectedError', ...
                            '%s', 'Unexpected logic error.')
                end
            end
            
            this.nRows = size(srcImg,1);
            this.nCols = size(srcImg,2);
            
            % Vertical transform
            this.genlot = forwardTransform(this.genlot,srcImg,sbtype);
            this.subCoefs = getCoefs(this.genlot);
            
            % Horizontal transform
            this.genlot = forwardTransform(this.genlot,this.subCoefs.',sbtype);
            this.subCoefs = getCoefs(this.genlot).';
        end
        
        function value = getCoefs(this)
            value = this.subCoefs;
        end
        
        function value = getSubbandCoefs(this)
            dec = getDec(this.genlot);
            value = cell(dec,dec);
            for iSubband = 1:dec
                for jSubband = 1:dec
                    value{iSubband,jSubband} = ...
                        this.subCoefs(iSubband:dec:end,jSubband:dec:end);
                end
            end
        end
        
    end
end