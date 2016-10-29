function [hx,itr,psnr,mse,ssim] = fcn_bcrsowvshrink(x,lambda,nlevels,p)
% FCN_PCDSOWVSHRINK DirLOT Denosing with Block-Coordinate-Relaxation Algorithm
if nargin < 4 
    isdisplay = false;
    p = [];
else
    isdisplay = true;
end
isMinOrd = false;

eps0 = 1e-4;
smax = 100;

if lambda < 0 
    disp('BayesShrink')
    isbayes = true;
else
    fprintf('lambda = %6.3f\n',lambda)
    isbayes = false;
end

%% Wavelet setting
if nargin < 3 || isempty(nlevels) || nlevels <= 0
    nlevels = floor(log2(min(size(x))))-1;
end
fprintf('#levels: %d\n',nlevels)

%% Generate dictionary
[fwdtrx,invtrx,nTrx] = fcn_gendic(isMinOrd,isdisplay);

%% Initialization
itr = 0;
y = cell(1,nTrx); % Transform coefficients
for ktrx = 1:nTrx
    y{ktrx} = zeros(1,numel(x));
end
hx = zeros(size(x));
valueS = cell(1,nTrx);
% if isbayes
%     %valueT = cell(1,nTrx);
%     parfor ktrx=1:nTrx
%         [e,valueS{ktrx}] = wavedec2(fwdtrx{ktrx},x,nlevels);
%         yk = fcn_bayesshrink(e,valueS{ktrx});
%         y{ktrx} = yk/nTrx;
%     end
%     hx  = 0;
%     for ktrx=1:nTrx
%         hx = hx + waverec2(invtrx{ktrx},y{ktrx},valueS{ktrx});
%     end
% end
r = x - hx;
err = Inf; % Error for checking the convergence
psnr = zeros(smax+1,1);
mse = zeros(smax+1,1);
ssim = zeros(smax+1,1);
if isdisplay
    figure(2)
    subplot(1,3,1), imshow(p)
    subplot(1,3,2), imshow(x)
    subplot(1,3,3)
    hi = imshow(x);
    drawnow
end
% Evaluation
if ~isempty(p)
    [psnr(1),mse(1)] = fcn_psnr4peak1(p,hx);
    ssim(1) = ssim_index(im2uint8(p),im2uint8(hx));
    fprintf('%2d) psnr = %6.2f, mse = %6.2f, ssim = %6.3f\n',...
        itr,psnr(1),255^2*mse(1),ssim(1));
end

%% Main Iteration of Block Coordinate Relaxation
ynew = cell(1,nTrx);
while ( err > eps0 && itr < smax )
    err = 0;
    itr=itr+1;
    u = hx;
    z = r;
    for ktrx = 1:nTrx
        % Back-Projection (Forward transform)
        [e,valueS{ktrx}] = wavedec2(fwdtrx{ktrx},z,nlevels);
        % Shrinkage
        if isbayes 
            ynew{ktrx} = fcn_bayesshrink(y{ktrx}+e,valueS{ktrx});
        else
            ynew{ktrx} = fcn_softshrink(y{ktrx}+e,lambda,valueS{ktrx});
        end
        % Reconstruction
        u = u + waverec2(invtrx{ktrx},ynew{ktrx}-y{ktrx},valueS{ktrx});
        % Residual
        z = x - u;
        %
        err = err + norm(ynew{ktrx} - y{ktrx})^2;
        y{ktrx} = ynew{ktrx};
    end
    hx = u;
    r = z;
    if isdisplay
        set(hi,'CData',hx);
        drawnow
    end
    % Evaluation
    if ~isempty(p)
        [psnr(itr+1),mse(itr+1)] = fcn_psnr4peak1(p,hx);
        ssim(itr+1) = ssim_index(im2uint8(p),im2uint8(hx));
        fprintf('%2d) psnr = %6.2f, mse = %6.2f, ssim = %6.3f\n',...
            itr,psnr(itr+1),255^2*mse(itr+1),ssim(itr+1));
    end
    % Post-processing
    ycur = cell2mat(y).';
    err = err/norm(ycur(:))^2;
end
