function [clumpAngleMatrix, clumpBoundary, numPoints] = ...
    computepatchanglegram(clumpBoundaries, whichClump, neighjump)
% COMPUTE SEGMENT ANGLEGRAM
% Compute the anglegram matrix from the adjacent angles to each point in
% the boundary.

