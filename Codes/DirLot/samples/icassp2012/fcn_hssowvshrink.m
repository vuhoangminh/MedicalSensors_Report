function [hx,psnr,mse,ssim] = fcn_hssowvshrink(x,lambda,nlevels,p)
% FCN_HSSOWVSHRINK DirLOT Denosing with Heuristic Shrinkage

if nargin < 4 
    isdisplay = false;
    p = [];
else
    isdisplay = true;
end
isMinOrd = false;

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
if isdisplay
    figure(2)
    subplot(1,3,1), imshow(p)
    subplot(1,3,2), imshow(x)
    subplot(1,3,3)
    hi = imshow(x);
    drawnow
end

%% Main Process of Heuristic Shrinkage
parfor ktrx = 1:nTrx
    % Back-Projection (Forward transform)
    [y,valueS] = wavedec2(fwdtrx{ktrx},x,nlevels); % e_i,k = phi'_i*r_i,k
    % Shrinkage
    %x{itrx} = fcn_bayesshrink(x{itrx},valueS); % x_i,k = S(e_i,k)
        if isbayes
            y = fcn_bayesshrink(y,valueS)/nTrx;
        else
            y = fcn_softshrink(y,lambda,valueS)/nTrx;
        end    
    % 
    u{ktrx} = waverec2(invtrx{ktrx},y,valueS); % phi_i*x_i,k
end
% Reconstruction
hx = 0;
for ktrx = 1:nTrx
    % Update
    hx = hx + u{ktrx}; % y_k = sum(phi_j*x_i,k)
end

if isdisplay
    set(hi,'CData',hx);
    drawnow
end

% Evaluation
if ~isempty(p)
    [psnr,mse] = fcn_psnr4peak1(p,hx);
    ssim = ssim_index(im2uint8(p),im2uint8(hx));
    fprintf('psnr = %6.2f, mse = %6.2f, ssim = %6.3f\n',...
        psnr,255^2*mse,ssim);
end
