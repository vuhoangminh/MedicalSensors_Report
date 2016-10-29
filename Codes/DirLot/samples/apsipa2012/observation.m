function x = observation(dgrd,p,strpic,nsigma)
noise_var = (nsigma/255)^2;
xfname = sprintf(...
    './images/observed_%s_%s_ns%06.2f.tif',strpic,getString(dgrd),nsigma);
if exist(xfname,'file')
    disp(['Load ' xfname])
    x = im2double(imread(xfname));
else
    x = linearprocessawgn(dgrd,p,noise_var);
    imwrite(x,xfname);
end