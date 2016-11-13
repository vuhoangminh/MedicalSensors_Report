% Clear all data and screen
clc;
clear all;

% Read a sequence of frames
srcFiles = dir('D:\Master\Master programming\My codes\test_seq_001\*.png');  
N=length(srcFiles);

% Initialize matrices
original_image=zeros(288,382,N); 		% Original
%scale_image=zeros(288,382,N);			% Scale
gray_image=zeros(288,382,N);			% Gray
graystretch_image=zeros(288,382,N);		% stretch gray to 0-1

% % Loop to store data
% for i = 1 : N
%     filename = strcat('D:\Master\Master programming\My codes\test_seq_001\',srcFiles(i).name);
%     original_image(:,:,i) = imread(filename);
%     gray_image(:,:,i) = mat2gray(original_image(:,:,i));
%     graystretch_image(:,:,i) = imadjust(gray_image(:,:,i),stretchlim(gray_image(:,:,i)),[]);
% end

% figure;
% % Loop to store data
% for i = 1 : N
%     imshow(graystretch_image(:,:,i))
% end

% Process last frame
filename = strcat('D:\Master\Master programming\My codes\test_seq_001\',srcFiles(N).name);
original_image(:,:,N) = imread(filename);
gray_image(:,:,N) = mat2gray(original_image(:,:,N));
graystretch_image(:,:,N) = imadjust(gray_image(:,:,N),stretchlim(gray_image(:,:,N)),[]);

% Take last frame as an example for more processing
last_frame=graystretch_image(:,:,N);
% imshow(last_frame);
% title('Last frame');

% Wiener filter to remove noise and sharpen image
wiener_window_size=3;     % set window size for Wiener filter 
filtered_last_frame = wiener2(last_frame,[wiener_window_size wiener_window_size]);
% figure;
% imshow(filtered_last_frame);
% str=sprintf('Last frame with Wiener filter (m=%i)',wiener_window_size);
% title(str);

% Find effective number of segments C in Fuzzy C-means/ K-means
% % Original
% [group_labels, num_groups, omega_auto, V_picked] = DaSpec(filtered_last_frame);
% Modified
[num_cluster, omega_auto] = DaSpec(filtered_last_frame);

num_cluster=2; % test
% Find segments 
[L,C,U,LUT,H] = DemoFCM(filtered_last_frame,num_cluster);

% Display segmented groups
% L=mat2gray(L);
figure;
imagesc(L);
title('Segmented frame');axis off;

% L_filtered = wiener2(L,[10 10]);
% figure;
% imagesc(L_filtered);
% title('Segmented frame');axis off;

% Canny Edge detection
% BW1 = edge(L,'sobel');
BW1 = edge(L,'canny'); % Canny is better
figure;imshow(BW1);

% % Find Corners
% corners=detectFASTFeatures(BW1);
% imshow(filtered_last_frame); hold on;
% plot(corners.selectStrongest(50)); 

% % Find Corners with prop.
% corners=detectFASTFeatures(filtered_last_frame,'MinContrast',0.01,'ROI', [160,1,200,150]);
% imshow(filtered_last_frame); hold on;
% plot(corners.selectStrongest(20));


% Display each segment

% Using Canny from the beginning => quite good
BW=edge(filtered_last_frame,'canny',0.01);
figure;imshow(BW);
% 
% % Remove small objects
% % Fill closed objects:
% binaryImage = imfill(BW , 'holes');
% % Get rid of objects less than 50 pixels:
% binaryImage = bwareaopen(binaryImage,50);
% figure;imshow(binaryImage);






