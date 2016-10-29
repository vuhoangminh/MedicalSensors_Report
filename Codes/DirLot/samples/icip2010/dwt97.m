function psnr = dwt97(orgImg,aveRate)

% Preparation
nLevels = 3;

% Coding experiments with ECSQ
dwt97quantizer = Dwt97Quantizer(aveRate);
dwt97quantizer = dwt97Quantize(dwt97quantizer,orgImg,nLevels);

% PSNR
psnr = getPsnr(dwt97quantizer);

end