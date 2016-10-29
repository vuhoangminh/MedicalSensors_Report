%% Initial setting
transition = 0.25;   % Transition band width
nPoints = [128 128]; % Number of frequency sampling points

%% First case
dec = [2 2]; % Decimation factor
alpha = -2.0; % Deformation parameter
direction = Direction.HORIZONTAL; % Deformation direciton

sbsp = SubbandSpecification(alpha,direction,dec); % Subband specification
sbsp = setTransition(sbsp,transition); % Set treansition band width

figure(1)
for idx = 1:prod(dec)
    spec = getPassStopAssignment(sbsp,nPoints,idx);
    subplot(dec(1),dec(2),idx)
    imshow(flipud(spec+1.0)/2.0);
end

%% Second case
dec = [4 4]; % Decimation factor
alpha = -2.0; % Deformation parameter
direction = Direction.HORIZONTAL; % Deformation direciton

sbsp = SubbandSpecification(alpha,direction,dec); % Subband specification
sbsp = setTransition(sbsp,transition); % Set treansition band width

figure(2)
for idx = 1:prod(dec)
    spec = getPassStopAssignment(sbsp,nPoints,idx);
    subplot(dec(1),dec(2),idx)
    imshow(flipud(spec+1.0)/2.0);
end