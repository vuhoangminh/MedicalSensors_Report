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
segmented=zeros(288,382);

num_cluster=9; % test

for j=1:382
    for i=1:288
        segmented(i,j)=ceil(filtered_last_frame(i,j)*num_cluster);
    end
end

figure;
imagesc(segmented);
