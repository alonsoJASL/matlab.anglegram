function [cellcandidates, cellboundaries, tsegments] = getCellCandidatesFromSegments(...
    candieslocations, currentboundary, currentclump, nuclei)
%           GET CELL CANDIDATES FROM BOUNDARY SEGMENTS 
% From a clump boundary and junctions, create segments that go from
% junction to junction and create appropriate candidates for cells. 
% 
% USAGE:
%     [cellcandidates, cellboundaries, segments] = getCellCandidatesFromSegments(...
%    candieslocations, currentboundary, currentclump, nuclei)
%
% INPUT: 
%                junctionIndexes := Junction locations on currentboundary.
%                currentboundary := Boundary coordinates.
%                   currentclump := Binary image with clump of
%                                 currentboundary
%                         nuclei := (optional) Binary imageof nuclei.
% OUTPUT:
%                 cellcandidates := Cell containing all the plausible
%                                 combinations of cell candidates coming
%                                 from the pairing of junctions and line
%                                 segments.
%                 cellboundaries := Cell containing the boundaries 
%                                 corresponding to each cellcandidate.
%                segmentsIndexes := Cell containing the boundaries 
%                                 corresponding to each segmentsIndexes.
% 

% GENERATE (crude) CELL CANDIDATES.
sortedlocations = sort(candieslocations);
numPoints = size(currentboundary,1);
M = size(currentclump,1);
N = size(currentclump,2);

nSegm = length(sortedlocations);
segments = cell(nSegm,1);
tsegs = cell(nSegm,1);
T=1:numPoints;
cellcandidates = cell(nSegm,1);
for ix=1:nSegm
    if ix<nSegm
        tsegs{ix} = sortedlocations(ix):sortedlocations(ix+1);
    else
        tsegs{ix} = [sortedlocations(ix):numPoints 1:sortedlocations(1)];
    end
    
    segments{ix} = currentboundary(tsegs{ix},:);
    
    cellcandidates{ix} = poly2mask(segments{ix}(:,2),segments{ix}(:,1), M, N);
    %     plotBoundariesAndPoints(cellcandidates{ix},thisBoundy,candies);
    %     pause;
end


segindx = nchoosek(1:nSegm,2);
nPairs = size(segindx,1);
cellcandidatestwo = [];
pairsseg = [];
tpairs = [];

if nPairs>1
    %logline(ST.name,'info','Taking pairs of segments into account.');
    cellcandidatestwo = cell(nPairs,1);
    pairsseg = cell(size(segindx,1),1);
    tpairs = cell(size(segindx,1),1);
    for ix=1:size(segindx,1)
        tpairs{ix} = [tsegs{segindx(ix,1)} tsegs{segindx(ix,2)}];
        pairsseg{ix} = [segments{segindx(ix,1)};segments{segindx(ix,2)}];
        cellcandidatestwo{ix} = poly2mask(pairsseg{ix}(:,2),...
            pairsseg{ix}(:,1),M, N);
        %         plotBoundariesAndPoints(cellcandidatestwo{ix},thisBoundy,candies);
        %         pause;
    end
end

thrindx = nchoosek(1:nSegm,3);
nTriads = size(thrindx,1);
cellcandidatesthree = [];
triadsseg = [];
tthrees = [];

if nTriads>1
    %logline(ST.name,'info','Taking triads of segments into account.');
    cellcandidatesthree = cell(nTriads,1);
    triadsseg = cell(size(thrindx,1),1);
    tthrees = cell(size(thrindx,1),1);
    for ix=1:size(thrindx,1)
        tthrees{ix} = [tsegs{thrindx(ix,1)} tsegs{thrindx(ix,2)}];
        triadsseg{ix} = [segments{thrindx(ix,1)};segments{thrindx(ix,2)};...
            segments{thrindx(ix,3)}];
        cellcandidatesthree{ix} = poly2mask(triadsseg{ix}(:,2),...
            triadsseg{ix}(:,1),M, N);
        %         plotBoundariesAndPoints(cellcandidatestwo{ix},thisBoundy,candies);
        %        s pause;
    end
end

cellcandidates = vertcat(cellcandidates,cellcandidatestwo, cellcandidatesthree);
cellboundaries = vertcat(segments,pairsseg, triadsseg);
tsegments = vertcat(tsegs, tpairs,tthrees);


% RULE 0: Compare candidates with the nuclei
if ~isempty(nuclei)
    %logline(ST.name,'info',...
    fprintf('%s. Image of nuclei found: selecting cell candidates based on nuclei.\n',...
        mfilename);
    nucleiClumps = nuclei.*currentclump;
    re = regionprops(nucleiClumps>0);
    maxnuclei = max([re.Area]);
    meannuclei = mean([re.Area]);
    numNuclei = length(re);
    
    if size(cellcandidates,1)>numNuclei
        %logline(ST.name,'info',...
        fprintf('%s. More cell candidates than nuclei found: discarding obvious.',...
            mfilename);
        for ix=1:size(cellcandidates,1)
            A = nucleiClumps.*cellcandidates{ix};
            regs = regionprops(A>0);
            
            if isempty(regs)
                cellcandidates{ix} = [];
                cellboundaries{ix} = [];
                tsegments{ix} = [];
            elseif length(regs)>2
                cellcandidates{ix} = [];
                 cellboundaries{ix} = [];
                tsegments{ix} = [];
            elseif length(regs)==2
                if sum(A(:))>1.01*maxnuclei || sum(A(:))<0.6*maxnuclei
                    cellcandidates{ix} = [];
                     cellboundaries{ix} = [];
                tsegments{ix} = [];
                end
            else
                if sum(A(:))<0.6*meannuclei
                    cellcandidates{ix} = [];
                     cellboundaries{ix} = [];
                tsegments{ix} = [];
                end
            end
        end
        cellcandidates=cellcandidates(~cellfun('isempty',cellcandidates));
        cellboundaries=cellboundaries(~cellfun('isempty',cellboundaries));
        tsegments=tsegments(~cellfun('isempty',tsegments));
    end
end