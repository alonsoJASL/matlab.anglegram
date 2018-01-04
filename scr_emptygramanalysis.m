% EMPTY ANGLEGRAM ANALYSIS
% A script to determine whether an anglegram generated from the cell
% candidate pieces of a clump can be reconstructed into an approximate
% accurate shape
%
%
%% init
tidy; 
gen2ellipsesScript;

%% gen easy cells that overlap
boundy=bwboundaries(BW);

%% get ag
[ag, aghs] = computeMultiAnglegram(boundy{1});
[c, ch] = computeCandidatePoints(aghs.oganglegram, boundy{1});

%% get cell candidates
cl = ch.intensityLocations; % candidate locations
[bwcells, boundcells, tsegs] = getCellCandidatesFromSegments(cl, boundy{1}, BW, []);

%% Group cell candidates
% [cellgrix, nG, groupedCells] = cellCandidateGrouping(...
%     bwcells, 2, size(singleClump,1), size(singleClump,2));

%% calculate emptygram

