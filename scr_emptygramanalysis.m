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
[bwcells, boundcells, ~] = getCellCandidatesFromSegments(cl, boundy{1}, BW, []);

%% calculate emptygram

