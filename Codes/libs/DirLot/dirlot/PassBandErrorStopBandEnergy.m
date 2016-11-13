classdef PassBandErrorStopBandEnergy < handle 
    %PASSBANDERRORSTOPBANDENERGY Passband error and stopband energy
    % This class evaluates the cost of given filterbanks in terms of the 
    % error energy between those filters and given ideal frequency 
    % specifications.
    %
    % SVN identifier:
    % $Id: PassBandErrorStopBandEnergy.m 184 2011-08-17 14:13:14Z sho $
    %
    % Requirements: MATLAB R2008a
    %
    % Copyright (c) 2008-2010, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %
    properties  (GetAccess = public, SetAccess = private)
        specs;
        nSpecs;
        filters;
    end
    
    methods
        function this = PassBandErrorStopBandEnergy(obj,varargin)
            this.specs = obj;
            this.nSpecs = length(this.specs);
            this.filters = cell(this.nSpecs,1);
        end
        
        function value = getCost(this,obj)
            value = 0.0;
            pgain = [];
            if isa(obj,'LpPuFb2d') || isa(obj,'AbstLpPuFb2d')
                for iSpec=1:this.nSpecs
                    this.filters{iSpec} = obj(iSpec);
                end
                pgain = sqrt(prod(getDec(obj)));
            else
                this.filters = obj;
            end
            for iSpec=1:this.nSpecs
                value = value + ...
                    getCostAt(this,this.filters{iSpec},iSpec,pgain);
            end
        end
        
        function value = getCostAt(this,filter,iSpec,pgain)
            nRows = size(this.specs{iSpec},1);
            nCols = size(this.specs{iSpec},2);
            ampres = fftshift(abs(fft2(filter,nRows,nCols)));
            if nargin < 4 || isempty(pgain) 
                targetValue = max(ampres(:));
            else
                targetValue = pgain;
            end
            if isempty(this.specs{iSpec})
                value = 0.0;
            else
                specPass = this.specs{iSpec}>0;
                specStop = this.specs{iSpec}<0;
                value = sum(sum(((targetValue-ampres).*specPass ...
                    + (ampres.*specStop)).^2));
            end
        end
        
        function value = getNumberOfSpecs(this)
            value = this.nSpecs;
        end
        
    end
    
end
