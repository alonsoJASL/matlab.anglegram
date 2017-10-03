% script: Anglegram stats
% 
%% Initialisation
scr_genericshapes;

%% 
ix=randi(size(images.data,4));
offst=32;
A = images.data(:,1:offst,1,ix);
boundy = images.boundies{ix}{1};
thr=1;

anglesumve = max(A,[],2);
[minval, minlocations] = findpeaks(-[anglesumve;anglesumve]);
minval = -minval;
%
[minval, ic,~] = unique(minval, 'stable');
minlocations = wrapN(minlocations(ic), 64);

cornyLoc = fix((minlocations./64)*size(boundy,1));
cornies = boundy(cornyLoc,:);
%
figure(1)
clf
subplot(2,4,[1 2 5 6])
plotBoundariesAndPoints(zeros(512), images.boundies{ix}, cornies);
title(strcat('ix=', num2str(ix), 32, 'type-',myclass{images.labels(ix)}));

subplot(2,4,3)
imagesc(A);
subplot(2,4,4)
imagesc(imquantize(A, multithresh(A,thr)));
subplot(2,4,[7 8])
plot(1:64, anglesumve, wrapN(minlocations, length(anglesumve)), minval, 'd');
plotHorzLine(1:64, [mean(anglesumve) mean(anglesumve)-std(anglesumve)]);