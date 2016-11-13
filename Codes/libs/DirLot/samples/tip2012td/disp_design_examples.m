%% Initial setting
clear all
close all
transition = 0.25;   % Transition band width
location = sprintf('./filters/data128x128i%.2f/ga',transition);

isPsFrag = false;

%% First example
dec   = 2; % Decimation factor
ord   = 4;
alpha = -2.0; % Deformation parameter
dir   = Direction.HORIZONTAL; % Deforming direciton

if dir == Direction.VERTICAL
    phi = mod(atan(alpha)*180/pi,180);
else
    phi = mod(atan(1/alpha)*180/pi,180);
end
filterName = sprintf(...
    '%s/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVmd%06.2fh.mat', ...
    location, dec, dec, ord, ord, alpha, dir, phi);
display(filterName)
load(filterName)

h = figure(1);
if isPsFrag
    freqz2(lppufb(1))
    xlabel('Fx','FontSize',12,'FontName','AvantGrade')
    ylabel('Fy','FontSize',12,'FontName','AvantGrade')
    zlabel('Magnitude','FontSize',12,'FontName','AvantGrade')
    set(gca,'XTick',[-1 -0.5 0 0.5 1]);
    set(gca,'XTickLabel',[{'-pi'} {'-pi/2'} {'0'} {'pi/2'} {'pi'}]);
    set(gca,'YTick',[-1 -0.5 0 0.5 1]);
    set(gca,'YTickLabel',[{'-pi'} {'-pi/2'} {'0'} {'pi/2'} {'pi'}]);
    set(gca,'ZTick',[0 1 2]);
    set(gca,'FontSize',12,'FontName','AvantGrade')
    view(-37.5,60)
    colormap(gray)
    print(h,'-depsc2','./results/frqd22o44.eps')
else
    freqz2(lppufb(1))
    view(-37.5,60)
    colormap('default')
end

h = figure(2);
bimshow(lppufb)

for iSub = 1:4
    imwrite(imresize(rot90(lppufb(iSub)+0.5,2),4,'nearest'),...
        ['./results/bimd22o44_' num2str(iSub) '.tif']);
end

%% Second example
dec   = 4; % Decimation factor
ord   = 2;
alpha = -2.0; % Deformation parameter
dir   = Direction.HORIZONTAL; % Deforming direciton

if dir == Direction.VERTICAL
    phi = mod(atan(alpha)*180/pi,180);
else
    phi = mod(atan(1/alpha)*180/pi,180);
end
filterName = sprintf(...
    '%s/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVmd%06.2fh.mat', ...
    location, dec, dec, ord, ord, alpha, dir, phi);
display(filterName)
load(filterName)

h = figure(3);
if isPsFrag
    freqz2(lppufb(1))
    xlabel('Fx','FontSize',12,'FontName','AvantGrade')
    ylabel('Fy','FontSize',12,'FontName','AvantGrade')
    zlabel('Magnitude','FontSize',12,'FontName','AvantGrade')
    set(gca,'XTick',[-1 -0.5 0 0.5 1]);
    set(gca,'XTickLabel',[{'-pi'} {'-pi/2'} {'0'} {'pi/2'} {'pi'}]);
    set(gca,'YTick',[-1 -0.5 0 0.5 1]);
    set(gca,'YTickLabel',[{'-pi'} {'-pi/2'} {'0'} {'pi/2'} {'pi'}]);
    set(gca,'ZTick',[0 2 4]);
    set(gca,'FontSize',12,'FontName','AvantGrade')
    view(-37.5,60)
    colormap(gray)    
    print(h,'-depsc2','./results/frqd44o22.eps')
else
    freqz2(lppufb(1))
    view(-37.5,60)
    colormap('default')
end


h = figure(4);
bimshow(lppufb)

for iSub = 1:16
    imwrite(imresize(rot90(lppufb(iSub)+0.5,2),4,'nearest'),...
        ['./results/bimd44o22_' num2str(iSub) '.tif']);
end

%% VM2 example
dec   = 2; % Decimation factor
ord   = 4;
alpha = -2.0; % Deformation parameter
dir   = Direction.HORIZONTAL; % Deforming direciton

filterName = sprintf(...
    '%s/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVm2h.mat', ...
    location, dec, dec, ord, ord, alpha, dir);
display(filterName)
load(filterName)

figure(5)
freqz2(lppufb(1))
xlabel('\omega_x/\pi','FontSize',12,'FontName','AvantGrade')
ylabel('\omega_y/\pi','FontSize',12,'FontName','AvantGrade')
zlabel('Magnitude','FontSize',12,'FontName','AvantGrade')
set(gca,'FontSize',12,'FontName','AvantGrade')
view(-37.5,60)
colormap('default')

figure(6)
bimshow(lppufb)


