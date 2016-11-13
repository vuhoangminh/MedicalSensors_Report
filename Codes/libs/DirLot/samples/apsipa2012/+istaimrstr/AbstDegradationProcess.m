classdef AbstDegradationProcess < hgsetget
    %ABSTDEGRADATIONPRODESS
    %   
    % SVN identifier:
    % $Id: AbstDegradationProcess.m 314 2012-04-09 11:09:04Z sho $
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
    end

    methods (Abstract = true)
        outputimg = linearprocess(this,inputimg);
        outputimg = reversalprocess(this,inputimg);
        outputdim = getDimension(this,inputdim);
        outputstr = getString(this);
        dimu = getDimU(this,dimx);
        [outputimg,str] = typicalReference(this,varargin);
        cloneobj = clone(obj);
    end
    
    methods 
        function output = linearprocessawgn(this,input,variance)
            output = imnoise(linearprocess(this,input),...
                'gaussian',0,variance);
        end
                
        % Lipshitz constant
        function value = getLipschitzConstantOverK(this,nDim)
            lcfile = sprintf('./lipschitzconst/%s_%dx%d.mat',...
                getString(this),nDim(1),nDim(2));
            if exist(lcfile,'file')
                data = load(lcfile,'lc');
                value = data.lc;
            else
                if labindex == 1
                    eps_ = 1e-6;
                    upst = ones(getDimU(this,nDim));
                    upst = upst/norm(upst(:));
                    err_ = Inf;
                    while ( err_ > eps_ ) % Power method
                        % upst = (P.'*P)*upre
                        upre = upst;
                        v    = linearprocess(this,upre); % P
                        upst = reversalprocess(this,v);  % P.'
                        err_ = norm(upst(:)-upre(:))^2/norm(upst(:));
                    end
                    n = sum(upst(:).'*upst(:));
                    d = sum(upst(:).'*upre(:));
                    lmax = n/d;
                    lc = 2*lmax;
                    save(lcfile,'lc')
                else
                    itr = 0;
                    while (~exist(lcfile,'file') || itr < 600)
                        itr = itr + 1;
                        pause(1)
                    end
                end
                labBarrier
                if labindex ~= 1
                    data = load(lcfile,'lc');
                    lc = data.lc;
                end
                value = lc;
            end
        end
    end        
end
