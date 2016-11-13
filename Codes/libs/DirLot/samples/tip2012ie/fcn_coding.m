function [psnr,resImg] = fcn_coding(trnsName,orgImg,aveRate,filterInfo)
% FCN_CODING
%
% SVN identifier:
% $Id: fcn_coding.m 272 2011-12-19 03:16:01Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009-2011, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
if nargin < 4
    dec = 2;
    ord = 4;
    alpha = -2.0;
    dir = 2;
    transition = 0.25;
    nLevels = 6;
else
    dec = filterInfo.dec;
    ord = filterInfo.ord;
    alpha = filterInfo.alpha;
    dir = filterInfo.dir;
    transition = filterInfo.transition;
    nLevels = filterInfo.nLevels;
end

if isa(orgImg,'uint8')
    orgImg = im2double(orgImg);
end

switch(trnsName)
    
    case 'BT'
        if dir == Direction.VERTICAL
            vm = mod(atan(alpha)*180/pi,180);
        else
            vm = mod(atan(1/alpha)*180/pi,180);
        end
      
        filterName = sprintf(...
            './filters/data128x128i%.2f/ga/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVmd%.2fh.mat' ...
            , transition, dec, dec, ord, ord, alpha, dir, vm);
        load(filterName)
        paramMtx = getParameterMatrices(lppufb);
        if dec == 4
            dirlot = UniformSubbandQuantizer([dec dec],paramMtx,aveRate,'termination');
            dirlot = uniformSubbandQuantize(dirlot,orgImg);
            psnr = getPsnr(dirlot);
            resImg = getImg(dirlot);
        elseif dec == 2
            dirlot = DirectionalDwtQuantizer([dec dec],paramMtx,aveRate,'termination');
            dirlot = dirDwtQuantize(dirlot,orgImg,nLevels);
            psnr = getPsnr(dirlot);
            resImg = getImg(dirlot);
        end
        
    case 'PE'
        if dir == Direction.VERTICAL
            vm = mod(atan(alpha)*180/pi,180);
        else
            vm = mod(atan(1/alpha)*180/pi,180);
        end
        
        filterName = sprintf(...
            './filters/data128x128i%.2f/ga/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVmd%.2fh.mat' ...
            , transition, dec, dec, ord, ord, alpha, dir, vm);
        load(filterName)
        paramMtx = getParameterMatrices(lppufb);
        if dec == 4
            dirlot = UniformSubbandQuantizer([dec dec],paramMtx,aveRate,'circular');
            dirlot = uniformSubbandQuantize(dirlot,orgImg);
            psnr = getPsnr(dirlot);
            resImg = getImg(dirlot);
        elseif dec == 2
            dirlot = DirectionalDwtQuantizer([dec dec],paramMtx,aveRate,'circular');
            dirlot = dirDwtQuantize(dirlot,orgImg,nLevels);
            psnr = getPsnr(dirlot);
            resImg = getImg(dirlot);
        end
        
    case 'VM1'
        
        vm = 1;
        filterName = sprintf(...
            './filters/data128x128i%.2f/ga/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVm%dh.mat' ...
            , transition, dec, dec, ord, ord, alpha, dir, vm);
        load(filterName)
        paramMtx = getParameterMatrices(lppufb);
        if dec == 4
            dirlot = UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            dirlot = uniformSubbandQuantize(dirlot,orgImg);
            psnr = getPsnr(dirlot);
            resImg = getImg(dirlot);
        elseif dec == 2
            dirlot = DirectionalDwtQuantizer([dec dec],paramMtx,aveRate);
            dirlot = dirDwtQuantize(dirlot,orgImg,nLevels);
            psnr = getPsnr(dirlot);
            resImg = getImg(dirlot);
        end
        
    case 'VM2'
        
        vm = 2;
        filterName = sprintf(...
            './filters/data128x128i%.2f/ga/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVm%dh.mat' ...
            , transition, dec, dec, ord, ord, alpha, dir, vm);
        load(filterName)
        paramMtx = getParameterMatrices(lppufb);
        if dec == 4
            dirlot = UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            dirlot = uniformSubbandQuantize(dirlot,orgImg);
            psnr = getPsnr(dirlot);
            resImg = getImg(dirlot);
        elseif dec == 2
            dirlot = DirectionalDwtQuantizer([dec dec],paramMtx,aveRate);
            dirlot = dirDwtQuantize(dirlot,orgImg,nLevels);
            psnr = getPsnr(dirlot);
            resImg = getImg(dirlot);            
        end
        
    case 'DCT'
        
        lppufb = LpPuFb2dFactory.createLpPuFb2d(0,[dec dec]);
        paramMtx = getParameterMatrices(lppufb);
        if dec == 4
            dct = UniformSubbandQuantizer([dec dec],paramMtx,aveRate);
            dct = uniformSubbandQuantize(dct,orgImg);
            psnr = getPsnr(dct);
            resImg = getImg(dct);            
        elseif dec == 2
            dct = DirectionalDwtQuantizer([dec dec],paramMtx,aveRate);
            dct = dirDwtQuantize(dct,orgImg,nLevels);
            psnr = getPsnr(dct);
            resImg = getImg(dct);
        end
        
    case 'DWT53'
        
        dwt53 = Dwt53Quantizer(aveRate);
        dwt53 = dwt53Quantize(dwt53,orgImg,nLevels);
        psnr = getPsnr(dwt53);
        resImg = getImg(dwt53);
        
    case 'DWT97'
        
        dwt97 = Dwt97Quantizer(aveRate);
        dwt97 = dwt97Quantize(dwt97,orgImg,nLevels);
        psnr = getPsnr(dwt97);
        resImg = getImg(dwt97);
    otherwise
        
        error('error');

end