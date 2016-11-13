function [E, normBarX, lambda, chkvm2, vecs, barX] = eznsgenlot22(phi)
%
idxW0   = 1;
idxU0   = 2;
idxUx1  = 3;
idxUx2  = 4;
idxBarU = 4;
idxUy1  = 5;
idxUy2  = 6;
%
if nargin == 0
    phi = 0;
else
    phi = mod(phi+pi/4,pi)-pi/4;
end
dec = [2 2];
ord = [2 2];
G = GivensRotations();
a = [ 1; 0];
muLmd = 1;
%
if phi >= -pi/4 && phi < pi/4 % d = x
    
    b = -[tan(phi) ; 1]/2;
    
    % barU
    barU = [
        1 sqrt(15) ;
        sqrt(15) -1
        ]/4;
    G = setMatrix(G,barU);
    mus(:,idxBarU) = getMus(G);
    ang(1,idxBarU) = getAngles(G);
    
    % Uy1
    Uy1  = [
        -7 sqrt(15) ;
        -sqrt(15) -7
        ]/8;    
    G = setMatrix(G,Uy1);
    mus(:,idxUy1) = getMus(G);
    ang(1,idxUy1) = getAngles(G);
    
    % barX
    barX = tan(phi)*(barU.')*(a+(Uy1.')*a)+b;
    normBarX = norm(barX);
    if normBarX > 2
        error('normBarX violated (%g)',normBarX)
    end
    lambda = muLmd*(acos(1-(normBarX^2)/2)+acos(normBarX/2));
    
    % W0
    W0  = diag([1 -1]);
    G = setMatrix(G,W0);
    mus(:,idxW0) = getMus(G);
    ang(1,idxW0) = getAngles(G);
    
    % U0
    muU0 = 1;
    P0 = GivensRotations();
    P0 = setProjectionOfVector(P0,barX);
    P0 = double(P0);
    U0 = diag([1 muU0])...
        *[cos(lambda) -sin(lambda) ; sin(lambda) cos(lambda) ]...
        *P0;
    G = setMatrix(G,U0);
    mus(:,idxU0) = getMus(G);
    ang(1,idxU0) = getAngles(G);
    
    % Ux1
    muUx1 = 1;
    P1 = GivensRotations();
    P1 = setProjectionOfVector(P1,-a-U0*barX);
    P1 = double(P1);
    Ux1 = diag([1 muUx1])*P1;
    G = setMatrix(G,Ux1);
    mus(:,idxUx1) = getMus(G);
    ang(1,idxUx1) = getAngles(G);
    
    % Ux2
    Ux2 = barU*(Ux1*U0).';
    G = setMatrix(G,Ux2);
    mus(:,idxUx2) = getMus(G);
    ang(1,idxUx2) = getAngles(G);
    
    % Uy2
    Uy2  = diag([1 -1]);
    G = setMatrix(G,Uy2);
    mus(:,idxUy2) = getMus(G);
    ang(1,idxUy2) = getAngles(G);
    
elseif phi >= pi/4 && phi < 3*pi/4 % d = y
    
    b = -[1 ; cot(phi)]/2;
    
    % U0
    U0 = [
        -sqrt(15) 1 ;
        -1 -sqrt(15)
        ]/4;
    G = setMatrix(G,U0);
    mus(:,idxU0) = getMus(G);
    ang(1,idxU0) = getAngles(G);
    
    % Ux1
    Ux1 = [
        -7 -sqrt(15);
        sqrt(15) -7
        ]/8;
    G = setMatrix(G,Ux1);
    mus(:,idxUx1) = getMus(G);
    ang(1,idxUx1) = getAngles(G);
    
    % barX
    barX = cot(phi)*(a+Ux1*a)+Ux1*U0*b;
    normBarX = norm(barX);
    if normBarX > 2
        error('normBarX violated (%g)',normBarX)
    end
    lambda = muLmd*(acos(1-(normBarX^2)/2)+acos(normBarX/2));
    
    % W0
    W0  = diag([1 -1]);
    G = setMatrix(G,W0);
    mus(:,idxW0) = getMus(G);
    ang(1,idxW0) = getAngles(G);
    
    % Ux2
    muUx2 = -1;
    P0 = GivensRotations();
    P0 = setProjectionOfVector(P0,barX);
    P0 = double(P0);
    Ux2 = diag([1 muUx2])...
        *[cos(lambda) -sin(lambda) ; sin(lambda) cos(lambda) ]...
        *P0;
    G = setMatrix(G,Ux2);
    mus(:,idxUx2) = getMus(G);
    ang(1,idxUx2) = getAngles(G);
    
    % Uy1
    muUy1 = 1;
    P1 = GivensRotations();
    P1 = setProjectionOfVector(P1,-a-Ux2*barX);
    P1 = double(P1);
    Uy1 = diag([1 muUy1])*P1;
    G = setMatrix(G,Uy1);
    mus(:,idxUy1) = getMus(G);
    ang(1,idxUy1) = getAngles(G);
    
    % Uy2
    Uy2  = diag([1 -1]);
    G = setMatrix(G,Uy2);
    mus(:,idxUy2) = getMus(G);
    ang(1,idxUy2) = getAngles(G);
else
    error('Unexpected error occured.');
end

vecs(:,1) = sin(phi)*a;
vecs(:,2) = sin(phi)*(Uy1).'*a;
vecs(:,3) = cos(phi)*Ux2*a;
vecs(:,4) = cos(phi)*Ux2*Ux1*a;
vs = -Ux2*Ux1*U0*[sin(phi); 0]/2;
vc = -Ux2*Ux1*U0*[0; cos(phi)]/2;
vecs(:,5) = vs + vc;

vs = sum(vecs(:,1:2),2)+vs;
vc = sum(vecs(:,3:4),2)+vc;
chkvm2 = norm(vs)+norm(vc);
if chkvm2 > 1e-15
    error('chkvm2 violated (%g)',chkvm2)
end
E = LpPuFb2d(dec, ord, ang, mus, 0);