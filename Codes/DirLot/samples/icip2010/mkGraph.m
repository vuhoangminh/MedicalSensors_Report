function mkGraph(bin1,bin2,bin3)

close all

plot(...
    .1:.2:4,bin1,'-k', ...
    .1:.2:4,bin2,'--k', ...
    .1:.2:4,bin3,'-ok')

grid on
xlabel('Average bit rate (bpp)','FontSize',12,'FontName','AvantGrade')
ylabel('PSNR (dB)','FontSize',12,'FontName','AvantGrade')
legend('TVM','VM2','9/7-tap DWT',2);
axis([0 4 14 48])