% Quickly generate two ellipses for your overlapping needs.


a = 40; b = 120;
X0 = 128; Y0 = 128;
phi0 = 0;

[bw0, boundy0, eS0] = createEllipse(X0, Y0, a, b, phi0);

% Change the values below for a different example.
Xi = 30;
phiX = 40;

[bw1, boundy1, es1] = createEllipse(X0+Xi,Y0, a, b, phiX);
singleClump = bw0 + 2.*bw1;

BW = singleClump>0;

clc;
fprintf('%s: Done generating ellipses with Xi=%d and phiX=%d \n', ...
    mfilename, Xi, phiX);