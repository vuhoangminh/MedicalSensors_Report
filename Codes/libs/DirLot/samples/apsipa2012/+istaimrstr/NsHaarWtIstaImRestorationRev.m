classdef NsHaarWtIstaImRestorationRev < istaimrstr.AbstIstaImRestoration
    %NSHAARWTISTAIMAGERESTORATIONREV
    %
    % SVN identifier:
    % $Id: NsHaarWtIstaImRestorationRev.m 383 2013-10-07 04:55:32Z sho $
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
        function this = NsHaarWtIstaImRestorationRev(varargin)
             this = this@istaimrstr.AbstIstaImRestoration(varargin{:});
            if ~isa(varargin{1},'istaimrstr.NsHaarWtIstaImRestorationRev')
                this.nTrx = 1;
                if nargin < 3
                    this.nlevels = 1;
                else
                    this.nlevels = varargin{3};
                end
            end
        end
        
        function obj = clone(this)
            obj = istaimrstr.NsHaarWtIstaImRestorationRev(...
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
            outputcf = nshaarwtdec2_rev(inputim,this.nlevels);
        end
        
        function outputim = rec2(this,inputcf,~)
            outputim = nshaarwtrec2_rev(inputcf,this.valueS{1});
        end

        
        function numYk = getNumYk(this,nDim)
            numYk = (3*this.nlevels+1)*prod(nDim);
        end
        
        function str = getString(this)
            this.string = sprintf('nshaarwt_rev_lmd%6.4f_lv%d_%s',...
                this.lambda,this.nlevels,getString(this.degradation));
            str = this.string;
        end

        function value = getRedundancy(this)
            value = this.nlevels*3+1;
        end
        
        function valueS = getValueS(this,nDim,~)
            [~,valueS] = nshaarwtdec2_rev(zeros(nDim),this.nlevels);
        end
        
    end
                
    methods (Static = true)
        
        function str = getFname4lc(nDim,nlv,strdgrd)
            str = sprintf('./lipshitzconst/lc_%dx%d_nshaarwt_rev_lv%d_%s.mat',...
                nDim(1),nDim(2),nlv,strdgrd);
        end

    end        

end
