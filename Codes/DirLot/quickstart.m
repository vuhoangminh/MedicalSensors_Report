%% Quick Start of DirLOT Toolbox
% A brief introduction to directional lapped orthogonal transforms

%% Readme file
% README.txt contains some informations on DirLOT Toolbox.

type('README.txt')

%% Preparation
% Before using DirLOT Toolbox, it is required to set the path to
% the directories 'dirlot', 'genlot', 'appendix' and 'mexcodes'
% under this Toolbox. Change the current directory to the top
% directory of DirLOT Toolbox, and execute the command 'setpath'.

setpath

%% Sample codes
% A lot of sample codes are found under directory 'samples.'
% In the following denoising and deblurring demos, we will use 
% some of sample codes. Please set the path by calling command 'addpath.'

addpath('./samples/tip2012td')

%% Original image for denoising and deblurring.
% Prepare grayscale picture as an original.

clear all
close all
src = im2double(imread('cameraman.tif'));
f1 = figure(1);
pf1 = [20 180 1120 500];
set(f1,'Position',pf1)
subplot(2,3,1), imshow(src)
title('Original image')
drawnow

%% Define PSNR
% Define PSNR to evaluate the denoising results.
% The peak is set to one.

mse  = @(x,y) sum((x(:)-y(:)).^2)/numel(x);
psnr = @(x,y) -10*log10(mse(x,y));

%% Selection of DirLOT bases
% In this denoising demo, a union of multiple DirLOTs is used.
% Here, several predesigned bases are selected.
% If you are interested in the design of DirLOTs, please see the following
% function:
%
%    ./appendix/fcn_dirlot_design_fr.m
%

idx = 1;
fname{idx} = 'lppufb2dDec22Ord44Alp0.0Dir1Vm2.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir2Vmd030.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp1.7Dir1Vmd060.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir1Vmd120.00.mat'; idx = idx+1;
fname{idx} = 'lppufb2dDec22Ord44Alp-1.7Dir2Vmd150.00.mat';

%% Instantiation of forward and inverse transform objects
% Instantiate forward and inverse transform objects by using
% the selected bases, and set the boundary operation to 
% the termination mode.

nTrx = length(fname); % Number of bases
fwdtrx = cell(nTrx,1);
invtrx = cell(nTrx,1);
for idx = 1:nTrx
    % Load pre-designed LpPuFb2d (DirLOT) object
    load(['./samples/icassp2012/filters/data128x128ampk3l3/ga/' ...
        fname{idx} ]); % Variable lppufb contains a predesigned basis.
    % Prepare forward transform object
    fwdtrx{idx} = ForwardDirLot(lppufb,'termination');
    % Prepare inverse transform Object
    invtrx{idx} = InverseDirLot(lppufb,'termination');
end

%% Display basis images
% Let's see the basis images of one of the loaded DirLOTs.
% Method dispBasisImages() of object 'lppufb,'
% an instance of class AbstLpPuFb2d, can be used for this purpose.

figure(2)
dispBasisImages(lppufb)
drawnow

%% Access to basis images
% As well, let us verify the frequency magnitude response of
% the scaling filter. The impulse response of the k-th basis
% image of object 'lppufb' can be accessed by the subscription.

figure(3)
freqz2(lppufb(1))
xlabel('\omega_x/\pi','FontSize',12,'FontName','AvantGrade')
ylabel('\omega_y/\pi','FontSize',12,'FontName','AvantGrade')
zlabel('Magnitude','FontSize',12,'FontName','AvantGrade')
set(gca,'FontSize',12,'FontName','AvantGrade')
view(-37.5,60)
drawnow

%% Open MATLAB pool
% If Parallel Computing Toolbox (PCT) is avilable, it is recommended to open
% MATLAB pool.

%matlabpool

%% Build MEX files
% If MATLAB Coder is avilable, it is recommended to generate some MEX codes
% by executing the batch script 'mybuild.'

%mybuild

%% Produce observation by adding noise
% Add noise by using function 'imnoise', which is available from
% Image Processing Toolbox

sigma = 40;
v = (sigma/255)^2; % noise variance
obs = imnoise(src,'gaussian',0,v); % Add white Gaussian noise to the original
figure(f1)
subplot(2,3,2), imshow(obs)
title(['Noisy image: PSNR = ' num2str(psnr(src,obs),'%6.2f') ' [dB]'])
drawnow

%% Main process of simple heuristic shrinkage
% Simple heuristic shrinkage is applied to the noisy image.
% The number of wavelet scales is set to four.
% The function 'fcn_bayesshrink' realizes the soft-thresholding
% called BayesShrink.

disp('It takes a few minutes to complete the heuristic shrinkage...')
disp('It is recommended to open matlabpool if PCT is available.')

nLevels = 4; % Number of wavelet scales
% The following code runs in parallel if MATLAB pool is available.
parfor itrx = 1:nTrx
    % Back-Projection (Forward transform)
    [valueC,valueS] = wavedec2(fwdtrx{itrx},obs,nLevels);
    % Shrinkage
    valueC = fcn_bayesshrink(valueC,valueS);
    % Forward-Projection (Inverse transform)
    u{itrx} = waverec2(invtrx{itrx},valueC,valueS);
end

%% Reconstruction of denoised image
% Combine every pictures obtained by the inverse transform.

y = 0;
for itrx = 1:nTrx
    y = y + u{itrx}/nTrx;
end

%% Compare denoising performances
% Comparing denoising performance among four methods:
% Gaussian filter (imfilter plus fspecial), Wiener filter (wiener2), 
% BayesShrink with single symmetric orthonormal wavelet and
% simple heuristic shrinkage with mixture of multiple wavelets.

g = imfilter(obs,fspecial('gaussian',[5 5],1),'symmetric');
figure(f1)
subplot(2,3,3), imshow(g)
title(['Denosied image (Gaussian filter): PSNR = ' ...
    num2str(psnr(src,g),'%6.2f') ' [dB]'])
drawnow

w = wiener2(obs);
figure(f1)
subplot(2,3,4), imshow(w)
title(['Denosied image (Wiener filter): PSNR = ' ...
    num2str(psnr(src,w),'%6.2f') ' [dB]'])
drawnow

figure(f1)
subplot(2,3,5), imshow(u{1})
title(['Denoised image (Wavelet shrinkage): PSNR = ' ...
    num2str(psnr(src,u{1}),'%6.2f') ' [dB]'])
drawnow

figure(f1)
subplot(2,3,6), imshow(y)
title(['Denoised image (Heuristic shrinkage): PSNR = ' ...
    num2str(psnr(src,y),'%6.2f') ' [dB]'])
drawnow

%% Setting parameters for deblurring
psfSigma = 2; % Std. deviation of PSF 
nseSigma = 5; % Std. deviation of AWGN
eps      = 1e-3; % Permitted error for convergence of ISTA
lambda   = 0.0045; % Control parametero fidelity and sparsity

%% Preperation of measurement process
psfSize = 2*round(4*psfSigma)+1;
psf = fspecial('gaussian',psfSize,psfSigma);
linrprocess = @(x) imfilter(x,psf,'conv','circ'); % P
dualprocess = @(x) imfilter(x,psf,'corr','circ'); % P.'

%% Produce observation by blurring and adding noises
obs = imnoise(linrprocess(src),'gaussian',0,(nseSigma/255)^2);
f4 = figure(4);
pf4 = get(f4,'Position');
pf4(1:2) = [20 80];
set(f4,'Position',pf4)
subplot(2,2,1), imshow(src);
title('Original image')
subplot(2,2,2), imshow(obs);
title(sprintf('Blurred image：PSNR = %5.2f [dB]',psnr(src,obs)))

%% Main process of ISTA-based image restoration
% ISTA-based image restoration is applied to a blurred image.
% The number of wavelet scales is set to four.

disp('It takes a few minutes to complete ISTA...')
disp('It is recommended to open matlabpool if PCT is available.')

% Preprocessing for calculating the max. eigen value of P.'P
upst = 0*obs;
upst(1,1) = 1;
eps_ = 1e-6;
err_ = Inf;
while ( err_ > eps_ ) 
    upre = upst;
    v    = linrprocess(upre); % P
    upst = dualprocess(v);    % P.'
    err_ = norm(upst(:)-upre(:))^2/norm(upst(:));
end
n  = sum(upst(:).'*upst(:));
d  = sum(upst(:).'*upre(:));
lc = n/d;
fprintf('Lipschitz Const.: %f\n',lc);

% Main iteration of ISTA
softshrink  = @(y,lmd) sign(y).*max(abs(y)-lmd,0);
[y,s] = udirsowtdec2(dualprocess(obs),nLevels,fwdtrx);
err = Inf;
figure(f4)
subplot(2,2,4), hi = imshow(obs);
ht = title(sprintf('Retored image(ISTA)：PSNR = %5.2f [dB]',...
    psnr(src,dualprocess(obs))));
itr = 0;
psnrs = psnr(src,dualprocess(obs));
f5 = figure(5);
pf5 = get(f5,'Position');
pf5(1:2) = [pf4(3)+20 80];
set(f5,'Position',pf5);
hp = plot(itr,psnrs);
xlabel('# of iterations')
ylabel('PSNR[dB]')
while ( err > eps ) 
    ypre = y;
    v = linrprocess(udirsowtrec2(ypre,s,invtrx));
    e = udirsowtdec2(dualprocess(v-obs),nLevels,fwdtrx)/lc;
    y = softshrink(ypre - e,lambda/lc);
    err = norm(y(:)-ypre(:))^2/norm(y(:));
    resIsta = udirsowtrec2(y,s,invtrx);
    set(hi,'CData',resIsta)
    set(ht,'String',sprintf('Restored image (ISTA)：PSNR = %5.2f [dB]',...
        psnr(src,resIsta)))
    itr = itr+1;
    psnrs = [psnrs psnr(src,resIsta)];
    set(hp,'XData',0:itr,'YData',psnrs);    
    drawnow    
end

%% Compare deblurring performances
% Comparing denoising performance among four methods:
% Gaussian filter (imfilter plus fspecial), Wiener filter (wiener2) 
% and ISTA-based deblurring with a union of DirSOWTs.

noise_var = (nseSigma/255)^2;
estimated_nsr = noise_var / var(src(:));
resWnr = deconvwnr(obs, psf, estimated_nsr);
figure(f4)
subplot(2,2,3), imshow(resWnr);
title(sprintf('Restored image (Wiener)：PSNR = %5.2f [dB]',...
    psnr(src,resWnr)))

figure(f5)
hold on
plot(0:itr,psnr(src,resWnr)*ones(1,itr+1),'r')
legend('ISTA','Wiener','Location','Best')
hold off

%matlabpool close

%% Release notes
% RELEASENOTES.txt contains release notes on DirLOT Toolbox.

type('RELEASENOTES.txt')