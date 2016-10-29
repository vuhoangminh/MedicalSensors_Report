function [cost, lppufb, sbsp, spec] = autoDesignFrGa(params)

% Parameters
if nargin < 1
    nPoints = 128*[1 1];
    ord = 2*[ 1 1 ];
    dec = 2*[ 1 1 ];
    alpha = 1.0;
    dir = Direction.HORIZONTAL;
    transition = 0.25;
    if dir == Direction.VERTICAL
        phi = mod(atan(alpha)*180/pi,180);
    else
        phi = mod(atan(1/alpha)*180/pi,180);
    end
    vm = sprintf('d%06.2f',phi);
    display = 'off';
    useParallel = 'never';
    plotFcn = @gaplotbestf;
    populationSize = 20;
    eliteCount = 2;    
    mutationFcn = @mutationgaussian;
    generations = 200;
    stallGenLimit = 100;
    %
    swmus = false;
    split = 'half';
    sd = [1 1];
else
    nPoints = params.nPoints;
    ord = params.ord;
    dec = params.dec;
    alpha = params.alpha;
    dir = params.dir;
    transition = params.transition;
    vm = params.vm;
    display = params.Display;
    useParallel = params.useParallel;
    plotFcn = params.plotFcn;
    populationSize = params.populationSize;
    eliteCount = params.eliteCount;
    mutationFcn = params.mutationFcn;
    generations = params.generations;
    stallGenLimit = params.stallGenLimit;
    %
    swmus = params.swmus;
    split = params.split;
    sd = params.sd;
end

% Specification
sbsp = SubbandSpecification(alpha,dir,dec);
sbsp = setTransition(sbsp,transition);
specPassStopBand = cell(prod(dec));
for idx = 1:prod(dec)
    if strcmp(split,'quarter')
        [psa,sbIdx] = getPassStopAssignmentQuarterSplit(sbsp,nPoints,idx);
    elseif strcmp(split,'half')
        [psa,sbIdx] = getPassStopAssignment(sbsp,nPoints,idx);
    else
        error('Invalid split type');
    end
    specPassStopBand{sbIdx} = psa;
end

% Instantiation of target class
spec = PassBandErrorStopBandEnergy(specPassStopBand);
designer = LpPuFb2dDesignerFr(dec,ord,spec,vm,@ga);

% Parameter setup
angles = getAngles(designer);
popInitRange = [angles(:)-pi angles(:)+pi].';
%
if swmus
    mus = getMus(designer);
    mus = 2*round(rand(size(mus))) - 1;
    designer = setMus(designer,mus);
end
%
if ~isnumeric(vm) || vm > 1
    designer = setSigns4Lambda(designer,sd);
end

options = gaoptimset('ga');
options = gaoptimset(options,'Display',display);
options = gaoptimset(options,'UseParallel',useParallel);
options = gaoptimset(options,'PlotFcn',plotFcn);
options = gaoptimset(options,'PopulationSize',populationSize);
options = gaoptimset(options,'EliteCount',eliteCount);
options = gaoptimset(options,'MutationFcn',mutationFcn);
options = gaoptimset(options,'PopInitRange',popInitRange);
options = gaoptimset(options,'Generations',generations);
options = gaoptimset(options,'StallGenLimit',stallGenLimit);

% First optimization
if swmus
    isOptMus = false;
else
    isOptMus = true;
end
designer = run(designer,options,isOptMus);
lppufb0 = getLpPuFb2d(designer);
cost0 = getCost(designer);
spec0 = getSpec(designer);
disp(cost0);

% Second optimization
isOptMus = true;
designer = run(designer,options,isOptMus);
lppufb1 = getLpPuFb2d(designer);
cost1 = getCost(designer);
spec1 = getSpec(designer);
disp(cost1);

% Selection
if cost0 < cost1
    lppufb = lppufb0;
    cost = cost0;
    spec = spec0;
else
    lppufb = lppufb1;
    cost = cost1;
    spec = spec1;
end
