%% This is a demo showing how to use this toolbox

%   Copyright by Quan Wang, 2012/04/25
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

clear all;clc;close all;

% CT_Image = dicomread('C:\Users\minhm\Desktop\Medical Sensors code\dataset\CT.dcm');
CT_Image = imread('C:\Users\minhm\Desktop\Medical Sensors code\dataset\CT2.png');
CT_Image_d = rgb2gray(CT_Image);
CT_Image_d = double(CT_Image_d);
% [mC,nC]=size(CT_Image);
CT_Image_d = imresize(CT_Image_d, [256 256]);
CT_Image_i = CT_Image_d / max(max(CT_Image_d));

I=CT_Image_i;
Y=I;
T=Y;
Z = edge(Y,'canny',0.75);



% PET_Image = dicomread('C:\Users\minhm\Desktop\Medical Sensors code\dataset\PET.dcm');
PET_Image = imread('C:\Users\minhm\Desktop\Medical Sensors code\dataset\PET2.png');
PET_Image_d = rgb2gray(PET_Image);
PET_Image_d = double(PET_Image_d);
PET_Image_d = imresize(PET_Image_d, [256 256]);
PET_Image_i = PET_Image_d / max(max(PET_Image_d));

% imwrite(uint8(Z*255),'edge.png');

Y=PET_Image_i;
% imwrite(uint8(Y),'blurred image.png');

k=3;
EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations


tic;
fprintf('Performing k-means segmentation\n');
[intialSegmented, mu, sigma]=image_kmeans(Y,k);
imwrite(uint8(intialSegmented*120),'initial labels.png');

lastSegmented=intialSegmented;
[lastSegmented, mu, sigma]=HMRF_EM(lastSegmented,Y,Z,mu,sigma,k,EM_iter,MAP_iter);
imwrite(uint8(lastSegmented*120),'final labels.png');
toc;




figure; imshow(T); title('High resolution image');
figure; imshow(Y); title('High contrast image');
figure; imshow(Z); title('Edge of High resolution image');
figure; imshow(intialSegmented,[]); title('Initial Segmentation');
figure; imshow(lastSegmented,[]); title('Final Segmentation');


