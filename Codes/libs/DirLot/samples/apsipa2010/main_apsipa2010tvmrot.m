% MAIN_APSIPA2010TVMROT
%
% SVN identifier:
% $Id: main_apsipa2010tvmrot.m 91 2011-03-02 04:06:12Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009-2010, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
%
isDisplay = true;
isOutput = false;
directry = 'data128x128i0.25/fmin0';

%% TVM Rotation
dec = [ 2 2 ];
eps = 1e-15;
step = 1;
nLevels = 3;

%% Create Ramp Edge Picture
phix = 30;
dim = [ 128 128 ];
srcImg = DirLotUtility.trendSurface(phix,dim);

if isDisplay
    figure(1), imshow(srcImg);
end

if isOutput
    imwrite(srcImg,'./images/ramp30.tif')
end

%%
px = -45:step:134;
sparsityRatio = zeros(size(px));
idx = 1;
for phi = -45:step:134
    fprintf('phi = %f\n',phi);
    if mod(phi+45,180)-45 < 45
        ord = [ 0 2 ];
        dir = Direction.VERTICAL;
    else
        ord = [ 2 0 ];
        dir = Direction.HORIZONTAL;
    end
    
    fileName = sprintf(...
        '%s/lppufb2dDec22Ord%d%dAlp0.0Dir%dVmd%06.2fh.mat',...
        directry,ord(1),ord(2),dir,phi);
    load(fileName)
    
    if isDisplay
        figure(2)
        subplot(221),freqz2(lppufb(1))
        subplot(222),freqz2(lppufb(2))
        subplot(223),freqz2(lppufb(3))
        subplot(224),freqz2(lppufb(4))
        drawnow
    end
    
    % Forward transform
    fdirlot = ForwardDirLot(lppufb);
    coefs = waveletDirLot(fdirlot,srcImg,nLevels);
    
    % Annihilation example
    outputnorm = 0;
    for iSubband = prod(dec)+(nLevels-1)*3:-1:1
        coef = coefs{iSubband};
        subCoef = abs(coef);
        outputnorm = outputnorm + length(find(subCoef(:)>eps));
    end
    
    inputnorm = length(find(abs(srcImg(:))>eps));
    sparsityRatio(idx) = outputnorm/inputnorm;
    idx = idx+1;
end

%% Draw Graph

if isDisplay
    figure(3)
    plot(px,sparsityRatio,...
        'LineWidth',2)
    grid on
    set(gca,'FontSize',12)
    set(gca,'FontName','AvantGarde')
    xlabel('\phi [degree]','FontName','AvantGarde','FontSize',12)
    ylabel('Sparsity Ratio R_x','FontName','AvantGarde','FontSize',12)
    axis([-45 135 0 1]);
end
