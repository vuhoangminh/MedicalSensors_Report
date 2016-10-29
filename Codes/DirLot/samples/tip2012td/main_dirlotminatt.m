%% Initial setting

isDisplay = false;

transition = 0.25;   % Transition band width
location = sprintf('./filters/data128x128i%.2f/ga',transition);

dec   = 2; % Decimation factor
ord   = 4;
alpha = -2.0; % Deformation parameter
dir   = Direction.HORIZONTAL; % Deforming direciton

if dir == Direction.VERTICAL
    phi = mod(atan(alpha)*180/pi,180);
else
    phi = mod(atan(1/alpha)*180/pi,180);
end

nPoints = [128 128];

%% TVM example
filterName = sprintf(...
    '%s/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVmd%06.2fh.mat', ...
    location, dec, dec, ord, ord, alpha, dir, phi);
display(filterName)
load(filterName)

if isDisplay
figure(1)
freqz2(lppufb(1))
xlabel('\omega_x/\pi','FontSize',12,'FontName','AvantGrade')
ylabel('\omega_y/\pi','FontSize',12,'FontName','AvantGrade')
zlabel('Magnitude','FontSize',12,'FontName','AvantGrade')
set(gca,'FontSize',12,'FontName','AvantGrade')
view(-37.5,60)
colormap(gray)
end

disp('Minimum of stopband attenuation')
for idx = 1:4
    [spec,sidx] = getPassStopAssignment(sbsp,nPoints,idx);
    robs = find(spec==-1); % Region of Stopband
    ampr = fftshift(abs(fft2(lppufb(sidx),nPoints(1),nPoints(2))));
    stpgain = 20*log10(max(ampr(robs)));
    stpatt = 20*log10(2)-stpgain;
    disp([num2str(sidx) ') ' num2str(stpatt) ' dB'])
end

%% VM2 example
filterName = sprintf(...
    '%s/lppufb2dDec%d%dOrd%d%dAlp%.1fDir%dVm2h.mat', ...
    location, dec, dec, ord, ord, alpha, dir);
display(filterName)
load(filterName)

if isDisplay
    figure(3)
    freqz2(lppufb(1))
    xlabel('\omega_x/\pi','FontSize',12,'FontName','AvantGrade')
    ylabel('\omega_y/\pi','FontSize',12,'FontName','AvantGrade')
    zlabel('Magnitude','FontSize',12,'FontName','AvantGrade')
    set(gca,'FontSize',12,'FontName','AvantGrade')
    view(-37.5,60)
    colormap(gray)
    
    figure(4)
    bimshow(lppufb)
end

disp('Minimum of stopband attenuation')
for idx = 1:4
    [spec,sidx] = getPassStopAssignment(sbsp,nPoints,idx);
    robs = find(spec==-1); % Region of Stopband
    ampr = fftshift(abs(fft2(lppufb(sidx),nPoints(1),nPoints(2))));
    stpgain = 20*log10(max(ampr(robs)));
    stpatt = 20*log10(2)-stpgain;
    disp([num2str(sidx) ') ' num2str(stpatt) ' dB'])
end