clear all
close all
fixed = dicomread('knee1.dcm');
moving = dicomread('knee2.dcm');
figure, imshowpair(moving, fixed, 'montage')
title('Unregistered')
figure, imshowpair(moving, fixed)
title('Unregistered')


[optimizer,metric] = imregconfig('multimodal');

movingRegisteredDefault = imregister(moving, fixed, 'affine', optimizer, metric);

figure, imshowpair(movingRegisteredDefault, fixed)
title('A: Default registration')

disp(optimizer)
disp(metric)


optimizer.InitialRadius = optimizer.InitialRadius/3.5;

movingRegisteredAdjustedInitialRadius = imregister(moving, fixed, 'affine', optimizer, metric);
figure, imshowpair(movingRegisteredAdjustedInitialRadius, fixed)
title('Adjusted InitialRadius')


optimizer.MaximumIterations = 300;
movingRegisteredAdjustedInitialRadius300 = imregister(moving, fixed, 'affine', optimizer, metric);

figure, imshowpair(movingRegisteredAdjustedInitialRadius300, fixed)
title('B: Adjusted InitialRadius, MaximumIterations = 300, Adjusted InitialRadius.')


tformSimilarity = imregtform(moving,fixed,'similarity',optimizer,metric);

Rfixed = imref2d(size(fixed));

movingRegisteredRigid = imwarp(moving,tformSimilarity,'OutputView',Rfixed);
figure, imshowpair(movingRegisteredRigid, fixed);
title('C: Registration based on similarity transformation model.');

tformSimilarity.T

movingRegisteredAffineWithIC = imregister(moving,fixed,'affine',optimizer,metric,...
    'InitialTransformation',tformSimilarity);
figure, imshowpair(movingRegisteredAffineWithIC,fixed);
title('D: Registration from affine model based on similarity initial condition.');



figure
imshowpair(movingRegisteredDefault, fixed)
title('A - Default settings.');

figure
imshowpair(movingRegisteredAdjustedInitialRadius, fixed)
title('B - Adjusted InitialRadius, 100 Iterations.');

figure
imshowpair(movingRegisteredAdjustedInitialRadius300, fixed)
title('C - Adjusted InitialRadius, 300 Iterations.');

figure
imshowpair(movingRegisteredAffineWithIC, fixed)
title('D - Registration from affine model based on similarity initial condition.');