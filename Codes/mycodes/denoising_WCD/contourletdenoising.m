%===============================================================
% Contourlet denoising =========================================
%===============================================================
function cim = contourletdenoising( image )
% Parameters
pfilt = '9-7';
dfilt = 'pkva';
nlevs = [0, 0, 4, 4, 5];    % Number of levels for DFB at each pyramidal level
th = 3;                     % lead to 3*sigma threshold denoising
rho = 3;                    % noise level
sig = std(image(:));
sigma = sig / rho;

% Contourlet transform
y = pdfbdec(image, pfilt, dfilt, nlevs);
[c, s] = pdfb2vec(y);

% Threshold
% Require to estimate the noise standard deviation in the PDFB domain first 
% since PDFB is not an orthogonal transform
nvar = pdfb_nest(size(image,1), size(image, 2), pfilt, dfilt, nlevs);

cth = th * sigma * sqrt(nvar);
% cth = (4/3) * th * sigma * sqrt(nvar);

% Slightly different thresholds for the finest scale
fs = s(end, 1);
fssize = sum(prod(s(s(:, 1) == fs, 3:4), 2));
cth(end-fssize+1:end) = (4/3) * cth(end-fssize+1:end);

c = c .* (abs(c) > cth);

% Reconstruction
y = vec2pdfb(c, s);
cim = pdfbrec(y, pfilt, dfilt);
end

