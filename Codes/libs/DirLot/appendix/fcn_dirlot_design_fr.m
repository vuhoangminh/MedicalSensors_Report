function [cost, lppufb, sbsp] = fcn_dirlot_design_fr(params)
%FCN_DIRLOT_DESIGN_FR Design of DirLOTs by subband frequency specification
%
% Example:
% >> params.nPoints = [ 128 128 ]; % Frequency grid
% >> params.ord = [ 2 2 ]; % Polyphase order
% >> params.dec = [ 2 2 ]; % Number of decomposition
% >> params.alpha = 1.7; % Specification parameter
% >> params.dir = Direction.HORIZONTAL; % Slant direction
% >> params.transition = 0.25; % Transition width
% >> params.vm = 'd30'; % Order of vanishing moments {0,1,2, 'd##'}
% >> params.sd = [1 1]; % Directions of two triangles
% >> params.kl = [3 3]; % # of zeros at pi and zero
% >> params.isPsa = false; % Selection of cost function
% >> [cost, lppufb, sbsp] = fcn_dirlot_design_fr(params);
%    :
% >> figure(1), dispBasisImages(lppufb)
% >> figure(2)
% >> subplot(2,2,1), freqz2(lppufb(1))
% >> subplot(2,2,2), freqz2(lppufb(2))
% >> subplot(2,2,3), freqz2(lppufb(3))
% >> subplot(2,2,4), freqz2(lppufb(4))
% >> angles = getAngles(lppufb);
% >> mus = getMus(lppufb);
% >> paramMtx = getParameterMatrices(lppufb);
% >>
%
% SVN identifier:
% $Id: fcn_dirlot_design_fr.m 364 2013-01-08 07:08:10Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009-2012, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

%% Parameters
if nargin < 1
    nPoints = [ 128 128 ]; % Frequency grid
    ord = [ 2 2 ]; % Polyphase order
    dec = [ 2 2 ]; % Number of decomposition
    alpha = 1.7; % Specification parameter
    dir = Direction.HORIZONTAL; % Slant direction
    transition = 0.25; % Transition width
    vm = 'd30'; % Degree of vanishing moment {0,1,2, 'd##'}
    sd = [1 1]; % Directions of two triangles for vm2. [{1,-1} {1,-1}]
    kl = [3 3]; % # of zeros at pi and zero.
    isPsa = false;
else
    nPoints = params.nPoints;
    ord = params.ord;
    dec = params.dec;
    alpha = params.alpha;
    dir = params.dir;
    transition = params.transition;
    vm = params.vm;
    sd = params.sd;
    kl = params.kl;   
    isPsa = params.isPsa;
end

%% Instantiation of specification
sbsp = SubbandSpecification(alpha,dir,dec);
sbsp = setTransition(sbsp,transition);
specs = cell(prod(dec),1);
hf = figure;
for idx = 1:prod(dec)
    set(hf,'Name','Pass- and stop-band assignment');
    if isPsa
        [sa,sidx] = getPassStopAssignment(sbsp,nPoints,idx);
        subplot(dec(1),dec(2),sidx)
        imshow(0.5*sa+0.5)
    else
        [sa,sidx] = getAmplitudeSpecification(sbsp,nPoints,idx,kl);
        subplot(dec(1),dec(2),sidx)        
        imshow(0.5*sa)
    end
    title(sidx)    
    specs{sidx} = sa;
end
if isPsa
   spec = PassBandErrorStopBandEnergy(specs);
else
   spec = AmplitudeErrorEnergy(specs);
end

%% Optimization process for basis design
% For PCT, please uncomment the following line
% matlabpool open
if license('test','gads_toolbox') ... % Genetic Algorithm
        && exist('ga','file') == 2
    
    % Instantiation of designer
    designer = LpPuFb2dDesignerFr(dec,ord,spec,vm,@ga);
    
    % Parameter setup
    angles = getAngles(designer);
    popInitRange = [angles(:)-pi angles(:)+pi].';
    if ~isnumeric(vm) || vm > 1
        designer = setSigns4Lambda(designer,sd);
    end
    
    % Option setup
    options = gaoptimset('ga');
    options = gaoptimset(options,'Display','off');
    
    % For PCT, set 'UseParallel' as 'always'
    options = gaoptimset(options,'UseParallel','never');
    options = gaoptimset(options,'PopInitRange',popInitRange);
    options = gaoptimset(options,'PlotFcn',@gaplotbestf);
    
    % First optimization with fixed mus
    isOptMus = false;
    designer = run(designer,options,isOptMus);
    
    % Second optimization with preoptimized mus for a given angles
    isOptMus = true;
    designer = run(designer,options,isOptMus);
    
else % Gradient Descent Algorithm
    
    % Instantiation of designer
    designer = LpPuFb2dDesignerFr(dec,ord,spec,vm);
    
    % Random initialization of parameters
    angles = getAngles(designer);
    angles = angles + pi*randn(size(angles));
    designer = setAngles(designer,angles);
    mus = getMus(designer);
    mus = 2*round(rand(size(mus))) - 1;
    designer = setMus(designer,mus);
    if vm > 1
        designer = setSigns4Lambda(designer,sd);
    end
    
    % Option setup
    optfcn = getOptFcn(designer);
    options = optimset(optfcn);
    options = optimset(options,'Display','off');
    options = optimset(options,'PlotFcn',@optimplotfval);
    
    % Run
    designer = run(designer,options);
end
% For PCT, please uncomment the following line
% matlabpool close

%% Obtain the optimization result
lppufb = getLpPuFb2d(designer);
cost = getCost(designer);
