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
    srcFiles = dir('D:\Master\Master programming\My codes\Dataset\test_seq_001\*.png'); 
	filename = strcat('D:\Master\Master programming\My codes\Dataset\test_seq_001\',srcFiles(num_frame).name);
else
    srcFiles = dir('D:\Master\Master programming\My codes\Dataset\low_snr\*.png');  
	filename = strcat('D:\Master\Master programming\My codes\Dataset\low_snr\',srcFiles(num_frame).name);
end    

% Process image
orimg = imread(filename);
grimg = mat2gray(orimg);
gsimg = imadjust(grimg,stretchlim(grimg),[]);
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
H=0.3;
L=0;
Endpoint=0;
Gap_size=1;
Open_size=50;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Original image %%%%%%%%%%%%%%%%%%%%%
[corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map_ori,thresh_ori]=...
    curvature_corner_frame(gsimg,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);


% figure;
% imshow(gsimg);
% s=sprintf('Original frame (frame %i)',num_frame);
% title(s);


figure;
imshow(edge_map_ori);
title('Edge map before filtering');
% 
% % figure;
% % imshow(marked_img3);
% % title('After step 3');
% % 
% % figure;
% % imshow(marked_img4);
% % title('After step 4');
% 
% figure;
% imshow(marked_img);
% title('Original frame');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%% Wiener filter %%%%%%%%%%%%%%%%%%%%%
% % wiener_window_size=5;     % set window size for Wiener filter 
% % filtered_graystretch_image = wiener2(gsimg,[wiener_window_size wiener_window_size]);
% % 
% % [corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=curvature_corner_frame(filtered_graystretch_image,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);
% % 
% % figure;
% % imshow(filtered_graystretch_image);
% % title('Filtered frame');
% % 
% % figure;
% % imshow(edge_map);
% % title('Edge map before filtering');
% % 
% % % figure;
% % % imshow(marked_img3);
% % % title('After step 3');
% % % 
% % % figure;
% % % imshow(marked_img4);
% % % title('After step 4');
% % 
% % figure;
% % imshow(marked_img);
% % title('Filtered frame');
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%% Fast non-local filter %%%%%%%%%%%%%%%%%%%%%
% nonlocal_graystretch_image = FAST_NLM_II(gsimg,5,3,0.15);
% 
% [corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=...
% curvature_corner_frame(nonlocal_graystretch_image,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);
% 
% figure;
% imshow(nonlocal_graystretch_image);
% title('Non-local frame');
% 
% figure;
% imshow(edge_map);
% title('Edge map before filtering');
% 
% % figure;
% % imshow(marked_img3);
% % title('After step 3');
% % 
% % figure;
% % imshow(marked_img4);
% % title('After step 4');
% 
% figure;
% imshow(marked_img);
% title('Non-local frame');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% State-of-the-art denoising filter %%%%%%%%%%%%%%%%%%%%%
sigma = 25;
% Denoise 'original image'. The denoised image is 'y_est', and 'NA = 1' because 
%  the true image was not provided
tic;
[NA, deimg] = BM3D(1, gsimg, sigma); 
denoise=toc
tic;
% [corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=curvature_corner_frame2(deimg,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);
[corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map,thresh_de]...
    =curvature_corner_new_marker(deimg,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);

corner=toc

% figure;
% imshow(deimg);
% s=sprintf('Denoised frame (frame %i)',num_frame);
% title(s);


figure;
imshow(edge_map);
s=sprintf('Edge map after being denoised (frame %i)',num_frame);
title(s);


% figure;
% imshow(marked_img3);
% title('After step 3');
% 
% figure;
% imshow(marked_img4);
% title('After step 4');

figure;
imshow(marked_img);
s=sprintf('Feature points (frame %i)',num_frame);
title(s);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% % Fast Corner Detection
% corners1=detectFASTFeatures(gsimg,'MinContrast',0.15);
% figure;
% imshow(gsimg); hold on;
% plot(corners1.selectStrongest(30));
% % plot(corners1);



% corners1=detectFASTFeatures(deimg,'MinContrast',0.01);
% figure;
% imshow(deimg); hold on;
% plot(corners1.selectStrongest(30));


%%%%%%%%%%%%%%%%%%%%% 
% I2 = im2uint16(deimg);
% figure;imagesc(orimg);
% figure;imagesc(I2);
% figure;imshow(deimg);
% figure;imshow(gsimg);


figure;
h = imshowpair(edge_map,edge_map_ori,'ColorChannels','red-cyan');
