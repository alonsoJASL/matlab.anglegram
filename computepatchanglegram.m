function [patchanglegram, numPoints] = computepatchanglegram(segmentBoundary)
% COMPUTE SEGMENT ANGLEGRAM
% Compute the anglegram matrix from the adjacent angles to each point in
% the boundary.
%

if iscell(segmentBoundary)
    segmentBoundary = segmentBoundary{1};
end
wrapN = @(x, N) (1 + mod(x-1, N));
numPoints = size(segmentBoundary,1);
separationMax=fix(numPoints/2)-2;

patchanglegram = zeros(numPoints,separationMax);
for whichPoint=2:(numPoints-1)
    this = segmentBoundary(whichPoint, :);
    
    for sep=1:(min(whichPoint,numPoints-whichPoint)-1)
        disp([whichPoint sep min(whichPoint,numPoints-whichPoint)]);
        previous = segmentBoundary(whichPoint-sep,:);
        next = segmentBoundary(whichPoint+sep,:);
        
        % centered around this point
        thisC = [previous - this;
            next - this];
        
        theta = wrapN(round(rad2deg(angle(thisC(:,2)+thisC(:,1).*1i))),360);
        anglepointsep = wrapN(theta(1)-theta(2),360);
        if  anglepointsep < 340
            patchanglegram(whichPoint,sep) = anglepointsep;
        elseif sep < separationMax/2
            patchanglegram(whichPoint,sep) = anglepointsep;
        end
    end
end



