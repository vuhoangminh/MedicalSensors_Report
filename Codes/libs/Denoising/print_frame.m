function print_frame(algorithm_num) 
    if algorithm_num==1
        print_frame_original();
    elseif algorithm_num==2
        print_frame_original();
        print_frame_wiener();
    else
        print_frame_original();
        print_frame_filter();
        print_frame_denoise();
    end
end

function print_frame_original()
%%%%%%%%%%%%%%%%%%%%% Original image %%%%%%%%%%%%%%%%%%%%%
[corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=curvature_corner_frame(graystretch_image,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);
%     corners=detectFASTFeatures(graystretch_image(:,:,i),'MinContrast',0.01);

figure;
imshow(graystretch_image);
title('Original frame');

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
title('Final');

end

function print_frame_filter()
%%%%%%%%%%%%%%%%%%%%% Wiener filter %%%%%%%%%%%%%%%%%%%%%
wiener_window_size=3;     % set window size for Wiener filter 
filtered_graystretch_image = wiener2(graystretch_image,[wiener_window_size wiener_window_size]);

[corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=curvature_corner_frame(filtered_graystretch_image,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);

figure;
imshow(filtered_graystretch_image);
title('Filtered frame');

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
title('Final');

end


function print_frame_denoise();
%%%%%%%%%%%%%%%%%%%%% State-of-the-art denoising filter %%%%%%%%%%%%%%%%%%%%%
sigma = 25;
% Denoise 'original image'. The denoised image is 'y_est', and 'NA = 1' because 
%  the true image was not provided
tic;
[NA, denoised_graystretch_image] = BM3D(1, graystretch_image, sigma); 
denoise=toc
tic;
[corner_index,corner_index3,corner_index4,marked_img,marked_img3,marked_img4,edge_map]=curvature_corner_frame(denoised_graystretch_image,C,T_angle,sig,H,L,Endpoint,Gap_size,Open_size);
corner=toc

figure;
imshow(denoised_graystretch_image);
title('Denoised frame');

figure;
imshow(edge_map);
title('Edge map before filtering');

figure;
imshow(marked_img3);
title('After step 3');

figure;
imshow(marked_img4);
title('After step 4');

figure;
imshow(marked_img);
title('Final');
end

