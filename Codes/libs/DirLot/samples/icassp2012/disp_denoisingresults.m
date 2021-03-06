clear all; close all 
set(0,'defaultAxesFontSize',12)
set(0,'defaultTextFontSize',12)
set(0,'defaultAxesFontName','AvantGrade')
set(0,'defaultTextFontName','AvantGrade')

%% Prepare figure
f1 = figure('Position',[60 60 600 600]);
f2 = figure('Position',[120 60 600 600]);
f3 = figure('Position',[180 60 600 600]);
cnames = { 'DB5' 'SON4'  'NSCT' 'UDN4(HS)' 'UDN4(BCR)' };
wlist = { 'db5' 'son4' 'nsct' 'udn4' 'udn4bcr' };
%cnames = { 'DB5' 'SON4' 'UDN4(HS)' 'UDN4(BCR)' };
%wlist = { 'db5' 'son4' 'udn4' 'udn4bcr' };
cwidth = { 80 80 80 80 80 };
lcol = { [1 0 0] [0 1 0] [0 0 1] [0 0 0] [0 1 1] }; 
lmrk = { 'o' 'x' '+' '*' '.'};
%slambda = 'lmd0.10';
slambda = 'bayes';
level = 7;


%% Prepare table
imgset = { 'goldhill' 'lena' 'barbara' 'baboon' };
iRnames = 1;
nImgs = length(imgset);
for idx = 1:nImgs
    load(sprintf('./results/wv_psnrs_%s_lv%d_%s.mat',slambda,level,imgset{idx}))
    nSigmas = length(sigma);
    rnames{iRnames} = imgset{idx};
    for iSigma = 1:nSigmas
        rnames{iRnames+iSigma} = ...
            texlabel(sprintf('sigma = %d',sigma(iSigma)));
        for iTrx = 1:length(wlist)
            if strcmp(wlist{iTrx},'nsct')
                load(sprintf('./results/nsct_psnrs_%s_%s.mat',slambda,imgset{idx}))
                itype = 1;
            elseif strcmp(wlist{iTrx},'udn4bcr')
                load(sprintf('./results/bcrwv_psnrs_%s_lv%d_%s.mat',slambda,level,imgset{idx}))
                itype = 1;
            else
                load(sprintf('./results/wv_psnrs_%s_lv%d_%s.mat',slambda,level,imgset{idx}))
                itype = find(strcmp(wtype,wlist{iTrx}));
            end
            %
            cmse = mse(iSigma,itype)*255^2;
            datmse{iRnames+iSigma,iTrx} = sprintf('%14.2f',cmse);
            %
            cpsnr = psnr(iSigma,itype);
            datpsnr{iRnames+iSigma,iTrx} = sprintf('%14.2f',cpsnr);
            %
            cssim = ssim(iSigma,itype);
            datssim{iRnames+iSigma,iTrx} = sprintf('%14.3f',cssim);                
        end
    end
    iRnames = iRnames + nSigmas + 1;
end

%% Display table
tmse = uitable('Parent',f1,...
    'Data', datmse,...
    'Position', [20 20 560 560],...
    'ColumnWidth', cwidth,...
    'ColumnName', cnames,...
    'RowName',rnames);
tpsnr = uitable('Parent',f2,...
    'Data', datpsnr,...
    'Position', [20 20 560 560],...
    'ColumnWidth', cwidth,...
    'ColumnName', cnames,...
    'RowName',rnames);
tssim = uitable('Parent',f3,...
    'Data', datssim,...
    'Position', [20 20 560 560],...
    'ColumnWidth', cwidth,...
    'ColumnName', cnames,...
    'RowName',rnames);

%% Convert table to latex format
fid = fopen('./results/denoisetab.tex','w');
crit = { 'MSE' 'PSNR' 'SSIM'  };
icrit = 1;
for itab = [ tmse tpsnr tssim ];
    fprintf(fid,'\\begin{table}[tb]\n');
    fprintf(fid,'\\centering\n');    
    fprintf(fid,'\\caption{%s}\n',crit{icrit});
    %
    fprintf(fid,'\\begin{tabular}{|c||');
    for itype = 1:length(cnames)
        fprintf(fid,'c|');
    end
    fprintf(fid,'} \\hline \n');    
    %
    for iCol = 1:length(cnames)
        fprintf(fid,' & %s ',cnames{iCol});
    end
    fprintf(fid,'\\\\ \\hline\\hline\n');        
    %
    rnames = get(itab,'RowName');
    dat = get(itab,'Data');
    iRow = 1;
    for iImg = 1:nImgs
        fprintf(fid,' %s ',rnames{iRow});
        iRow = iRow+1;
        %
        fprintf(fid,' & \\multicolumn{%d}{c|}{} ', length(cnames));
        fprintf(fid,'\\\\ \\hline\n');
        %
        for iSigma = 1:nSigmas
            fprintf(fid,' $%s$ ',rnames{iRow});
            for iCol = 1:length(cnames)
                rdata(1,iCol) = str2double(dat{iRow,iCol});
            end            
            if strcmp(crit(icrit),'MSE')
                [dummy,bfidx] = min(rdata);
            else
                [dummy,bfidx] = max(rdata);
            end
            for iCol = 1:length(cnames)
                if iCol == bfidx
                    fprintf(fid,' & {\\bf %s} ',dat{iRow,iCol});
                else
                    fprintf(fid,' & %s ',dat{iRow,iCol});
                end
            end
            fprintf(fid,'\\\\ \\hline\n');            
            %
            iRow = iRow+1;
        end
        if iImg ~=nImgs
            fprintf(fid,'\\hline\n');                    
        end
    end
    %
    fprintf(fid,'\\end{tabular}\n');
    fprintf(fid,'\\end{table}\n\n');
    icrit = icrit+1;
end
fclose(fid);

%% Display graph
crit = { 'MSE' 'PSNR' 'SSIM' };

icrit = 1;
for itab = [ tmse tpsnr tssim ];
    dat = get(itab,'Data');
    iRow = 1;
    for iImg = 1:nImgs
        iRow = iRow+1;        
        f = figure;
        title(imgset{iImg})
        ylabel(crit{icrit})
        xlabel('sigma')
        if strcmp(crit(icrit),'MSE')
            axis([0 60 0 600]);
        elseif strcmp(crit(icrit),'PSNR')
             axis([0 60 0 40]);
        else
            axis([0 60 0 1]);
        end
        grid on
        hold on;
        for iCol = 1:length(cnames)
            xdat = [];
            ydat = [];
            p = plot(f);
            set(p,'Color',lcol{iCol});
            set(p,'Marker',lmrk{iCol});            
            jRow = iRow;
            for iSigma = 1:nSigmas
                xdat = [ xdat sigma(iSigma) ];
                ydat = [ ydat str2double(dat{jRow,iCol}) ];
                set(p,'XData',xdat,'YData',ydat);
                drawnow
                jRow = jRow+1;                
            end
        end
        legend(cnames{1},cnames{2},cnames{3},cnames{4},cnames{5},...
            'Location','Best')
        iRow = jRow;
    end
    icrit = icrit + 1;
end
