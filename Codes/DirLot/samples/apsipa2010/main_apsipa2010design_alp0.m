% MAIN_APSIPA2010DESIGN_ALP0
%
% SVN identifier:
% $Id: main_apsipa2010design_alp0.m 91 2011-03-02 04:06:12Z sho $
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

nPoints = [128 128];
transition = 0.25;
options = optimset(@fminunc);
options = optimset(options,'Display','iter');
options = optimset(options,'PlotFcn',@optimplotfval);

for iIter = 1:20
    for phid = -45:134 % trend direction
        phi = phid * pi/180.0;
        if phi >=-pi/4 && phi < pi/4
            alpha = 0;%tan(phi);
            direction = Direction.VERTICAL;
            ord = [0 2];
        elseif phi >=pi/4 && phi < 3*pi/4
            alpha = 0;%cot(phi);
            direction = Direction.HORIZONTAL;
            ord = [2 0];
        else
            error('Unexped error occured.');
        end
        
        sbsp = SubbandSpecification(alpha,direction);
        sbsp = setTransition(sbsp,transition);
        specPassStopBand = cell(4);
        for idx = 1:4
            [psa,sbIdx] = getPassStopAssignment(sbsp,nPoints,idx);
            specPassStopBand{sbIdx} = psa;
        end
        spec = PassBandErrorStopBandEnergy(specPassStopBand);
        
        % File name
        filename = sprintf(...
            'data%dx%di%4.2f/fmin0/lppufb2dDec22Ord%d%dAlp%3.1fDir%dVm%s%s.mat',...
            nPoints(1),nPoints(2),transition,ord(1),ord(2),...
            alpha,direction,num2str(sprintf('d%06.2f',180*phi/pi)),'h');
        
        % Load data
        lppufb = [];
        cost = Inf;
        if exist(filename,'file')==2
            comstr = sprintf('load %s lppufb cost\n',filename);
            disp(comstr);
            eval(comstr);
        end
        
        precost = Inf;
        for s = 0:31 % parameter sn
            ss = [ mod(s,2);
                mod(fix(s/2),2) ;
                mod(fix(s/4),2) ;
                mod(fix(s/8),2) ;
                mod(fix(s/16),2) ];
            
            theta = fminunc(@(x) getCost(spec,ezdirlot(phi,ss,x)),...
                pi*randn(),options);
            E = ezdirlot(phi,ss,theta);
            curcost = getCost(spec,E);
            if precost > curcost
                precost = curcost;
                lppufb = E;
            end
        end
        
        % Save data
        if cost > precost
            cost = precost;
            comstr = sprintf('save %s lppufb cost sbsp spec\n',filename);
            eval(comstr);
            disp('Updated!');
            disp(comstr);
            figure(1),
            dispBasisImages(lppufb)
            drawnow;
            figure(2),
            subplot(2,2,1),freqz2(lppufb(1))
            subplot(2,2,2),freqz2(lppufb(2))
            subplot(2,2,3),freqz2(lppufb(3))
            subplot(2,2,4),freqz2(lppufb(4))
            drawnow;
            
        end
    end
end
