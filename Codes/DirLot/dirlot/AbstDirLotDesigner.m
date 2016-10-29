classdef AbstDirLotDesigner < handle
    %ABSTDIRLOTDESIGNER Abstract class of DirLOT designer
    %
    % SVN identifier:
    % $Id: AbstDirLotDesigner.m 243 2011-11-22 09:12:42Z sho $
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
    %
    properties (GetAccess = public, SetAccess = protected)
        lppufb; % handle class
        spec; % handle class
    end
    
    properties (GetAccess = protected, SetAccess = protected)
        nDecs;
        nOrds;
        sizeAngles;
        sizeMus;
        exitflag;
        optfcn;
        isConstrain;
    end
    
    methods (Abstract = true)
        value = getCost(this,lppufb_)
    end
    
    methods
        function this = AbstDirLotDesigner(varargin)
            
            if nargin < 1
                this.nDecs = [2 2];
            else
                this.nDecs = varargin{1};
            end
            if nargin < 2
                this.nOrds = [0 0];
            else
                this.nOrds = varargin{2};
            end
            %
            if nargin < 4
                vm = false;
            else
                vm = varargin{4};
            end
            if ~ischar(vm) && vm < 2
                this.isConstrain = false;
            else
                this.isConstrain = true;
            end
            if nargin < 5
                if this.isConstrain
                    this.optfcn = @fmincon;
                else
                    this.optfcn = @fminunc;
                end
            else
                this.optfcn = varargin{5};
            end
            
            this.lppufb = LpPuFb2dFactory.createLpPuFb2d(vm,...
                this.nDecs, this.nOrds, 0, 1);
            angles_ = getAngles(this.lppufb);
            this.sizeAngles = size(angles_);
            mus_ = getMus(this.lppufb);
            this.sizeMus = size(mus_);
        end
        
        function this = run(this,options,isOptMus)
            if nargin < 3
                isOptMus = false;
            end
            if isOptMus
                nMus = prod(this.sizeMus); % Number of angles
                optionsMus = ...
                    gaoptimset(options,'PopulationType','bitstring');
                optionsMus = ...
                    gaoptimset(optionsMus,'Generations',10*nMus);
                optionsMus = ...
                    gaoptimset(optionsMus,'StallGenLimit',9*nMus);
                optMus = ...
                    ga(@(x)costFcnMus(this,x), nMus,...
                    [],[],[],[],[],[],[],optionsMus);
                this = setMus(this,2*(reshape(optMus,this.sizeMus))-1);
                angles_ = getAngles(this);
                options = ...
                    gaoptimset(options,'PopInitRange',...
                    [angles_(:)-pi angles_(:)+pi].');
            end
            if strcmp(char(this.optfcn),'ga')
                initAngs = prod(this.sizeAngles); % Number of angle
                if this.isConstrain
                    arguments{7} = @(x)constrain(this,x);
                    options = setHybridFmincon_(this,options);
                else
                    options = setHybridFminunc_(this,options);
                end
                arguments{8} = options;
            else
                initAngs = getAngles(this.lppufb);
                if this.isConstrain
                    arguments{7} = @(x)constrain(this,x);
                    arguments{8} = options;
                else
                    arguments{1} = options;
                end
            end
            [optAngs, fval, exflag] = ...
                this.optfcn(@(x)costFcn(this,x), initAngs,...
                arguments{:}); %#ok fval can be replaced by ~.
            this = setAngles(this,reshape(optAngs,this.sizeAngles));
            this.exitflag = exflag;
        end
        
        function value = double(this)
            value = double(this.lppufb);
        end
        
        function value = getExitFlag(this)
            value = this.exitflag;
        end
        
        function value = getAngles(this)
            value = getAngles(this.lppufb);
        end
        
        function value = getMus(this)
            value = getMus(this.lppufb);
        end
        
        function value = getOptFcn(this)
            value = this.optfcn;
        end
        
        function value = getLpPuFb2d(this)
            %value = LpPuFb2d(this.lppufb);
            value = this.lppufb;
        end
        
        function value = getSpec(this)
            value = this.spec;
        end
        
        % TODO: function this = setLpPuFb2d(this,lppufb_)
        
        function this = setAngles(this,angles)
            this.lppufb = setAngles(this.lppufb, angles);
        end
        
        function this = setMus(this,mus)
            this.lppufb = setMus(this.lppufb, mus);
        end
        
        function this = setSigns4Lambda(this,sd)
            this.lppufb = setSigns4Lambda(this.lppufb, sd);
        end
        
        function value = costFcn(this, angles)
            %clone = LpPuFb2d(this.lppufb);
            clone = LpPuFb2dFactory.createLpPuFb2d(this.lppufb);
            angles = reshape(angles,this.sizeAngles);
            clone = setAngles(clone,angles);
            value = getCost(this,clone);
            this.lppufb = clone;
        end
        
        function value = costFcnMus(this, mus)
            %clone = LpPuFb2d(this.lppufb);
            clone = LpPuFb2dFactory.createLpPuFb2d(this.lppufb);
            mus = 2*(reshape(mus,this.sizeMus))-1;
            clone = setMus(clone, mus);
            value = getCost(this,clone);
            this.lppufb = clone;
        end
        
        function [c,ce] = constrain(this, angles)
            %clone = LpPuFb2d(this.lppufb);
            clone = LpPuFb2dFactory.createLpPuFb2d(this.lppufb);
            angles = reshape(angles,this.sizeAngles);
            clone = setAngles(clone, angles);
            %type = getType(clone);
            type = class(clone);
            if strcmp(type,'LpPuFb2dVm2') %isVm2Const(clone)
                c(1) = getLengthX3y(clone)-2;
                c(2) = getLengthX3x(clone)-2;
                c(3) = getLambdaXueq(clone);
                c(4) = getLambdaYueq(clone);
                ce = [];
            elseif strcmp(type,'LpPuFb2dTvm') %isDirVmConst(clone)
                c(1) = getLengthX3(clone)-2;
                c(2) = getLambdaUeq(clone);
                ce = [];
            else
                c = [];
                ce = [];
            end
            this.lppufb = clone;
        end
        
    end
    
    methods (Access = protected)
        
        function value = setHybridFmincon_(this,options)
            hybridopts = optimset(@fmincon);
            if strcmp(gaoptimget(options,'UseParallel'),'always')
                hybridopts = optimset(hybridopts,...
                    'UseParallel','always');
                hybridopts = optimset(hybridopts,...
                    'GradObj','off');
                hybridopts = optimset(hybridopts,...
                    'GradConstr','off');
                %hybridopts = optimset(hybridopts,...
                %    'TolCon',0);
            end
            if ~isempty(gaoptimget(options,'PlotFcn'))
                hybridopts = optimset(hybridopts,...
                    'PlotFcns',@optimplotfval);
            end
            hybridopts = optimset(hybridopts,'Display',...
                gaoptimget(options,'Display'));
            hybridopts = optimset(hybridopts,'MaxFunEvals',...
                2000*prod(this.sizeAngles));
            hybridopts = optimset(hybridopts,'MaxIter',...
                800);
            value = ...
                gaoptimset(options,'HybridFcn',...
                {@fmincon,hybridopts});
        end
        
        function value = setHybridFminunc_(this,options)
            hybridopts = optimset(@fminunc);
            if ~isempty(gaoptimget(options,'PlotFcn'))
                hybridopts = optimset(hybridopts,...
                    'PlotFcns',@optimplotfval);
            end
            hybridopts = optimset(hybridopts,'Display',...
                gaoptimget(options,'Display'));
            hybridopts = optimset(hybridopts,'MaxFunEvals',...
                2000*prod(this.sizeAngles));
            hybridopts = optimset(hybridopts,'MaxIter',...
                800);
            value = ...
                gaoptimset(options,'HybridFcn',...
                {@fminunc,hybridopts});
        end
        
    end
end