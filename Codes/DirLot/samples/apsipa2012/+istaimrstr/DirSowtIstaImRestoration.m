classdef DirSowtIstaImRestoration < istaimrstr.AbstIstaImRestoration
    %DIRSOWTISTAIMAGERESTORATION
    %
    % SVN identifier:
    % $Id: DirSowtIstaImRestoration.m 340 2012-05-25 06:35:11Z sho $
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
        isbayes;
        sdir;
        fwdtrx;
        invtrx;
        isminord;
    end
    
    methods
        function this = DirSowtIstaImRestoration(varargin)
            this = this@istaimrstr.AbstIstaImRestoration(varargin{:});
            if ~isa(varargin{1},'istaimrstr.DirSowtIstaImRestoration')
                if nargin < 3
                    this.nlevels = 1;
                else
                    this.nlevels = varargin{3};
                end
                if nargin < 4
                    this.nTrx = 1;
                else
                    this.nTrx = varargin{4};
                end
                if nargin < 5
                    this.isminord = false;
                else
                    this.isminord = varargin{5};
                end
                if nargin < 6
                    this.isbayes = false;
                else
                    this.isbayes = varargin{6};
                end
            end
            this.sdir = '../icassp2012/filters/data128x128ampk3l3/ga/';
            [this.fwdtrx,this.invtrx] = gendic(this);
        end
        
        function obj = clone(this)
            degradation_ = clone(this.degradation);
            obj = istaimrstr.DirSowtIstaImRestoration(...
                degradation_,...
                this.lambda,...
                this.nlevels,...
                this.nTrx,...
                this.isminord,...
                this.isbayes...
                );
            obj = setSmax(obj,this.smax);
            obj = setEps0(obj,this.eps0);
            obj = setReference(obj,this.ref);            
            obj = setMonitoring(obj,this.ismonitoring);
            obj = setEvaluation(obj,this.isevaluation);
            obj = setFista(obj,this.isfista);            
        end
        
        function outputcf = dec2(this,inputim,ktrx)
            outputcf = ...
                wavedec2(this.fwdtrx{ktrx},inputim,this.nlevels);
        end
        
        function outputim = rec2(this,inputcf,ktrx)
            outputim = ...
                waverec2(this.invtrx{ktrx},inputcf,this.valueS{ktrx});
        end
        
        % Generate dictionary
        function [fwdtrx,invtrx] = gendic(this)
            idx = 1;
            fwdtrx = cell(this.nTrx,1);
            invtrx = cell(this.nTrx,1);
            %
            if ~this.isminord
                if this.nTrx == 19
                    fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vm2.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir2Vmd000.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp5.7Dir2Vmd010.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp2.7Dir2Vmd020.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir2Vmd030.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp1.2Dir2Vmd040.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp1.2Dir1Vmd050.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir1Vmd060.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp2.7Dir1Vmd070.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp5.7Dir1Vmd080.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vmd090.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-5.7Dir1Vmd100.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-2.7Dir1Vmd110.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir1Vmd120.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-1.2Dir1Vmd130.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-1.2Dir2Vmd140.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir2Vmd150.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-2.7Dir2Vmd160.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-5.7Dir2Vmd170.00.mat';
                elseif this.nTrx == 7
                    fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vm2.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir2Vmd000.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir2Vmd030.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir1Vmd060.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vmd090.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir1Vmd120.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir2Vmd150.00.mat';
                elseif this.nTrx == 5
                    fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vm2.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir2Vmd030.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir1Vmd060.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir1Vmd120.00.mat'; idx = idx+1;
                    fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir2Vmd150.00.mat';                    
                elseif this.nTrx == 1
                    fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vm2.mat';
                else
                    error('Invalid number of transforms');
                end
                %
                for idx = 1:this.nTrx
                    S = load([ this.sdir fname{idx} ],'lppufb');
                    nsgenlot = S.lppufb;
                    if this.ismonitoring
                        figure
                        dispBasisImages(nsgenlot);
                        drawnow
                    end
                    fwdtrx{idx} = ForwardDirLot(nsgenlot,'termination');
                    invtrx{idx} = InverseDirLot(nsgenlot,'termination');
                end
            else
                nsgenlot = cell(1,this.nTrx);
                step = (180/(this.nTrx-1));
                phiset = 0:step:180-step;
                for idx = 1:this.nTrx
                    if idx == 1
                        nsgenlot{idx} = fcn_eznsgenlotcvm2();
                    else
                        phiset = phiset*pi/180;
                        nsgenlot{idx} = fcn_ezdirlottvm(phiset(idx-1));
                    end
                    if this.ismonitoring
                        figure
                        dispBasisImages(nsgenlot{idx});
                        drawnow
                    end                    
                    fwdtrx{idx} = ForwardDirLot(nsgenlot{idx},'termination');
                    invtrx{idx} = InverseDirLot(nsgenlot{idx},'termination');
                end
            end
            
        end
        
        function numYk = getNumYk(this,nDim)
            numYk = prod(nDim);
        end
        
        function str = getString(this)
            this.string = sprintf('dirsowt_lmd%6.4f_lv%d_n%d_mo%d_%s',...
                this.lambda,this.nlevels,this.nTrx,this.isminord,...
                getString(this.degradation));            
            str = this.string;
        end
         
        function value = getRedundancy(this)
            value = this.nTrx;
        end
        
        function valueS = getValueS(this,nDim,ktrx)
            [~,valueS] = wavedec2(this.fwdtrx{ktrx},...
                zeros(nDim),this.nlevels);
        end
    end
    
    methods (Static = true)
        
        function str = getFname4w(nDim,nlv,nTrx,strdgrd,isminord)
            if isminord
                str = sprintf('./lipshitzconst/lcw_%dx%d_dirsowt_lv%d_n%d_%s_mo.mat',...
                    nDim(1),nDim(2),nlv,nTrx,strdgrd);
            else
                str = sprintf('./lipshitzconst/lc_%dx%d_dirsowt_lv%d_n%d_%s.mat',...
                    nDim(1),nDim(2),nlv,nTrx,strdgrd);
            end
        end        

    end        

end
