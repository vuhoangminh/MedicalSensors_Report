classdef SubbandSpecification1d < handle
    %SUBBANDSPECIFICATION1D 1-D Subband frequency specification
    %
    % SVN identifier:
    % $Id: SubbandSpecification1d.m 232 2011-11-13 22:54:01Z sho $
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
    properties (Constant)
    end
    
    properties (SetAccess = 'private', GetAccess = 'private')
        dec = 4;
        transition = 0.0;
    end
    
    methods
        
        % Constructor
        function this = SubbandSpecification1d(varargin)
            if nargin > 0 && ~isempty(varargin{1})
                this.dec = varargin{1};
            end
        end

        function value = getSubbandLocation(this,nPoints,idx)
            if nargin < 3
                idx = 1;
            end
            if idx-1 < this.dec/2
                nidx = 2*idx-1;
            else
                nidx = 2*(idx-this.dec/2);
            end
            if nidx == 1 
                value = getRegionOfSupport(this,nPoints);
            elseif nidx == this.dec
                value = getRegionOfSupport(this,nPoints);
                shiftsize = floor(nPoints/2);
                value = circshift(value,[0 shiftsize]);
            else
                half1 = getHalfRegionOfSupport(this,nPoints,'positive');
                half2 = getHalfRegionOfSupport(this,nPoints,'negative');
                shiftsize = floor(nPoints/(2*this.dec)*(nidx-1));
                half1 = circshift(half1,[0 shiftsize]);
                half2 = circshift(half2,[0 -shiftsize]);
                value = half1 | half2;
            end
        end
        
        function value = getSubbandAssignment(this,nPoints)
            value = getSubbandLocation(this,nPoints,1);
            for idx = 2:this.dec
                value = value + ...
                    idx * getSubbandLocation(this,nPoints,idx);
            end
        end
        
        %{
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
        %}
        function value = getPassStopAssignment(this,nPoints,subband)
            if nargin < 3
                subband = 1;
            end
            passBand = getSubbandLocation(this,nPoints,subband);
            this.transition = -this.transition;
            stopBand = getSubbandLocation(this,nPoints,subband);
            this.transition = -this.transition;
            value = passBand + stopBand - 1;
        end
        
        function value = getRegionOfSupport(this,nPoints)
            scale = 1 - this.transition;
            rosspec = [-scale scale];
            value = calcRos(this,rosspec,nPoints);
        end
        
        function this = setTransition(this, transition)
            this.transition = transition;
        end
        
    end
    
    methods (Access = private)
        
        function value = getHalfRegionOfSupport(this,nPoints,region)
            scale = 1 - this.transition;
            if strcmp(region,'positive')
                rosleft = this.transition;
                rosright = scale;
            elseif strcmp(region,'negative')
                rosleft = -scale;
                rosright = -this.transition;
            end
            rosspec = [rosleft rosright];
            value = calcRos(this,rosspec,nPoints);
        end
        
        function value = calcRos(this,rosspec,nPoints)
            value = zeros(1,nPoints);
            for idx=1:nPoints
                w = (2.0*(idx-1)/nPoints-1.0); % from 0.0 to 2.0
                if w >= rosspec(1)/this.dec && w < rosspec(2)/this.dec
                    value(idx) = 1;
                end
            end
        end
        
    %{     
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
        %}
    end
end