classdef AmplitudeErrorEnergy < handle 
    %AMPLITUDEERRORENERGY Amplitude error energy
    % This class evaluates the cost of given filterbanks in terms of the 
    % error energy between those filters and given ideal frequency 
    % specifications.
    %
    % SVN identifier:
    % $Id: AmplitudeErrorEnergy.m 243 2011-11-22 09:12:42Z sho $
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
    properties  (GetAccess = public, SetAccess = private)
        specs;
        nSpecs;
        filters;
    end
    
    methods
        function this = AmplitudeErrorEnergy(obj,varargin)
            this.specs = obj;
            this.nSpecs = length(this.specs);
            this.filters = cell(this.nSpecs,1);
        end
        
        function value = getCost(this,obj)
            value = 0.0;
            if isa(obj,'LpPuFb2d') || isa(obj,'AbstLpPuFb2d')
                for iSpec=1:this.nSpecs
                    this.filters{iSpec} = obj(iSpec);
                end
            else
                this.filters = obj;
            end
            for iSpec=1:this.nSpecs
                value = value + ...
                    getCostAt(this,this.filters{iSpec},iSpec);
            end
        end
        
        function value = getCostAt(this,filter,iSpec)
            if isempty(this.specs{iSpec})
                value = 0.0;
            else
                [nRows,nCols] = size(this.specs{iSpec});
                ampres = fftshift(abs(fft2(filter,nRows,nCols)));
                diff = ampres-this.specs{iSpec};
                value = diff(:).'*diff(:);
            end
        end
        
        function value = getNumberOfSpecs(this)
            value = this.nSpecs;
        end
        
    end
    
end
