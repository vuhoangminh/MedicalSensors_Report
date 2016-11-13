function [E, chkvmd] = fcn_ezdirlottvm(phi,ss,theta)
%
% SVN identifier:
% $Id: fcn_ezdirlottvm.m 366 2013-01-09 06:17:42Z sho $
%
% Requirements: MATLAB R2011b
%
% Copyright (c) 2012, Shogo MURAMATSU
%
% All rights reserved.
%
% Contact address: Shogo MURAMATSU,
%                Faculty of Engineering, Niigata University,
%                8050 2-no-cho Ikarashi, Nishi-ku,
%                Niigata, 950-2181, JAPAN
%
phi = mod(phi+pi/4,pi)-pi/4;
dec = [2 2];
if phi >= -pi/4 && phi < pi/4 % d = x
    b = -[tan(phi) ; 1]/2;
    ord = [0 2];
elseif phi >= pi/4 && phi < 3*pi/4 % d = y
    b = -[1 ; cot(phi)]/2;
    ord = [2 0];
else
    error('Unexpected error occured.');
end

if nargin == 1 || (isempty(ss) && isempty(theta))
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
end

normb = norm(b);
G = GivensRotations();
lambda = (-1)^ss(1)*(acos(1-(normb^2)/2)+acos(normb/2));

% W0
W0 = diag([1 (-1)^ss(2)]);
G = setMatrix(G,W0);
mus(:,1) = getMus(G);
ang(1,1) = getAngles(G);

% U0
P0 = GivensRotations();
P0 = setProjectionOfVector(P0,b);
P0 = double(P0);
U0 = diag([1 (-1)^ss(3)])...
    *[cos(lambda) -sin(lambda) ; sin(lambda) cos(lambda) ]...
    *P0;
G = setMatrix(G,U0);
mus(:,2) = getMus(G);
ang(1,2) = getAngles(G);

% U1 
a = [ 1 ; 0 ];
P1 = GivensRotations();
P1 = setProjectionOfVector(P1,-a-U0*b);
P1 = double(P1);
U1 = diag([1 (-1)^ss(4)])*P1;
G = setMatrix(G,U1);
mus(:,3) = getMus(G);
ang(1,3) = getAngles(G);

%U2
U2 = diag([1 (-1)^ss(5)])...
    *[cos(theta) -sin(theta) ; sin(theta) cos(theta) ];
G = setMatrix(G,U2);
mus(:,4) = getMus(G);
ang(1,4) = getAngles(G);

chkvmd = norm(a+U1*a+U1*U0*b);
if chkvmd > 1e-15
    error('chkvmd violated (%g)',chkvmd)
end
E = LpPuFb2dFactory.createLpPuFb2d(0, dec, ord, ang, mus);

