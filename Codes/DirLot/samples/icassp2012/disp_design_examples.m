%% Initial setting
clear all
close all

location = './filters/data128x128ampk3l3/ga';

isPsFrag = true;

%% First example
dec = 2; % Decimation factor
ord = 4;
phi = 30.0;

if abs(phi) < 45 
    dir = Direction.HORIZONTAL;
    alpha = cot(phi*pi/180);
else
    dir = Direction.VERTICAL;
    alpha = tan(phi*pi/180);
end

filterName = sprintf(...
    '%s/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVmd%06.2f.mat', ...
    location, dec, dec, ord, ord, alpha, dir, phi);
display(filterName)
load(filterName)

h = figure(1);
if isPsFrag
    freqz2(lppufb(1),[32 32])
    xlabel('wx','FontSize',12,'FontName','AvantGrade')
    ylabel('wy','FontSize',12,'FontName','AvantGrade')
    zlabel('Magnitude','FontSize',12,'FontName','AvantGrade')
    set(gca,'XTick',[-1 -0.5 0 0.5 1]);
    set(gca,'XTickLabel',[{'-pi'} {'-pi/2'} {'0'} {'pi/2'} {'pi'}]);
    set(gca,'YTick',[-1 -0.5 0 0.5 1]);
    set(gca,'YTickLabel',[{'-pi'} {'-pi/2'} {'0'} {'pi/2'} {'pi'}]);    
    set(gca,'ZTick',[0 1 2]);
    set(gca,'FontSize',12,'FontName','AvantGrade')
    view(-37.5,60)
    colormap(gray)
    print(h,'-deps2','./results/frqd22o44.eps');
else
    freqz2(lppufb(1))    
    view(-37.5,60)
    colormap('default')
end

figure(2)
bimshow(lppufb)

for iSub = 1:4
    imwrite(imresize(rot90(lppufb(iSub)+0.5,2),4,'nearest'),...
        ['./results/bimg22o44_' num2str(iSub) '.tif']);
end
