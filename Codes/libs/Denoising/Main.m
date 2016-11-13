% Clear all data and screen
clc;
clear all;

% Read a sequence of frames
% srcFiles = dir('D:\Master\Master programming\My codes\test_seq_001\*.png');  
srcFiles = dir('D:\Master\Master programming\My codes\low_snr\*.png');  
N=length(srcFiles);

% Initialize matrices
original_image=zeros(288,382,N); 		% Original
%scale_image=zeros(288,382,N);			% Scale
gray_image=zeros(288,382,N);			% Gray
graystretch_image=zeros(288,382,N);		% stretch gray to 0-1
edge_map=zeros(288,382,N);	
marked_image=zeros(288,382,N);

tic
% Loop to store data
for i = 1:1:N
%     filename = strcat('D:\Master\Master programming\My codes\test_seq_001\',srcFiles(i).name);
    filename = strcat('D:\Master\Master programming\My codes\low_snr\',srcFiles(i).name);
    original_image(:,:,i) = imread(filename);
    gray_image(:,:,i) = mat2gray(original_image(:,:,i));
    graystretch_image(:,:,i) = imadjust(gray_image(:,:,i),stretchlim(gray_image(:,:,i)),[]);
%     edged_image(:,:,i)=edge(graystretch_image(:,:,i),'canny',[0,0.35]);  % Detect edges
    [cout,marked_image(:,:,i),edge_map(:,:,i)]=curvature_corner(graystretch_image(:,:,i));
%     corners=detectFASTFeatures(graystretch_image(:,:,i),'MinContrast',0.01);
end
Processing_time=toc;



% Loop to store data
for i = 1:1:N
%     figure(1);
%     imshow(graystretch_image(:,:,i));
    figure(2);
    imshow(marked_image(:,:,i));
    s=sprintf('(frame %i)',i);
    title(s);
%     pause(0.2);
end










