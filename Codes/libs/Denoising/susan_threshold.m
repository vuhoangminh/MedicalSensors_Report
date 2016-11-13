% ------------------------------------------------------------- 
% 
%  >> thresholded_image = susan_threshold(image,threshold); 
% 
%    applies the thresholding scheme, 
% 
%              -{(I(r) - I(r0))/t}^(5/6) 
%        c = e 
%    to the current neighborhood of the center pixel  
%    within the circle defined by the mask 
% 
%  Abhishek Ivaturi 
%   
% ------------------------------------------------------------------ 
 
 
 
function thresholded = susan_threshold(image,threshold) 
 
 
[a b]=size(image); 
intensity_center = image((a+1)/2,(b+1)/2); 
 
temp1 = (image-intensity_center)/threshold; 
temp2 = temp1.^6; 
thresholded = exp(-1*temp2);