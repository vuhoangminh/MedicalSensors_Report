% ----------------------------------------------------------------------- 
%  
% This function uses the SUSAN algorithm to find edges within an image 
%  
% 
% >>image_out = susan(image_in,threshold) 
% 
% 
% Input parameters ... The gray scale image, and the threshold  
% image_out .. (class: double) image indicating found edges 
% typical threshold values may be from 10 to 30 
% 
% 
%The following steps are performed at each image pixel:  
% ( from the SUSAN webpage, http://www.fmrib.ox.ac.uk/~steve/susan/susan/node4.html ) 
%  
% Place a circular mask around the pixel in question.  
% Calculate the number of pixels within the circular mask which have similar brightness to  
% the nucleus. These define the USAN.  
% Subtract USAN size from geometric threshold to produce edge strength image.  
% 
% Estimating moments to find the edge direction has not been implemented .  
% Non-maximal suppresion to remove weak edges has not been implemented yet. 
% 
% example: 
% 
% >> image_in=imread('test_pattern.tif'); 
% >> image = susan(image_in,27); 
% >> imshow(image,[])  
% 
% 
% Abhishek Ivaturi 
%  
% ------------------------------------------------------------------------- 
  
 
 function image_out = susan(im,threshold) 
 
close all 
 
clc 
 
% check to see if the image is a color image... 
d = length(size(im)); 
if d==3 
    image=double(rgb2gray(im)); 
elseif d==2 
    image=double(im); 
end 
 
% mask for selecting the pixels within the circular region (37 pixels, as 
% used in the SUSAN algorithm 
 
mask = ([ 0 0 1 1 1 0 0 ;0 1 1 1 1 1 0;1 1 1 1 1 1 1;1 1 1 1 1 1 1;1 1 1 1 1 1 1;0 1 1 1 1 1 0;0 0 1 1 1 0 0]);   
 
 
 
 
% the output image indicating found edges 
R=zeros(size(image)); 
 
 
 
% define the USAN area 
nmax = 3*37/4; 
 
% padding the image 
[a b]=size(image); 
new=zeros(a+7,b+7); 
[c d]=size(new); 
new(4:c-4,4:d-4)=image; 
   
for i=4:c-4 
     
    for j=4:d-4 
         
        current_image = new(i-3:i+3,j-3:j+3); 
        current_masked_image = mask.*current_image; 
    
 
%   Uncomment here to implement binary thresholding 
 
%         current_masked_image(find(abs(current_masked_image-current_masked_image(4,4))>threshold))=0;          
%         current_masked_image(find(abs(current_masked_image-current_masked_image(4,4))<=threshold))=1; 
 
 
%   This thresholding is more stable 
                  
             
        
        current_thresholded = susan_threshold(current_masked_image,threshold); 
        g=sum(current_thresholded(:)); 
         
        if nmax<g 
            R(i,j) = g-nmax; 
        else 
            R(i,j) = 0; 
        end 
    end 
end 
 
image_out=R(4:c-4,4:d-4);