% MAIN_MINIMAL_ORDER_DESIGN
%
% $Id: main_minimal_order_design.m 184 2011-08-17 14:13:14Z sho $
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
clear all
close all
results = zeros(180,8);
idx = 1;
for phid = -45:134 % trend direction
    
    phi = (mod(phid+45,180)-45) * pi/180.0;
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

    % Optimization of theta for minimizing the distance from Haar basis
    options = gaoptimset(@ga);
    options = gaoptimset(options,'PopInitRange',[theta-pi/4; theta+pi/4]);
    options = gaoptimset(options,'Display','iter');
    optTheta = ga(@(x)fcn_dist_from_haar(phi,ss,x),1,...
        [],[],[],[],[],[],[],options);

    %
    E = fcn_ezdirlottvm(phi,ss,optTheta);
    figure(1)
    bimshow(E)
    
    figure(2)
    subplot(2,2,1),freqz2(E(1))
    subplot(2,2,2),freqz2(E(2))
    subplot(2,2,3),freqz2(E(3))
    subplot(2,2,4),freqz2(E(4))
    drawnow;
    
    disp([phid theta optTheta]);
    results(idx,:) = [phid ss(:).' theta optTheta];
    idx = idx+1;

end

%%
save results/minimal_order_design_results results