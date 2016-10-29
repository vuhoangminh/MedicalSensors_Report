% MAIN_APSIPA2010DESIGN_GA
%
% SVN identifier:
% $Id: main_apsipa2010design_ga.m 243 2011-11-22 09:12:42Z sho $
%
% Requirements: MATLAB R2008a
%
% Copyright (c) 2009-2010, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%

if ~license('test','gads_toolbox') ...
        || exist('ga','file') ~= 2
    fprintf('Skipped\n\tGA is not available. ... \n');
    return
end

params.transition = 0.25;
params.nPoints = 128*[ 1 1 ];
params.Display = 'final';
params.useParallel = 'always';
params.plotFcn = @gaplotbestf;
params.populationSize = 20;
params.eliteCount = 2;
params.split = 'half';
params.mutationFcn = @mutationgaussian;

nReps = 20;
nNodes = 2;
%{
if license('test','distrib_computing_toolbox') && ...
        exist('matlabpool','file') == 2 && ...
        ~verLessThan('distcomp','4.0')
    eval(sprintf('matlabpool open %d',nNodes));
    isPct = true;
else
    disp('Skipped\n\t MATLABPOOL is not available. ...');
    isPct = false;
end
%}
for iRep=1:nReps
    dec = 2;
    params.dec = dec * [ 1 1 ];
    sidx = 1;
    for swmus = 0:1
        params.swmus = swmus;
        ord = 2;
        params.generations = 200; %dec*dec*(ord+1)*(ord+1)*40;
        params.stallGenLimit = 100; %dec*dec*(ord+1)*(ord+1)*20;
        
        params.ord = ord * [ 1 1 ];
        fprintf('dec=%d, ord=%d\n',dec,ord);
        
        params.alpha = 0.0;
        params.dir = Direction.VERTICAL;
        
        for phi = -45:134
            params.vm = sprintf('d%06.2f',phi);
            params.sd = 1;
            autoUpdateOfDesignFrGa(params);
            params.sd = -1;
            autoUpdateOfDesignFrGa(params);
        end
    end
end

if isPct
    matlabpool close
end
