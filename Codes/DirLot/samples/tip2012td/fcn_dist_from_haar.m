function cost = fcn_dist_from_haar(phi,ss,theta)

Edirlot = fcn_ezdirlottvm(phi,ss,theta);
ord = getOrd(Edirlot);
Ehaar = LpPuFb2dFactory.createLpPuFb2d(0,[2 2],ord);

cost = 0;
for idx = 1:4
    h = Ehaar(idx);
    f = Edirlot(idx);
    cost = cost+sum((h(:)-f(:)).^2);
end
