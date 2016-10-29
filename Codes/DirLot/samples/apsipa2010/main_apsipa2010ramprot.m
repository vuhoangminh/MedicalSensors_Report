% MAIN_APSIPA2010RAMPROT
%
% SVN identifier:
% $Id: main_apsipa2010ramprot.m 244 2011-11-22 14:18:13Z sho $
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
isDisplay = true;

if isDisplay
    close all
end

%% Ramp Rotation
eps = 1e-15;
dim = [ 128 128  ];

%% DirLOT and DCT
load lppufb_apsipa2010_dec44_ord22_alp-2.0_hor_tvm-26.57.mat
phih = -26.57;

if isDisplay
    figure(1)
    dispBasisImages(lppufb)
    figure(2)
    subplot(221),freqz2(lppufb(1))
    subplot(222),freqz2(lppufb(2))
    subplot(223),freqz2(lppufb(3))
    subplot(224),freqz2(lppufb(4))
    drawnow
end

dirlot = lppufb;
dct = LpPuFb2dFactory.createLpPuFb2d(0,[4 4]);

%% Rotate Ramp Picture

idx = 1;
step = 1;
px = -45:step:134;
px = [px ; px+mod(phih,1)];
px = px(:).';
slope = 4;
sparsityRatioLot = zeros(size(px));
sparsityRatioDct = zeros(size(px));
sparsityRatioDwt = zeros(size(px));
coefsDwt = cell(7,1);
for phix = -45:step:134
    for offset = 0:mod(phih,1):mod(phih,1)
        srcImg = DirLotUtility.trendSurface(phix+offset,dim);
        if isDisplay
            figure(3), imshow(srcImg);
            drawnow;
        end
        
        % DirLot
        fdirlot = ForwardDirLot(dirlot);
        fdirlot = forwardTransform(fdirlot,srcImg);
        coefsLot = getSubbandCoefs(fdirlot);
        
        % DCT
        fdct = ForwardDirLot(dct);
        fdct = forwardTransform(fdct,srcImg);
        coefsDct = getSubbandCoefs(fdct);
        
        % 2-Level 9/7 Forward Dwt
        [subLL1,subHL1,subLH1,subHH1] = im97trnscq_ip(srcImg);
        [subLL2,subHL2,subLH2,subHH2] = im97trnscq_ip(subLL1);
        coefsDwt{1} = subLL2;
        coefsDwt{2} = subHL2;
        coefsDwt{3} = subLH2;
        coefsDwt{4} = subHH2;
        coefsDwt{5} = subHL1;
        coefsDwt{6} = subLH1;
        coefsDwt{7} = subHH1;
        
        % Annihilation example
        outputnormLot = 0;
        for iSubband = 1:length(coefsLot)
            coef = coefsLot{iSubband};
            subCoef = abs(coef);
            outputnormLot = outputnormLot + length(find(subCoef(:)>eps));
        end
        
        outputnormDct = 0;
        for iSubband = 1:length(coefsDct)
            coef = coefsDct{iSubband};
            subCoef = abs(coef);
            outputnormDct = outputnormDct + length(find(subCoef(:)>eps));
        end
        
        outputnormDwt = 0;
        for iSubband = 1:length(coefsDwt)
            coef = coefsDwt{iSubband};
            subCoef = abs(coef);
            outputnormDwt = outputnormDwt + length(find(subCoef(:)>eps));
        end
        
        inputnorm = length(find(abs(srcImg(:))>eps));
        sparsityRatioLot(idx) = outputnormLot/inputnorm;
        sparsityRatioDct(idx) = outputnormDct/inputnorm;
        sparsityRatioDwt(idx) = outputnormDwt/inputnorm;
        phix+offset
        px(idx) = phix+offset;
        idx = idx+1;
    end
end

%% Draw Graph

if isDisplay
    figure(4)
    plot(px,sparsityRatioLot,'-',...
        px,sparsityRatioDct,'--',...
        px,sparsityRatioDwt,'-.',...
        'LineWidth',2)
    grid on
    set(gca,'FontSize',12)
    set(gca,'FontName','AvantGarde')
    grid on
    xlabel('\phi_x')
    ylabel('Sparsity Ratio R_x')
    axis([-45 135 0 1])
    legend('4\times 4 DirLOT with 2-Ord.TVM (\phi=-26.57^\circ)',...
        '2-D 4\times 4 DCT',...
        '2-D 2-Level 9/7-Transform',...
        'Location','NorthEast')
end
