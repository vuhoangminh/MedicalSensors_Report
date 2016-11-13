% Clear all data and screen
clc;
clear all;
close all;
% addpath(genpath('D:\Master\Master programming\My codes'));

% Input from user
snr=input('High or Low: ');
num_frame=input('Enter frame: ');
% algorithm_num=input('Enter number of parts: ');

if snr==1
    srcFiles = dir('D:\Master\Master programming\My codes\test_seq_001\*.png'); 
	filename = strcat('D:\Master\Master programming\My codes\test_seq_001\',srcFiles(num_frame).name);
else
    srcFiles = dir('D:\Master\Master programming\My codes\low_snr\*.png');  
	filename = strcat('D:\Master\Master programming\My codes\low_snr\',srcFiles(num_frame).name);
end    

% Process image
original_image = imread(filename);
gray_image = mat2gray(original_image);
graystretch_image = imadjust(gray_image,stretchlim(gray_image),[]);
%       Input :
%       I -  the input image, it could be gray, color or binary image. If I is
%           empty([]), input image can be get from a open file dialog box.
%       C -  denotes the minimum ratio of major axis to minor axis of an ellipse, 
%           whose vertex could be detected as a corner by proposed detector.  
%           The default value is 1.5.
%       T_angle -  denotes the maximum obtuse angle that a corner can have when 
%           it is detected as a true corner, default value is 162.
%       Sig -  denotes the standard deviation of the Gaussian filter when
%           computing curvature. The default sig is 3.
%       H,L -  high and low threshold of Canny edge detector. The default value
%           is 0.35 and 0.
%       Endpoint -  a flag to control whether add the end points of a curve
%           as corner, 1 means Yes and 0 means No. The default value is 1.
%       Gap_size -  a paremeter use to fill the gaps in the contours, the gap
%           not more than gap_size were filled in this stage. The default 
%           Gap_size is 1 pixels.
%       Open_size -  removes from an edge map all connected components 
%			(objects) that have fewer than Open_size pixels

%	Para=[1.5,162,3,0.1,0,1,1,50];
C=1.5;
T_angle=162;
sig=3;
H=0.2;
L=0;
Endpoint=0;
Gap_size=1;
Open_size=50;







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% State-of-the-art denoising filter %%%%%%%%%%%%%%%%%%%%%
sigma = 25;
% Denoise 'original image'. The denoised image is 'y_est', and 'NA = 1' because 
%  the true image was not provided
tic;
[NA, denoised_graystretch_image] = BM3D(1, graystretch_image, sigma); 
denoise=toc
tic;

[corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=...
    curvature_corner_frame2(denoised_graystretch_image,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);

corner=toc

figure;
imshow(denoised_graystretch_image);
title('Denoised frame');

% figure;
% imshow(edge_map);
% title('Edge map before filtering');

% figure;
% imshow(marked_img3);
% title('After step 3');
% 
% figure;
% imshow(marked_img4);
% title('After step 4');

figure;
imshow(marked_img);
title('Denoised frame');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% sorted=sortrows(corner_index,[-4 -3]);
% 
% a=sorted(1:5,1:2);
% 
% % % figure;
% % % imshow(denoised_graystretch_image); hold on;
% % % plot(a);
% % 
% % 
% % for i=1:5
% %     img=mark(denoised_graystretch_image,sorted(i,1),sorted(i,2),5);
% % end





