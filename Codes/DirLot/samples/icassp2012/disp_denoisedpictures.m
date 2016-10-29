clear all; close all
%%
sigma = 20;
imgset = { 'barbara' };
fileset{1} = './images/barbara.png';
fileset{2} = './images/noisy_barbara_20_0.tif';
fileset{3} = './images/sweep_result_db5_barbara_lmd0.14_lv7_20.tif';
fileset{4} = './images/sweep_result_nsctmfdmf5_barbara_lmd0.04_lv7_20.tif';
fileset{5} = './images/sweep_result_udn4_barbara_lmd0.12_lv7_20.tif';
fileset{6} = './images/sweep_result_udn4bcr_barbara_lmd0.20_lv7_20.tif';
ppart = [80 256];
psize = [128 128];
f = figure;
set(f,'Name', 'barbara')
for ifile=1:length(fileset)
    fname = fileset{ifile};
    pic = imread(fname);
    pic = circshift(pic,-ppart);
    pic = pic(1:psize(1),1:psize(2));
    imwrite(pic,sprintf('./images/fig_%d.tif',ifile))
    subplot(2,3,ifile)
    axis off
    subimage(pic)
end
