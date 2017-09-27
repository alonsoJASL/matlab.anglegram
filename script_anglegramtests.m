% Script file: SIMPLE ANGLEGRAM TESTS
%
%% ELLIPSE CREATION
tidy;
a = 40;
b = 120;

X0 = 128;
Y0 = 128;
phi0 = 0;

Xi = 10:5:160;
phiX = 10:5:90;

[bw0, boundy0, eS0] = createEllipse(X0, Y0, a, b, phi0);

fid = fopen('./newanglegramtests.txt', 'w');
fprintf(fid, 'NEW ANGLEGRAM (soc called) ACCURACY TESTS\n');
%%

for ix=1:length(Xi)
    for jx=1:length(phiX)
        [thisBW, ~, ~] = createEllipse(X0+Xi(ix),Y0, a, b, phiX(jx));
        
        boundy = bwboundaries(bitor(bw0, thisBW));
        [anglegram, agh] = computeMultiAnglegram(boundy);
        
        %[candies, ch] = computeCandidatePoints(anglegram, boundy{1}, 150, 1, 'max');
        [candies, ch] = computeCandidatePoints(agh.oganglegram, boundy{1}, 150, 7, 'max');
        
        nCandies = size(candies,1);
        [~,nNew] = bwlabeln(anglegram>180);
        
        fprintf(fid, 'separation(Xi): %d | angle(phiX): %d || og: %d | new:%d\n',...
            Xi(ix), phiX(jx), nCandies, nNew);
        
%         subplot(121)
%         plotBoundariesAndPoints(bw0+thisBW, boundy, candies);
%         subplot(122)
%         imagesc(anglegram>180); title('With new anglegram');
%         pause(0.05);
    end
end


fclose(fid);


