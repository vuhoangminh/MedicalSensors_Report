classdef SubbandSpecification < handle
    %SUBBANDSPECIFICATION Subband frequency specification
    %
    % SVN identifier:
    % $Id: SubbandSpecification.m 243 2011-11-22 09:12:42Z sho $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2008-2011, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties (Constant)
    end
    
    properties (SetAccess = 'private', GetAccess = 'private')
        dec = [2 2];
        alpha = 0.0;
        direction = Direction.VERTICAL;
        transition = 0.0;
        matrixD;
        matrixE = eye(2);
        matrixInvV = eye(2);
        matrixV = eye(2);
        idxAssignment;
    end
    
    methods
        
        % Constructor
        function this = SubbandSpecification(varargin)
            if nargin > 0 && ~isempty(varargin{1})
                this.alpha = varargin{1};
            end
            if nargin > 1 && ~isempty(varargin{2})
                this.direction = varargin{2};
            end
            if nargin > 2 && ~isempty(varargin{3})
                this.dec = varargin{3};
            end
            this.matrixD = diag(this.dec);
            this = setDirection(this,this.direction);
            this.idxAssignment = getSubbandIndices(this);
        end
        
        function value = getSubbandLocation(this,nPoints,idx)
            if nargin < 3
                idx = 1;
            end
            modx = floor((idx-1)/this.dec(1));
            mody = mod((idx-1),this.dec(1));
            if (mody == 0 && modx == 0) || ...
                    (mody == this.dec(1)/2 && modx == 0) || ...
                    (mody == 0 && modx == this.dec(2)/2 ) || ...
                    (mody == this.dec(1)/2 && modx == this.dec(2)/2)
                value = getRegionOfSupport(this,nPoints);
                shiftsize = floor((nPoints./(this.dec)).*[mody modx]);
                value = circshift(value,shiftsize);
            else
                half1 = getHalfRegionOfSupport(this,nPoints,'positive',...
                    'opposit');
                half2 = getHalfRegionOfSupport(this,nPoints,'negative',...
                    'opposit');
                shiftsize = floor((nPoints./(this.dec)).*[mody modx]);
                half1 = circshift(half1,shiftsize);
                half2 = circshift(half2,-shiftsize);
                value = half1 | half2;
            end
        end
        
        function value = getSubbandLocationQuarterSplit(this,nPoints,idx)
            if nargin < 3
                idx = 1;
            end
            modx = floor((idx-1)/this.dec(1));
            mody = mod((idx-1),this.dec(1));
            if (mody == 0 && modx == 0) || ...
                    (mody == this.dec(1)/2 && modx == 0) || ...
                    (mody == 0 && modx == this.dec(2)/2 ) || ...
                    (mody == this.dec(1)/2 && modx == this.dec(2)/2)
                value = getRegionOfSupport(this,nPoints);
                shiftsize = floor((nPoints./(this.dec)).*[mody modx]);
                value = circshift(value,shiftsize);
            elseif (mody == 0 ) || (mody == this.dec(1)/2)
                half1 = getHalfRegionOfSupport(this,nPoints,'positive',...
                    Direction.VERTICAL);
                half2 = getHalfRegionOfSupport(this,nPoints,'negative',...
                    Direction.VERTICAL);
                shiftsize = floor((nPoints./(this.dec)).*[mody modx]);
                half1 = circshift(half1,shiftsize);
                half2 = circshift(half2,-shiftsize);
                value = half1 | half2;
            elseif (modx == 0 ) || (modx == this.dec(2)/2)
                half1 = getHalfRegionOfSupport(this,nPoints,'positive',...
                    Direction.HORIZONTAL);
                half2 = getHalfRegionOfSupport(this,nPoints,'negative',...
                    Direction.HORIZONTAL);
                shiftsize = floor((nPoints./(this.dec)).*[mody modx]);
                half1 = circshift(half1,shiftsize);
                half2 = circshift(half2,-shiftsize);
                value = half1 | half2;
            else
                qtl = getQuarterRegionOfSupport(this,nPoints,'tl');
                qtr = getQuarterRegionOfSupport(this,nPoints,'tr');
                qbl = getQuarterRegionOfSupport(this,nPoints,'bl');
                qbr = getQuarterRegionOfSupport(this,nPoints,'br');
                shiftsize = floor((nPoints./(this.dec)).*[mody modx]);
                qtl = circshift(qtl,[-1 -1].*shiftsize);
                qtr = circshift(qtr,[-1  1].*shiftsize);
                qbl = circshift(qbl,[ 1 -1].*shiftsize);
                qbr = circshift(qbr,[ 1  1].*shiftsize);
                value = qtl | qtr | qbl | qbr ;
            end
        end
        
        function value = getSubbandIndex(this,idx)
            value = this.idxAssignment(idx);
        end
        
        function value = getSubbandIndices(this)
            nSubbands = prod(this.dec);
            decY = this.dec(Direction.VERTICAL);
            eo = zeros(1,nSubbands);
            for idx = 1:nSubbands
                if idx <= round(nSubbands/2)
                    if mod(idx-1,decY)+1 > round(decY/2)
                        eo(idx) = 1;
                    end
                else
                    if mod(idx-1,decY)+1 <= round(decY/2)
                        eo(idx) = 1;
                    end
                end
            end
            aidx = find(eo==1);
            halen = length(aidx)/2;
            sbord = [ find(eo==0) aidx(halen+1:end) aidx(1:halen) ];
            value = zeros(1,nSubbands);
            for idx = 1:nSubbands
                value(idx) = find(sbord == idx);
            end
        end
        
        function value = getSubbandAssignment(this,nPoints)
            value = getSubbandLocation(this,nPoints,1);
            for idx = 2:this.dec(1)*this.dec(2)
                value = value + ...
                    idx * getSubbandLocation(this,nPoints,idx);
            end
        end
        
        function value = getSubbandAssignmentQuarterSplit(this,nPoints)
            value = getSubbandLocationQuarterSplit(this,nPoints,1);
            for idx = 2:this.dec(1)*this.dec(2)
                value = value + ...
                    idx * getSubbandLocationQuarterSplit(this,nPoints,idx);
            end
        end
        
        function [value,sbIdx] = ...
                getAmplitudeSpecification(this,nPoints,subband,nZeros)
            if nargin < 4
                nZeros = [2 2]; % # of zeros at pi, # of zeros at zero
            end
            if nargin < 3
                subband = 1;
            end
            a = @(x) SubbandSpecification.maxflatfreq(...
                x,nZeros(1),nZeros(2));

            if this.direction==Direction.VERTICAL
                b = @(x,y) 2*a(x).*a(-this.alpha*x+y); % d=y
            else
                b = @(x,y) 2*a(x-this.alpha*y).*a(y); % d=x
            end
            [x,y] = meshgrid(-pi:2*pi/nPoints(2):pi-2*pi/nPoints(2),...
                -pi:2*pi/nPoints(1):pi-2*pi/nPoints(1));
            if subband == 2
                value = b(x,y+pi);
            elseif subband == 3
                value = b(x+pi,y);
            elseif subband == 4
                value = b(x+pi,y+pi);
            else
                value = b(x,y);
            end
            if nargout > 1
                sbIdx = getSubbandIndex(this,subband);
            end
        end
        
        function [value,sbIdx] = ...
                getPassStopAssignment(this,nPoints,subband)
            if nargin < 3
                subband = 1;
            end
            passBand = getSubbandLocation(this,nPoints,subband);
            this.transition = -this.transition;
            stopBand = getSubbandLocation(this,nPoints,subband);
            this.transition = -this.transition;
            value = passBand + stopBand - 1;
            if nargout > 1
                sbIdx = getSubbandIndex(this,subband);
            end
        end
        
        function [value, sbIdx] = ...
                getPassStopAssignmentQuarterSplit(this,nPoints,subband)
            if nargin < 3
                subband = 1;
            end
            passBand = getSubbandLocationQuarterSplit(this,nPoints,subband);
            this.transition = -this.transition;
            stopBand = getSubbandLocationQuarterSplit(this,nPoints,subband);
            this.transition = -this.transition;
            value = passBand + stopBand - 1;
            if nargout > 1
                sbIdx = getSubbandIndex(this,subband);
            end
        end
        
        function value = getRegionOfSupport(this,nPoints)
            scale = 1 - this.transition;
            rosspec = [-scale scale -scale scale];
            value = calcRos(this,rosspec,nPoints);
        end
        
        function value = getDirection(this)
            value = this.direction;
        end
        
        function value = getAlpha(this)
            value = this.alpha;
        end
        
        function value = getMatrixV(this)
            value = this.matrixV;
        end
        
        function this = setDirection(this, direction)
            if direction ~= Direction.VERTICAL && ...
                    direction ~= Direction.HORIZONTAL
                id = 'DirLot:IllegalArgumentException';
                msg = sprintf(...
                    '%d: Direction must be either of 1 or 2.',...
                    direction);
                me = MException(id, msg);
                throw(me);
            else
                this.direction = direction;
                this = update(this);
            end
        end
        
        function this = update(this)
            if this.direction==Direction.VERTICAL
                this.matrixE(2,1) = - this.alpha;
                this.matrixE(1,2) = 0;
            else
                this.matrixE(1,2) = - this.alpha;
                this.matrixE(2,1) = 0;
            end
            this.matrixInvV = (this.matrixD * this.matrixE).';
            this.matrixV = inv(this.matrixInvV);
        end
        
        function this = setTransition(this, transition)
            this.transition = transition;
        end
        
        function this = setAlpha(this, alpha)
            this.alpha = alpha;
            this = update(this);
        end
        
    end
    
    methods (Access = private)
        
        function value = ...
                getHalfRegionOfSupport(this,nPoints,region,direction)
            scale = 1 - this.transition;
            if nargin < 4
                direction = this.direction;
            elseif strcmp(direction,'opposit') && ...
                    this.direction == Direction.HORIZONTAL
                direction = Direction.VERTICAL;
            elseif strcmp(direction,'opposit') && ...
                    this.direction == Direction.VERTICAL
                direction = Direction.HORIZONTAL;
            end
            if strcmp(region,'positive')
                if direction == Direction.VERTICAL
                    rostop = -scale;
                    rosbottom = scale;
                    rosleft = this.transition;
                    rosright = scale;
                else
                    rostop = this.transition;
                    rosbottom = scale;
                    rosleft = -scale;
                    rosright = scale;
                end
            elseif strcmp(region,'negative')
                if direction == Direction.VERTICAL
                    rostop = -scale;
                    rosbottom = scale;
                    rosleft = -scale;
                    rosright = -this.transition;
                else
                    rostop = -scale;
                    rosbottom = -this.transition;
                    rosleft = -scale;
                    rosright = scale;
                end
            end
            rosspec = [rostop rosbottom rosleft rosright];
            value = calcRos(this,rosspec,nPoints);
        end
        
        function value = getQuarterRegionOfSupport(this,nPoints,position)
            scale = 1 - this.transition;
            if strcmp(position,'tl')
                rostop = -scale;
                rosbottom = -this.transition;
                rosleft = -scale;
                rosright = -this.transition;
            elseif strcmp(position,'tr')
                rostop = -scale;
                rosbottom = -this.transition;
                rosleft = this.transition;
                rosright = scale;
            elseif strcmp(position,'bl')
                rostop = this.transition;
                rosbottom = scale;
                rosleft = -scale;
                rosright = -this.transition;
            elseif strcmp(position,'br')
                rostop = this.transition;
                rosbottom = scale;
                rosleft = this.transition;
                rosright = scale;
            else
                error('Invalid position');
            end
            rosspec = [rostop rosbottom rosleft rosright];
            value = calcRos(this,rosspec,nPoints);
        end
        
        function value = calcRos(this,rosspec,nPoints)
            value = zeros(nPoints);
            nRows = nPoints(1);
            nCols = nPoints(2);
            for iCol=1:nCols
                y(2) = (2.0*(iCol-1)/nCols-1.0); % from 0.0 to 2.0
                for iRow=1:nRows
                    y(1) = (2.0*(iRow-1)/nRows-1.0); % from 0.0 to 2.0
                    x = this.matrixInvV*y(:);
                    intX = 4*floor(x/4+0.5);
                    fracX = x - intX;
                    periodInY = mod(this.matrixV*intX,2);
                    if periodInY(1) == 0 && periodInY(2) == 0
                        if fracX(1) >= rosspec(1) && ...
                                fracX(1) < rosspec(2)  &&...
                                fracX(2) >= rosspec(3) && ...
                                fracX(2) < rosspec(4)
                            value(iRow,iCol) = 1;
                        end
                    end
                end
            end
        end
        
    end
    
    methods ( Access=private, Static=true)
        function value = maxflatfreq(w,K,L)
            %
            % w: angular frequency
            % K: # of zeros at pi
            % L: # of zeros at zero
            %
            % Reference: P.P. Vaidyanathan, "On Maximally-Flat Linear-
            % Phase FIR Filters," IEEE Trans. on CAS, Vol.21, No.9, 
            % pp.830-832, Sep. 1984
            %
            value = 0.0;
            for idx=1:L
                n = idx-1;
                value = value + nchoosek(K-1+n,n)*sin(w/2).^(2*n);
            end
            value = cos(w/2).^(2*K).*value;
        end
    end
end