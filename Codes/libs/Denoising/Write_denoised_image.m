% Clear all data and screen
clc;
clear all;
close all;
% addpath(genpath('D:\Master\Master programming\My codes'));


srcFiles = dir('D:\Master\Master programming\My codes\test_seq_001\*.png'); 
N=length(srcFiles);

% Initialize matrices
original_image=zeros(288,382,N); 		% Original
gray_image=zeros(288,382,N);			% Gray
graystretch_image=zeros(288,382,N);		% stretch gray to 0-1
nonlocal_graystretch_image=zeros(288,382,N); 
transform_graystretch_image=zeros(288,382,N); 

% % Process image
% original_image = imread(filename);
% gray_image = mat2gray(original_image);
% graystretch_image = imadjust(gray_image,stretchlim(gray_image),[]);


% % Loop to store data
% for i = 1 : 4
%     filename = strcat('D:\Master\Master programming\My codes\test_seq_001\',srcFiles(i).name);
%     original_image(:,:,i) = imread(filename);
%     gray_image(:,:,i) = mat2gray(original_image(:,:,i));
%     graystretch_image(:,:,i) = imadjust(gray_image(:,:,i),stretchlim(gray_image(:,:,i)),[]);
%     str=srcFiles(i);
%     write_filename = sprintf('D:\Master\Master programming\My codes\Denoised sequence\%s',str);
%     imwrite(gray_image(:,:,i),write_filename);
% end


% Define the folder outside of the loop.
pathName = 'D:\Master\Master programming\My codes\Denoised sequence\Transform-Domain Collaborative Filtering\test_seq_001\';
% Create it if it doesn't exist.
if ~exist(pathName, 'dir')
  mkdir(pathName);
  % This will create to the full depth of the path.
  % Upper folder levels don't have to exist yet.
end



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







% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%% Fast non-local filter %%%%%%%%%%%%%%%%%%%%%
% nonlocal_graystretch_image = FAST_NLM_II(graystretch_image,5,3,0.15);
% 
% [corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=curvature_corner_frame(nonlocal_graystretch_image,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);
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



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%% State-of-the-art denoising filter %%%%%%%%%%%%%%%%%%%%%
% sigma = 25;
% % Denoise 'original image'. The denoised image is 'y_est', and 'NA = 1' because 
% %  the true image was not provided
% tic;
% [NA, denoised_graystretch_image] = BM3D(1, graystretch_image, sigma); 
% denoise=toc
% tic;
% % [corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=curvature_corner_frame2(denoised_graystretch_image,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);
% [corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=curvature_corner_frame(denoised_graystretch_image,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);
% 
% corner=toc
% 
% figure;
% imshow(denoised_graystretch_image);
% title('Denoised frame');
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
% title('Denoised frame');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



sigma = 25;
% Change your loop variable from i to frameNumber . i is not a good choice.
tic;
for i = 1 : N
    filename = strcat('D:\Master\Master programming\My codes\test_seq_001\',srcFiles(i).name);
    original_image(:,:,i) = imread(filename);
    gray_image(:,:,i) = mat2gray(original_image(:,:,i));
    graystretch_image(:,:,i) = imadjust(gray_image(:,:,i),stretchlim(gray_image(:,:,i)),[]);
    
    
%     nonlocal_graystretch_image(:,:,i) = FAST_NLM_II(graystretch_image(:,:,i),5,3,0.15);
    [NA, transform_graystretch_image(:,:,i)] = BM3D(1, graystretch_image(:,:,i), sigma);
    
    data= transform_graystretch_image(:,:,i);
%     imshow(data);
    str=strcat(srcFiles(i).name);
%     baseFileName = sprintf(str);
    fullFileName = fullfile(pathName, str);
    imwrite(data, fullFileName);
end % of the for loop

running=toc;