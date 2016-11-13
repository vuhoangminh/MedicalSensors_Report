clear; clc; close all;

% Get current path and dataset path
pwd;
currentFolder = pwd;
addpath(genpath('currentFolder'));
datasetFolder = fullfile(currentFolder,'\dataset');

% Open file selection dialog box
filename = uigetfile({'*.png';'*.dcm';'*.*'},'File Selector',...
    'MultiSelect', 'on', datasetFolder);

% Find format of an image
if iscell(filename)
    petFileName = filename{1};
else
    petFileName = filename;
end
petPath = fullfile(datasetFolder,'\',petFileName);
k = strfind(petFileName,'.');
petFormat = petFileName(k+1:end);

% Read an image based on its format
if strcmp(petFormat, 'dcm')
    petImage = dicomread(petPath);
else
    petImage = imread(petPath);
    petImage = rgb2gray(petImage);
end

petImage = double(petImage);
petImage = imresize(petImage, [256 256]);
petImage = petImage / max(max(petImage));


figure;
imshow(petImage);
title('orignal');

% Wavelet denoising
waveletImage = waveletdenoising( petImage );
figure;
imshow(waveletImage);
title('wavelet');

% Contourlet denoising
contourletImage = contourletdenoising( petImage );
figure;
imshow(contourletImage);
title('contourlet');

% BM3d
sigma = 25;
[NA, sparseImage] = BM3D(1, petImage, sigma);
figure, imshow(sparseImage);
title('bm3d');

% WCD
% Compute Gradient magnitude
[nRow, nColumn] = size(petImage);
for iRow=1:nRow
    for iColumn=1:nColumn
        waveconImage(iRow,iColumn)=sqrt(contourletImage(iRow,iColumn)^2+waveletImage(iRow,iColumn)^2);
    end
end

figure;
imshow(waveconImage);
title('wcd ^2');

for iRow=1:nRow
    for iColumn=1:nColumn
        waveconImage2(iRow,iColumn)=contourletImage(iRow,iColumn)/2+waveletImage(iRow,iColumn)/2;
    end
end

figure;
imshow(waveconImage2);
title('wcd / 2');

for iRow=1:nRow
    for iColumn=1:nColumn
        if contourletImage(iRow,iColumn) > waveletImage(iRow,iColumn);
            waveconImage3(iRow,iColumn)=contourletImage(iRow,iColumn);
        else
            waveconImage3(iRow,iColumn)=waveletImage(iRow,iColumn);
        end
        
    end
end

figure;
imshow(waveconImage3);
title('wcd >');

% % Diff image
% figure;
% imshowpair(im,wim,'diff');
% figure;
% imshowpair(im,cim,'diff');
% figure;
% imshowpair(im,bim,'diff');


% SNR ratio
ima=max(petImage(:));
imi=min(petImage(:));
ims=std(petImage(:));
disp('image:');
snr=20*log10((ima-imi)./ims)

ima=max(waveletImage(:));
imi=min(waveletImage(:));
ims=std(waveletImage(:));
disp('wavelet:');
snr=20*log10((ima-imi)./ims)

ima=max(contourletImage(:));
imi=min(contourletImage(:));
ims=std(contourletImage(:));
disp('contourlet:');
snr=20*log10((ima-imi)./ims)



ima=max(sparseImage(:));
imi=min(sparseImage(:));
ims=std(sparseImage(:));
disp('bm3d:');
snr=20*log10((ima-imi)./ims)


ima=max(waveconImage(:));
imi=min(waveconImage(:));
ims=std(waveconImage(:));
disp('wcd:');
snr=20*log10((ima-imi)./ims)

ima=max(waveconImage2(:));
imi=min(waveconImage2(:));
ims=std(waveconImage2(:));
disp('wcd:');
snr=20*log10((ima-imi)./ims)

ima=max(waveconImage3(:));
imi=min(waveconImage3(:));
ims=std(waveconImage3(:));
disp('wcd:');
snr=20*log10((ima-imi)./ims)
