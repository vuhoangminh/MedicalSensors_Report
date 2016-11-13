function [psnr,mse] = fcn_psnr4peak1(src,res)
%
% SVN identifier:
% $Id: fcn_psnr4peak1.m 383 2013-10-07 04:55:32Z sho $
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
mse = norm((res(:)-src(:)))^2/numel(src);
psnr = -10*log10(mse);