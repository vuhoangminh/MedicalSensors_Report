function [xa,Da,psnr,mse,ssim] = fcn_aprxsowv(x,nlevels,Da,p)

if nargin < 4 
    isdisplay = false;
    p = [];
else
    isdisplay = true;
end

if nargin < 3 || isempty(Da)
    iscreateDa = true;
else
    iscreateDa = false;
end

%% Generate dictionary
[fwdtrx,invtrx,nTrx] = fcn_gendic(false,isdisplay);

if isdisplay
    figure(2)
    subplot(1,3,1), imshow(p)
    subplot(1,3,2), imshow(x)
    subplot(1,3,3), 
    hi = imshow(x);
    drawnow
end

%%
Dak = cell(1,nTrx);
vc = cell(nTrx,1);

parfor ktrx=1:nTrx
    [valueC,valueS] = wavedec2(fwdtrx{ktrx},x,nlevels);
    sizea = valueS(1,:);
    vc{ktrx} = valueC(1:prod(sizea)).';
    if iscreateDa
        sizef = valueS(end,:);
        imp = zeros(1,prod(sizef));
        atom = zeros(prod(sizef),prod(sizea));
        for idx = 1:prod(sizea)
            imp(idx) = 1;
            ires = waverec2(invtrx{ktrx},imp,valueS);
            atom(:,idx) = ires(:);
            imp(idx) = 0;
        end
        Dak{ktrx} = atom;
    end
end

%%
if iscreateDa
    Da = cell2mat(Dak);
end
va = cell2mat(vc);
%ya = Da\x(:);
ya = (Da.'*Da)\va;
%ya = pinv(Da.'*Da)*va;
%ya = pinv(Da)*x(:);

%%
xa = reshape(Da*ya,size(x));
if isdisplay
    set(hi,'CData',xa);
    drawnow
end

%% Evaluation
if ~isempty(p)
    [psnr,mse] = fcn_psnr4peak1(p,xa);
    ssim = ssim_index(im2uint8(p),im2uint8(xa));
    fprintf('psnr = %6.2f, mse = %6.2f, ssim = %6.3f\n',...
        psnr,255^2*mse,ssim);
end
