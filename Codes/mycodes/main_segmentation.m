%% This is a demo showing how to use this toolbox

%   Copyright by Quan Wang, 2012/04/25
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

clear;clc;close all;

CT_Image = dicomread('C:\Users\minhm\Desktop\Medical Sensors code\dataset\CT_Image');
CT_Image_d = double(CT_Image);
CT_Image_d = imresize(CT_Image_d, 256/144);
CT_Image_i = CT_Image_d / max(max(CT_Image_d));

I=CT_Image_i;
Y=I;
Z = edge(Y,'canny',0.75);



PET_Image = dicomread('C:\Users\minhm\Desktop\Medical Sensors code\dataset\PET_image');
PET_Image_d = double(PET_Image);
PET_Image_d = imresize(PET_Image_d, 256/144);
PET_Image_i = PET_Image_d / max(max(PET_Image_d));

% imwrite(uint8(Z*255),'edge.png');

Y=PET_Image_i;
% imwrite(uint8(Y),'blurred image.png');

k=2;
EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations

tic;
fprintf('Performing k-means segmentation\n');
[X, mu, sigma]=image_kmeans(Y,k);
imwrite(uint8(X*120),'initial labels.png');

[X, mu, sigma]=HMRF_EM(X,Y,Z,mu,sigma,k,EM_iter,MAP_iter);
imwrite(uint8(X*120),'final labels.png');
toc;