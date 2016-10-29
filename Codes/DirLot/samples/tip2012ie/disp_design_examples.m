%
% SVN identifier:
% $Id: disp_design_examples.m 272 2011-12-19 03:16:01Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009-2011, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

%% Initial setting
clear all
close all
transition = 0.25;   % Transition band width
location = sprintf('./filters/data128x128i%.2f/ga',transition);

%% Example
dec   = 2; % Decimation factor
ord   = 4;
alpha = -2.0; % Deformation parameter
dir   = Direction.HORIZONTAL; % Deforming direciton

if dir == Direction.VERTICAL
    phi = mod(atan(alpha)*180/pi,180);
else
    phi = mod(atan(1/alpha)*180/pi,180);
end
filterName = sprintf(...
    '%s/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVmd%06.2fh.mat', ...
    location, dec, dec, ord, ord, alpha, dir, phi);
display(filterName)
load(filterName)

figure(1)
freqz2(lppufb(1))
xlabel('\omega_x/\pi','FontSize',12,'FontName','AvantGrade')
ylabel('\omega_y/\pi','FontSize',12,'FontName','AvantGrade')
zlabel('Magnitude','FontSize',12,'FontName','AvantGrade')
set(gca,'FontSize',12,'FontName','AvantGrade')
view(-37.5,60)
%colormap(gray)

figure(2)
%bimshow(lppufb)
for iSubband = 1:4
    dispImg = rot90(lppufb(iSubband),2)+0.5;
    subplot(2,2,iSubband), imshow(dispImg)
    imwrite(imresize(dispImg,4,'nearest'),...
        sprintf('images/bimd22o44_%d.tif',iSubband))
end

%% Parameter Matrices
params = getParameterMatrices(lppufb);

symb = { 'W0' 'U0' 'Uy1' 'Uy2' 'Uy3' 'Uy4' 'Ux1' 'Ux2' 'Ux3' 'Ux4' };

format long
for idx=1:length(params)
    disp([symb{idx} ' = ']);
    disp(params{idx})
end
format short

fid = fopen('./results/pmtxtab.tex','w');
fprintf(fid,'\\begin{table*}[tb]\n');
fprintf(fid,'\\centering\n');
fprintf(fid,'\\caption{An example set of parameter matrices.}\n');
fprintf(fid,'\\label{tab:parammtx}\n');
%
fprintf(fid,'\\begin{tabular}{|c|c|c|c|c|}\\hline\n');
fprintf(fid,'$\\mathbf{W}_0$ & ');
fprintf(fid,'$\\mathbf{U}_0$ & ');
fprintf(fid,'$\\mathbf{U}^{\\{\\rm y\\}}_1$ & ');
fprintf(fid,'$\\mathbf{U}^{\\{\\rm y\\}}_2$ & ');
fprintf(fid,'$\\mathbf{U}^{\\{\\rm y\\}}_3$' );
fprintf(fid,'\\\\\\hline\n ');
for idx = 1:4
    fprintf(fid,'$\\begin{pmatrix}\n');
    mtx = params{idx};
    fprintf(fid,'% 6.4f & % 6.4f \\\\\n', mtx(1,1), mtx(1,2));
    fprintf(fid,'% 6.4f & % 6.4f \n', mtx(2,1), mtx(2,2));
    fprintf(fid,'\\end{pmatrix}$ & \n');
end
idx = 5;
fprintf(fid,'$\\begin{pmatrix}\n');
mtx = params{idx};
fprintf(fid,'% 6.4f & % 6.4f \\\\\n', mtx(1,1), mtx(1,2));
fprintf(fid,'% 6.4f & % 6.4f \n', mtx(2,1), mtx(2,2));
fprintf(fid,'\\end{pmatrix}$ \n');
fprintf(fid,'\\\\\\hline\n ');
%
fprintf(fid,'$\\mathbf{U}^{\\{\\rm y\\}}_4$ & ');
fprintf(fid,'$\\mathbf{U}^{\\{\\rm x\\}}_1$ & ');
fprintf(fid,'$\\mathbf{U}^{\\{\\rm x\\}}_2$ & ');
fprintf(fid,'$\\mathbf{U}^{\\{\\rm x\\}}_3$ & ');
fprintf(fid,'$\\mathbf{U}^{\\{\\rm x\\}}_4$');
%
fprintf(fid,'\\\\\\hline\\hline\n ');
for idx = 6:9
    fprintf(fid,'$\\begin{pmatrix}\n');
    mtx = params{idx};
    fprintf(fid,'% 6.4f & % 6.4f \\\\\n', mtx(1,1), mtx(1,2));
    fprintf(fid,'% 6.4f & % 6.4f \n', mtx(2,1), mtx(2,2));
    fprintf(fid,'\\end{pmatrix}$ & \n');
end
idx = 10;
fprintf(fid,'$\\begin{pmatrix}\n');
mtx = params{idx};
fprintf(fid,'% 6.4f & % 6.4f \\\\\n', mtx(1,1), mtx(1,2));
fprintf(fid,'% 6.4f & % 6.4f \n', mtx(2,1), mtx(2,2));
fprintf(fid,'\\end{pmatrix}$ \\\\\\hline\n');
%
fprintf(fid,'\\end{tabular}\n');
fprintf(fid,'\\end{table*}\n');
fclose(fid);
