function [cost, lppufb] = autoUpdateOfDesignFrGa(params)

if nargin < 1
    params.nPoints = 128*[ 1 1 ];
    params.ord = 2 * [ 1 1 ];
    params.dec = 2 * [ 1 1 ];
    params.alpha = 1.0;
    params.dir = Direction.VERTICAL;
    params.transition = 0.25;
    if params.dir == Direction.VERTICAL
        phi = mod(atan(params.alpha)*180/pi,180);
    else
        phi = mod(atan(1/params.alpha)*180/pi,180);
    end
    params.vm = sprintf('d%06.2f',phi);
    params.Display = 'iter';
    params.useParallel = 'always';   
    params.plotFcn = @gaplotbestf;
    params.populationSize = 20;
    params.eliteCount = 2;
    params.mutationFcn = @mutationgaussian;
    params.generations = 200;
    params.stallGenLimit = 100;
    %
    params.swmus = true;
    params.split = 'half';
    params.sd = [1 1];
end

% File name
filename = sprintf(...
    'data%dx%di%4.2f/ga/lppufb2dDec%d%dOrd%d%dAlp%3.1fDir%dVm%s%s.mat',...
    params.nPoints(1),params.nPoints(2),params.transition,...
    params.dec(1),params.dec(2),params.ord(1),params.ord(2),...
    params.alpha,params.dir,num2str(params.vm),params.split(1));

% Load data 
lppufb = [];
if exist(filename,'file')==2
    comstr = sprintf('load %s lppufb cost sbsp spec\n',filename);
    disp(comstr);
    eval(comstr);
    if abs(cost - getCost(spec,lppufb))/cost > 1e-10 %#ok
        fprintf('Illeagal cost. File will be removed. %f %f \n',...
            cost, getCost(spec,lppufb));
        comstr = sprintf('delete %s\n',filename);
        disp(comstr);
        eval(comstr);
       precost = Inf;
    else
       precost = cost; 
    end 
else
    precost = Inf;
end


% Create tasks
[cost,lppufb,sbsp,spec] = autoDesignFrGa(params); %#ok

% Show basis images
figure(1)
dispBasisImages(lppufb);

% Show amp res
figure(2)
freqz2(lppufb(1));

% Save data
if cost < precost
    if abs(cost-getCost(spec,lppufb))/cost > 1e-10
       fprintf('Illeagal cost. File will not be updated. %f %f \n',...
           cost, getCost(spec,lppufb));
    else
       comstr = sprintf('save %s lppufb cost sbsp spec\n',filename);
       eval(comstr);
       disp('Updated!');
       disp(comstr);
    end
end
% Save data

