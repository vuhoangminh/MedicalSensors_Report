%===============================================================
% Wavelet denoising ============================================
%===============================================================
function wim = waveletdenoising( image )
% Parameters
pfilt = '9-7';
dfilt = 'pkva';
nlevs = [0, 0, 4, 4, 5];    % Number of levels for DFB at each pyramidal level
th = 3;                     % lead to 3*sigma threshold denoising
rho = 3;                    % noise level
sig = std(image(:));
sigma = sig / rho;


% Wavelet transform using PDFB with zero number of level for DFB
y = pdfbdec(image, pfilt, dfilt, zeros(length(nlevs), 1));
[c, s] = pdfb2vec(y);

% Threshold (typically 3*sigma)
wth = th * sigma;
c = c .* (abs(c) > wth);

% Reconstruction
y = vec2pdfb(c, s);
wim = pdfbrec(y, pfilt, dfilt);
end

