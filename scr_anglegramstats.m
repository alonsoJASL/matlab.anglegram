% script: Anglegram stats
%
%% Initialisation
scr_genericshapes;

%% Compute corners
thr = 1;

jx=1;
kx=1;
opts.agsize = [64 64];
opts.offst = opts.agsize(1)/2;
opts.statsfname = 'max';

corrects = zeros(size(images.data,4),1);
classmistakes = zeros(size(images.data,4),1);
%ix=randi(size(images.data,4));
for ix=1:size(images.data,4)

A = images.data(:,1:opts.offst,1,ix);
boundy = images.boundies{ix}{1};
    
[cornies, cornyloc, ch] = computeCorners(A, boundy, opts);
numcorners(ix) = length(cornyloc);
corrects(ix) = strcmp(myclass{images.labels(ix)}, ch.guesstype);
if corrects(ix) == false
    classmistakes(ix) = images.labels(ix);
end
end
%%
figure(1)
clf
subplot(2,4,[1 2 5 6])
plotBoundariesAndPoints(zeros(512), boundy, cornies);
title(strcat('ix=', num2str(ix), 32, 'type-',myclass{images.labels(ix)}));

subplot(2,4,3)
imagesc(A);
subplot(2,4,4)
imagesc(imquantize(A, multithresh(A,thr)));
subplot(2,4,[7 8])
plot(1:64, ch.anglesumve, ch.minlocations, ch.minval, 'd');
plotHorzLine(1:64, [ch.mam ch.mam-ch.stam]);
ylim([50 200]);
if length(ch.minval)>1
title(['Our guess:' 32 ch.guesstype]);
end

[hd, hdloc] = findpeaks(diff(ch.anglesumve));
[ld, ldloc] = findpeaks(-diff(ch.anglesumve));

figure(2)
clf
 plot(1:63, diff(ch.anglesumve), hdloc, hd, 'x', ldloc, -ld, 'o');
hold on
stem(ch.minlocations, ch.minval)