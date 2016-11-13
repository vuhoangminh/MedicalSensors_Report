load lena;
[ES,PS,MU,SI] = hmtmodel(size(lena,1));

sigma = 0.1; %noise standard deviation
hh = daubcqf(4); %wavelet filter

x = lena + sigma*randn(size(lena));
disp(['PSNR of noisy image is ' num2str(psnr(lena,x)) 'dB']);
y=hdenoise(x,hh,[],ES,PS,MU,SI,0);
disp(['PSNR of denoised image is ' num2str(psnr(lena,y)) 'dB']);
figure(1);
image(x*255+1);
colormap(gray(256));
axis square;
title('Noisy image');
figure(2);
image(y*255+1);
colormap(gray(256));
axis square;
title('Denoised image');
