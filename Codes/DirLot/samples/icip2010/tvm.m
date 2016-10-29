function psnr = tvm(orgImg,aveRate)

% Preparation
dec = 2;
nLevels = 3;
load 'lppufb_icip2010_dec22_ord44_alp-2.0_hor_tvm_phi153.43.mat'
paramMtx = getParameterMatrices(lppufb);

% Coding experiments with ECSQ
dirdwtquantizer = ...
    DirectionalDwtQuantizer([dec dec],paramMtx,aveRate);
dirdwtquantizer = ...
    dirDwtQuantize(dirdwtquantizer,orgImg,nLevels);

% Get PSNRs
psnr = getPsnr(dirdwtquantizer);

end