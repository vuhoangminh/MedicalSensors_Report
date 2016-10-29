%
% SVN identifier:
% $Id: main_ecsq.m 272 2011-12-19 03:16:01Z sho $
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

%% Settings
clear imageset
location = 'images';
imageset{1} = 'barbara_72x72';

for iImg = 1:length(imageset)
    figure(iImg)
    inputimage = imageset{iImg};
    transforms = { 'PE', 'BT' };
    %
    filterInfo.transition = 0.25;
    filterInfo.dec = 2;
    filterInfo.ord = 4;
    filterInfo.alpha = -2.0;
    filterInfo.dir = 2;
    filterInfo.nLevels = 3;
    
    bitRate = 0.5;
    
    %%
    if isempty(inputimage)
        if filterInfo.dir == Direction.VERTICAL
            phix = mod(atan(filterInfo.alpha)*180/pi,180);
        else
            phix = mod(atan(1/filterInfo.alpha)*180/pi,180);
        end
        f = 8;
        dim = [128 128];
        inputimage = strrep(...
            sprintf('coswave%06.2f_f%d_%dx%d',phix,f,dim(1),dim(2)),...
            '.','_');
        inputfile = [  location '/'  inputimage '.tif'  ];
        imwrite(DirLotUtility.coswave(phix,f,dim),inputfile);
    else
        inputfile = [  location '/'  inputimage '.tif'  ];
    end
    
    %% Load original image
    orgImg = im2double(imread(inputfile));
    subplot(1,3,1), imshow(orgImg),
    title('Original')
    drawnow
    
    %%
    psnrs = zeros(1,length(transforms));
    for iTrns = 1:length(transforms)
        trns = transforms{iTrns};
        [psnr,resImg] = fcn_coding(trns,orgImg,bitRate,filterInfo);
        subplot(1,3,iTrns+1), imshow(resImg),
        title(sprintf('%s(%6.2f)',trns,psnr)),drawnow
        outputfile = [strrep(sprintf('%s/%s_r%3.1f_%s_psnr%05.2f',...
            location,inputimage,...
            bitRate,trns,psnr),'.','_') '.tif'];
        imwrite(resImg,outputfile)
    end
    
end
