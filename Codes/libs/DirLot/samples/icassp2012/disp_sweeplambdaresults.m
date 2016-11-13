clear all; close all 
set(0,'defaultAxesFontSize',12)
set(0,'defaultTextFontSize',12)
set(0,'defaultAxesFontName','AvantGrade')
set(0,'defaultTextFontName','AvantGrade')

isPsFrag = true;
    
%% Prepare figure
f1 = figure('Position',[60 60 640 340]);
f2 = figure('Position',[120 60 640 340]);
f3 = figure('Position',[180 60 640 340]);
cnames = { 'DB5' 'SON4'  'NSCT' 'UDN4(HS)' 'UDN4(BCR)' };
wlist = { 'db5' 'son4' 'nsctmfdmf5' 'udn4' 'udn4bcr' };
cwidth = { 80 80 80 80 80};
lcol = { [1 0 0] [0 1 0] [0 0 1] [0 0 0] [0 1 1] }; 
lmrk = { 'o' '+' '.' 'x' '*'};            
lstyle = { '-' ':' '-' '--' '-.'};            
%slambda = 0:0.05:0.50;
lmax = 0.5;
slambda = 0:0.02:0.5;
level = 7;
sigma = 20;
%img = 'lena';
img = 'barbara';
%img = 'baboon';
%img = 'goldhill';

%% Prepare table

for ilambda = 1:length(slambda)
    lambda = slambda(ilambda);
    load(sprintf('./results/sweep_lambda_lmd%4.2f_lv%d_%s_%d.mat',lambda,level,img,sigma))
    rnames{ilambda} = texlabel(sprintf('lambda = %4.2f',lambda));
    for iTrx = 1:length(wlist)
        itype = find(strcmp(wtype,wlist{iTrx}));
        %
        cmse = mse(itype)*255^2;
        datmse{ilambda,iTrx} = sprintf('%14.2f',cmse);
        %
        cpsnr = psnr(itype);
        datpsnr{ilambda,iTrx} = sprintf('%14.2f',cpsnr);
        %
        cssim = ssim(itype);
        datssim{ilambda,iTrx} = sprintf('%14.3f',cssim);
    end
end

%% Display table
tmse = uitable('Parent',f1,...
    'Data', datmse,...
    'Position', [20 20 620 320],...
    'ColumnWidth', cwidth,...
    'ColumnName', cnames,...
    'RowName',rnames);
tpsnr = uitable('Parent',f2,...
    'Data', datpsnr,...
    'Position', [20 20 620 320],...
    'ColumnWidth', cwidth,...
    'ColumnName', cnames,...
    'RowName',rnames);
tssim = uitable('Parent',f3,...
    'Data', datssim,...
    'Position', [20 20 620 320],...
    'ColumnWidth', cwidth,...
    'ColumnName', cnames,...
    'RowName',rnames);

%% Display graph
crit = { 'MSE' 'PSNR' 'SSIM'  };
icrit = 1;
for itab = [ tmse tpsnr tssim ];
    dat = get(itab,'Data');
    f = figure;
    title(img)
    ylabel(crit{icrit})
    xlabel('lambda')
    if strcmp(crit(icrit),'MSE')
        axis([0 lmax 0 600]);
    elseif strcmp(crit(icrit),'PSNR')
        axis([0 lmax 15 35]);
    else
        axis([0 lmax 0 1]);
    end
    grid on
    hold on;
    for iCol = 1:length(cnames)
        xdat = [];
        ydat = [];
        p = plot(f);
        set(p,'Color',lcol{iCol});
        set(p,'Marker',lmrk{iCol});
        iRow = 1;
        for ilambda = 1:length(slambda)
            xdat = [ xdat slambda(ilambda) ];
            ydat = [ ydat str2double(dat{iRow,iCol}) ];
            set(p,'XData',xdat,'YData',ydat);
            drawnow
            iRow = iRow+1;
        end
    end
    legend(cnames{1},cnames{2},cnames{3},cnames{4},cnames{5},...
        'Location','Best')
    icrit = icrit + 1;
end

% Print Graph
if isPsFrag
    set(0,'defaultAxesFontSize',16)
    set(0,'defaultTextFontSize',16)
    set(0,'defaultAxesFontName','AvantGrade')
    set(0,'defaultTextFontName','AvantGrade')    
    icrit = 1;
    for itab = [ tmse tpsnr tssim ];
        h = figure;
        dat = get(itab,'Data');
        axis([0 lmax 0 1]);
        xlabel('lambda')
        ylabel(crit(icrit))
        set(gca,'XTick',0:0.1:lmax);
        colormap(gray)
        if strcmp(crit(icrit),'MSE')
            axis([0 lmax 0 600]);
            set(gca,'YTick',0:100:600);                        
        elseif strcmp(crit(icrit),'PSNR')
            axis([0 lmax 15 35]);
            set(gca,'YTick',15:5:35);            
        else
            axis([0 lmax 0 1]);
            set(gca,'YTick',0:0.1:1);    
        end
        grid off
        hold on;
        for iCol = 1:length(cnames)
            xdat = [];
            ydat = [];
            p = plot(h);
            set(p,'Color',[0 0 0]);
            set(p,'Marker',lmrk{iCol});
            set(p,'LineStyle',lstyle{iCol});
            iRow = 1;
            for ilambda = 1:length(slambda)
                xdat = [ xdat slambda(ilambda) ];
                ydat = [ ydat str2double(dat{iRow,iCol}) ];
                set(p,'XData',xdat,'YData',ydat);
                drawnow
                iRow = iRow+1;
            end
        end
        legend(cnames{1},cnames{2},cnames{3},cnames{4},cnames{5},...
            'Location','Best')
        fname = sprintf('./results/sweeplambda_%s_%s_lv%d_%d.eps',...
            crit{icrit},img,level,sigma);
        print(h,'-deps2',fname);
        icrit = icrit+1;
    end
end