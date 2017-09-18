% Script file: SIMPLE ANGLEGRAM TESTS
% 
%% ELLIPSE CREATION
tidy;
a = 40;
b = 120;

X0 = 128;
Y0 = 128;
phi0 = 0;

Xi = 20;
phiX = 30;

[bw0, boundy0, eS0] = createEllipse(X0, Y0, a, b, phi0);
[thisBW, ~, ~] = createEllipse(X0+Xi,Y0, a, b, phiX);

boundy = bwboundaries(bitor(bw0, thisBW));
[anglegram, agh] = computeMultiAnglegram(boundy);


figure(1)
plotBoundariesAndPoints(bw0+thisBW, boundy);
figure(2)
imagesc(anglegram)

