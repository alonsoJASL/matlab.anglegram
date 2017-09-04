function [clumpAngleMatrix, clumpBoundary, numPoints] = ...
    computeAngleMatrix(clumpBoundaries, whichClump, neighjump)
%               COMPUTE ANGLEGRAM MATRIX
% Compute the anglegram matrix from the adjacent angles to each point in
% the boundary.
%
% USAGE:
%      [anglegram, clumpBoundary, N] = computeAngleMatrix(boundaries, indx)
%
% INPUT:
%               boundaries := (cell) Contains all the overlapping
%                           boundaries.
%                     indx := selects which boundaries{indx} to use for the
%                           analysis.
% OUTPUT:
%                anglegram := anglegram matrix corresponding to
%                           boundaries{indx}.
%             clumpBoundary = boundaries{indx}.
%                        N := size(clumpBoundary,1)
%
%

if nargin < 3
    neighjump = 1;
end

if whichClump > length(clumpBoundaries)
    disp('[computeAngleMatrix].ERROR: Wrong boundary index specified.');
    angleDistro = [];
    candidateLocations = [];
    clumpAngleMatrix = [];
    return;
else
    thisClumpIndx = whichClump; % index for the boundary to analyse.
    clumpBoundary = clumpBoundaries{thisClumpIndx}(1:end-1,:);

    numPoints = size(clumpBoundary,1);

    separationMax=fix(numPoints/2)-2;
    clumpAngleMatrix = zeros(numPoints,separationMax);

    % wrap around index for taking the points
    wrapN = @(x, N) (1 + mod(x-1, N));

    tic;
        for whichPoint=1:numPoints
            this = clumpBoundary(whichPoint, :);

            for sep=1:neighjump:separationMax
                previous = clumpBoundary(wrapN(whichPoint-sep,numPoints),:);
                next = clumpBoundary(wrapN(whichPoint+sep,numPoints),:);

                % centered around this point
                thisC = [previous - this;
                    next - this];

                theta = wrapN(round(rad2deg(angle(thisC(:,2)+thisC(:,1).*1i))),360);
                anglepointsep = wrapN(theta(1)-theta(2),360);
                if  anglepointsep < 340
                    clumpAngleMatrix(whichPoint,sep) = anglepointsep;
                elseif sep < separationMax/2
                    clumpAngleMatrix(whichPoint,sep) = anglepointsep;
                end
            end
        end

    t1 = toc;
    fprintf('%s: INFO. Working with boundaries and angles: TIME=%f\n', ...
        mfilename, t1);
    % GET THE BREAKING POINT CANDIDATES PER POINT.
end
