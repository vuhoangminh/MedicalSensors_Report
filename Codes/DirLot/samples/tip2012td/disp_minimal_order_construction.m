close all
clear all
%% Initial setting
format long

%% Haar basis
% E = LpPuFb2d();
E = LpPuFb2dFactory.createLpPuFb2d();
disp(E)
disp('h0 ='),disp(E(1))
disp('h1 ='),disp(E(2))
disp('h2 ='),disp(E(3))
disp('h3 ='),disp(E(4))
fprintf('--- \n')

figure(1)
bimshow(E)
figure(2)
subplot(2,2,1),freqz2(E(1)),view(-37.5,70)
subplot(2,2,2),freqz2(E(2)),view(-37.5,70)
subplot(2,2,3),freqz2(E(3)),view(-37.5,70)
subplot(2,2,4),freqz2(E(4)),view(-37.5,70)

%% TVM of horizontal direction
phi = pi/6; % [-pi/4,pi/4]
if phi >=-pi/4 && phi < pi/4
    if phi <= 0
        ss = [1 0 1 0 1];
        theta = pi+phi;
    else
        ss = [0 0 1 0 1];
        theta = 0+phi;
    end
elseif phi >=pi/4 && phi < 3*pi/4
    if phi <= pi/2
        ss = [1 0 0 0 0];
        theta = pi-phi;
    else
        ss = [0 0 0 0 0];
        theta = 0-phi;
    end
else
    error('Unexped error occured.');
end
E = fcn_ezdirlottvm(phi,ss,theta);
parMtx = getParameterMatrices(E);

fprintf('phi = %6.2f [deg]\n',phi*180/pi)
disp(' W0  ='),disp(parMtx{1})
disp(' U0  ='),disp(parMtx{2})
disp(' Uy1 ='),disp(parMtx{3})
disp(' Uy2 ='),disp(parMtx{4})
fprintf('\n')
disp('h0 ='),disp(E(1))
disp('h1 ='),disp(E(2))
disp('h2 ='),disp(E(3))
disp('h3 ='),disp(E(4))
fprintf('--- \n')

figure(3)
bimshow(E)

figure(4)
subplot(2,2,1),freqz2(E(1)),view(-37.5,70)
subplot(2,2,2),freqz2(E(2)),view(-37.5,70)
subplot(2,2,3),freqz2(E(3)),view(-37.5,70)
subplot(2,2,4),freqz2(E(4)),view(-37.5,70)

%% TVM of vertical direction
phi = 4*pi/6; % [pi/4,3pi/4]
if phi >=-pi/4 && phi < pi/4
    if phi <= 0
        ss = [1 0 1 0 1];
        theta = pi+phi;
    else
        ss = [0 0 1 0 1];
        theta = 0+phi;
    end
elseif phi >=pi/4 && phi < 3*pi/4
    if phi <= pi/2
        ss = [1 0 0 0 0];
        theta = pi-phi;
    else
        ss = [0 0 0 0 0];
        theta = 0-phi;
    end
else
    error('Unexped error occured.');
end
E = fcn_ezdirlottvm(phi,ss,theta);
parMtx = getParameterMatrices(E);

fprintf('phi = %6.2f [deg]\n',phi*180/pi)
disp(' W0  ='),disp(parMtx{1})
disp(' U0  ='),disp(parMtx{2})
disp(' Ux1 ='),disp(parMtx{3})
disp(' Ux2 ='),disp(parMtx{4})
fprintf('\n')
disp('h0 ='),disp(E(1))
disp('h1 ='),disp(E(2))
disp('h2 ='),disp(E(3))
disp('h3 ='),disp(E(4))
fprintf('--- \n')

figure(5)
bimshow(E)

figure(6)
subplot(2,2,1),freqz2(E(1)),view(-37.5,70)
subplot(2,2,2),freqz2(E(2)),view(-37.5,70)
subplot(2,2,3),freqz2(E(3)),view(-37.5,70)
subplot(2,2,4),freqz2(E(4)),view(-37.5,70)
