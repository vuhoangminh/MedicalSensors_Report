function [psnr,mse] = fcn_psnr4peak1(src,res)
mse = norm((res(:)-src(:)))^2/numel(src);
psnr = -10*log10(mse);