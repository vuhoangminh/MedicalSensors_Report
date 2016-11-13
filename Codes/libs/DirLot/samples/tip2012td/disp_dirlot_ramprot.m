%
% $Id: disp_dirlot_ramprot.m 260 2011-11-29 08:10:55Z sho $
%
close all
clear all

psfrag = false;

file{1} = 'results/dirlot_ramprot_results_1st';
file{2} = 'results/dirlot_ramprot_results_2nd';

drop{1} = -26.56;
drop{2} = -26.56;

for idx = 1:length(file)
    load(file{idx})
    figure(idx)
    plot(phixd,dirlotNorm0/arrayCard,'-k',...
        phixd,dctNorm0/arrayCard,':k',...
        'LineWidth',2)
    axis([-45 135 0 1])
    colormap gray
    caxis([ 0 1 ])
    if ~psfrag
        legend('DirLOT','DCT')
        xlabel('\phi_x','FontSize',12,'FontName','AvantGrade')
        ylabel('w_0','FontSize',12,'FontName','AvantGrade')
        set(gca,'XTick',[-45 0 45 90 135]);
        set(gca,'XTickLabel',{'-pi/4', '0', 'pi/4', 'pi/2', '3pi/4'});
        set(gca,'YTick',0:0.2:1);
        text(drop{idx},dirlotNorm0(1)/arrayCard,...
            '\downarrow',...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')
        text(drop{idx},dirlotNorm0(1)/arrayCard+0.05,...
            sprintf('% 8.4f',drop{idx}*pi/180),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')
    else
        legend('DirLOTxxxxx','DCT')
        xlabel('x','FontSize',12,'FontName','AvantGrade')
        ylabel('y','FontSize',12,'FontName','AvantGrade')
        set(gca,'XTick',[-45 0 45 90 135]);
        set(gca,'XTickLabel',{'a', 'b', 'c', 'd', 'e'});
        set(gca,'YTick',0:0.2:1);        
        text(drop{idx},dirlotNorm0(1)/arrayCard,...
            '\downarrow',...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')
        text(drop{idx},dirlotNorm0(1)/arrayCard+0.05,...
            'f',...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom')
    end
    set(gca,'FontSize',12,'FontName','AvantGrade')
end