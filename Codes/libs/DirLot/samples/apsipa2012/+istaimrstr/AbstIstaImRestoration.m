classdef AbstIstaImRestoration < hgsetget
    %ABSTISTAIMAGERESTORATION
    %
    % SVN identifier:
    % $Id: AbstIstaImRestoration.m 317 2012-05-02 00:02:30Z sho $
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
    properties (GetAccess = public, SetAccess = protected)
        eps0 = 1e-6;
        smax = 1000;
        degradation;
        lambda;
        nTrx;
        valueL;
        valueS;
        ref;
        ismonitoring = false;
        isevaluation = false;
        psnr;
        mse;
        ssim;
        string;
        hihu;
        hihx;
        isfista=false;
    end
    
    properties (GetAccess = protected, SetAccess = protected)
        itr;
        x;
        y;
        r;
        u;
        v;
        t;
        hu;
        hx;
        err;
    end
    
    methods(Abstract = true)
        outputcf = dec2(this,inputim,ktrx);
        outputim = rec2(this,inputcf,ktrx);
        numYk = getNumYk(this,nDim);
        str = getString(this);
        %red = getRedundancy(this);
        valueS = getValueS(this,nDim,ktrx);
        obj = clone(this);
    end
    
    methods
        
        % Construnctor
        function this = AbstIstaImRestoration(varargin)
            if nargin == 1 && ...
                    isa(varargin{1},'istaimrstr.AbstIstaImRestoration')
                srcObj = varargin{1};
                props = properties(srcObj);
                for iProp = 1:length(props)
                    %disp(props{iProp});
                    this.(props{iProp}) = srcObj.(props{iProp});
                end
            else
                this.degradation = varargin{1};
                this.lambda = varargin{2};
            end
        end
        
        function this = setFista(this,isfista_)
            this.isfista = isfista_;
        end
        
        % Initalization
        function this = initialize(this,x_)
            this.itr = 0;
            this.x = x_;
            this.y = cell(1,this.nTrx); % Transform coefficients
            this.u = cell(1,this.nTrx);
            this.t = 0;
            
            nDim = getDimension(this.degradation,size(this.x));
            this.valueL = getLipschitzConstant(this,nDim);
            this.valueS{1} = getValueS(this,nDim,1);
            this.y{1} = dec2(this,reversalprocess(...
                this.degradation,this.x),1);
            %K_ = getRedundancy(this);
            for ktrx = 1:this.nTrx
                this.valueS{ktrx} = getValueS(this,nDim,ktrx);
                this.y{ktrx} = dec2(this,reversalprocess(...
                    this.degradation,this.x),ktrx)/this.nTrx;
            end
            this.v = this.y;
            this.hu = reversalprocess(this.degradation,this.x);
            this.hx = linearprocess(this.degradation,this.hu);
            this.r  = this.hx - this.x;
            this.err  = Inf;
            this.psnr = zeros(this.smax+1,1);
            this.mse  = zeros(this.smax+1,1);
            this.ssim = zeros(this.smax+1,1);
            % Monitoring
            if this.ismonitoring
                subplot(2,2,1), imshow(this.ref), title('u^\ast');
                subplot(2,2,2), imshow(this.x), title('x');
                subplot(2,2,3), this.hihu = imshow(this.hu); title('\^{u}');
                subplot(2,2,4), this.hihx = imshow(this.hx); title('\^{x}');
                drawnow
            end
            % Evaluation
            if ~isempty(this.ref)
                this = evaluation(this);
            end
        end
        
        % Step
        function this = step(this)
            this.itr = this.itr+1;
            h = reversalprocess(this.degradation,this.r);
            u_ = this.u;
            v_ = this.v;
            y_ = cell(1,this.nTrx);
            if this.isfista
                tpre   = this.t;
                this.t = (1+sqrt(1+4*tpre^2))/2.0;
            else
                tpre   = 1;
                this.t = 1;
            end
            parfor ktrx = 1:this.nTrx
                y_{ktrx} = softshrink(this,...
                    v_{ktrx}-(2.0/this.valueL)*dec2(this,h,ktrx));
                if this.isfista
                    v_{ktrx} = y_{ktrx} ...
                        + ((tpre-1)/this.t)*(y_{ktrx}-this.y{ktrx});
                else
                    v_{ktrx} = y_{ktrx};
                end
                u_{ktrx} = rec2(this,y_{ktrx},ktrx);
            end
            this.hu = 0;
            for ktrx = 1:this.nTrx
                this.y{ktrx} = y_{ktrx};
                this.u{ktrx} = u_{ktrx};
                this.v{ktrx} = v_{ktrx};
                this.hu = this.hu + u_{ktrx};
            end
            this.hx = linearprocess(this.degradation,this.hu);
            this.r  = this.hx - this.x;
        end
        
        % Run
        function this = run(this,x_)
            % Initialization
            this = initialize(this,x_);
            ypre = cell2mat(this.y);
            % Main Iteration of ISTA
            while ( this.err > this.eps0 && this.itr < this.smax )
                this = step(this);
                % Monitoring
                if this.ismonitoring
                    set(this.hihu,'CData',this.hu);
                    set(this.hihx,'CData',this.hx);
                    drawnow
                end
                % Evaluation
                if this.isevaluation
                    this = evaluation(this);
                end
                ypst = cell2mat(this.y);
                this.err = norm(ypst(:) - ypre(:))^2/norm(ypst(:))^2;
                ypre = ypst;
            end
        end
        
        function output = getResult(this)
            output = this.hu;
        end
        
        function this = setReference(this,ref_)
            this.ref = ref_;
        end
        
        function this = setMonitoring(this,flag)
            this.ismonitoring = flag;
        end
        
        function this = setEvaluation(this,flag)
            this.isevaluation = flag;
        end
        
        % Set lambda
        function this = setLambda(this,lambda_)
            this.lambda = lambda_;
        end
        
        function this = setSmax(this,smax_)
            this.smax = smax_;
        end
        
        function this = setEps0(this,eps0_)
            this.eps0 = eps0_;
        end
        
        function value = getLipschitzConstant(this,nDim)
            %K_ = getRedundancy(this);
            value = this.nTrx*getLipschitzConstantOverK(...
                this.degradation,getDimU(this.degradation,nDim));
        end
        
        % Evaluation
        function this = evaluation(this)
            [this.psnr(this.itr+1),this.mse(this.itr+1)] = ...
                fcn_psnr4peak1(this.ref,this.hu);
            this.ssim(this.itr+1) = ...
                ssim_index(im2uint8(this.ref),im2uint8(this.hu));
            fprintf('%2d) psnr = %6.2f, mse = %6.2f, ssim = %6.3f\n',...
                this.itr,this.psnr(this.itr+1),...
                255^2*this.mse(this.itr+1),...
                this.ssim(this.itr+1));
        end
        
        % Soft shrink
        function outputcf = softshrink(this,inputcf)
            T = this.lambda/this.valueL;
            nc = abs(inputcf)-T;
            nc(nc<0) = 0;
            outputcf = sign(inputcf).*nc;
        end
        
        function value = getComponents(this)
            value = this.u;
        end
        
    end
    
end