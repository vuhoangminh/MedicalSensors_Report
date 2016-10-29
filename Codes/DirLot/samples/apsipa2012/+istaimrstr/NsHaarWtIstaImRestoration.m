classdef NsHaarWtIstaImRestoration < istaimrstr.AbstIstaImRestoration
    %NSHAARWTISTAIMAGERESTORATION
    %
    % SVN identifier:
    % $Id: NsHaarWtIstaImRestoration.m 303 2012-03-11 01:39:03Z sho $
    %
    % Requirements: MATLAB R2011b
    %
    % Copyright (c) 2012, Shogo MURAMATSU
    %
    % All rights reserved.
    %
    % Contact address: Shogo MURAMATSU,
    %                Faculty of Engineering, Niigata University,
    %                8050 2-no-cho Ikarashi, Nishi-ku,
    %                Niigata, 950-2181, JAPAN
    %   
    properties
        nlevels;
    end
    
    methods
        function this = NsHaarWtIstaImRestoration(varargin)
            this = this@istaimrstr.AbstIstaImRestoration(varargin{:});
            if ~isa(varargin{1},'istaimrstr.NsHaarWtIstaImRestoration')
                this.nTrx = 1;
                if nargin < 3
                    this.nlevels = 1;
                else
                    this.nlevels = varargin{3};
                end
            end
        end
        
        function obj = clone(this)
            obj = istaimrstr.NsHaarWtIstaImRestoration(...
                this.degradation,...
                this.lambda,...
                this.nlevels...
                );
            obj = setSmax(obj,this.smax);
            obj = setEps0(obj,this.eps0);
            obj = setReference(obj,this.ref);            
            obj = setMonitoring(obj,this.ismonitoring);
            obj = setEvaluation(obj,this.isevaluation);
            obj = setFista(obj,this.isfista);            
        end
        
        function outputcf = dec2(this,inputim,~)
            outputcf = nshaarwtdec2(inputim,this.nlevels);
        end
        
        function outputim = rec2(this,inputcf,~)
            outputim = nshaarwtrec2(inputcf,this.valueS{1});
        end

        
        function numYk = getNumYk(this,nDim)
            numYk = (3*this.nlevels+1)*prod(nDim);
        end
        
        function str = getString(this)
            this.string = sprintf('nshaarwt_lmd%6.4f_lv%d_%s',...
                this.lambda,this.nlevels,getString(this.degradation));
            str = this.string;
        end

        function value = getRedundancy(this)
            value = this.nlevels*3+1;
        end
        
        function valueS = getValueS(this,nDim,~)
            [~,valueS] = nshaarwtdec2(zeros(nDim),this.nlevels);
        end
        
    end
                
    methods (Static = true)
        
        function str = getFname4lc(nDim,nlv,strdgrd)
            str = sprintf('./lipshitzconst/lc_%dx%d_nshaarwt_lv%d_%s.mat',...
                nDim(1),nDim(2),nlv,strdgrd);
        end

    end        

end
