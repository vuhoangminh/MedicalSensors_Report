%
% $Id: disp_tvmramprot.m 271 2011-12-16 05:13:51Z sho $
%
close all
clear all

load results/tvmramprot_results

%%
phixd = 30;
dim = [ 32 32 ];
display(phixd);
srcImg = DirLotUtility.trendSurface(phixd,dim);
figure(1), imshow(srcImg)
imwrite(srcImg,sprintf('images/ramp%03d.tif',phixd))

%% R_0
[mx,my] = meshgrid(-45:134,-45:134);
figure(2)
step = 1;
surfc(mx(1:step:end,1:step:end),...
    my(1:step:end,1:step:end),...
    arrayNorm0woScl(1:step:end,1:step:end)/arrayCard);
xlabel('\phi_x','FontSize',12,'FontName','AvantGrade')
ylabel('\phi','FontSize',12,'FontName','AvantGrade')
zlabel('w_0','FontSize',12,'FontName','AvantGrade')
axis([-45 135 -45 135 0 1])
colormap gray
caxis([ 0 1 ])
view(-20,20)
set(gca,'YTick',[-45 0 45 90 135]);
set(gca,'YTickLabel',{'-pi/4', '0', 'pi/4', 'pi/2', '3pi/4'});
set(gca,'XTick',[-45 0 45 90 135]);
set(gca,'XTickLabel',{'-pi/4', '0', 'pi/4', 'pi/2', '3pi/4'});
set(gca,'FontSize',12,'FontName','AvantGrade')
shading interp

%% For psfrag
%{
[mx,my] = meshgrid(-45:134,-45:134);
figure(3)
step = 2;
offset = 1;
mesh(mx(1+offset:step:end,1+offset:step:end),...
    my(1+offset:step:end,1+offset:step:end),...
    arrayNorm0woScl(1+offset:step:end,1+offset:step:end)/arrayCard);
xlabel('x','FontSize',12,'FontName','AvantGrade')
ylabel('y','FontSize',12,'FontName','AvantGrade')
zlabel('z','FontSize',12,'FontName','AvantGrade')
axis([-45 135 -45 135 0 1])
colormap gray
caxis([ 0 1 ])
view(-20,20)
set(gca,'YTick',[-45 0 45 90 135]);
set(gca,'YTickLabel',{'a', 'b', 'c', 'd', 'e'});
set(gca,'XTick',[-45 0 45 90 135]);
set(gca,'XTickLabel',{'a', 'b', 'c', 'd', 'e'})
%set(gca,'ZTick',[0 200 400 600]);
set(gca,'FontSize',12,'FontName','AvantGrade')
%shading interp
%}