function [cellgroupsindexes, nGroups, groupedCells] = cellCandidateGrouping(...
    cellcandidates, numNuclei,M,N)
%                 GROUPING OF CELL CANDIDATES
% Groups cell candidates depending on number of cells in clump
% 
% USAGE:
%       [groupsindexes, nGroups, groupedCells] = cellCandidateGrouping(...
%                                           cellcandidates, numNuclei,M,N)
% INPUT:
%                   cellcandidates := Cell containing the binary images of
%                                   cell candidates. 
%                        numNuclei := Number of cells in clump.
%                           [M, N] := image size.
% OUTPUT:
%                    groupsindexes := indexes of candidates that are
%                                   paired.
%                          nGroups := number of groups size(groupsindexes,1)
%                     groupedCells := overlapping of cell candidates by
%                                   groupsindexes.
% 
nCells = size(cellcandidates,1);

if nCells == 1
    fprintf('%s. Only one viable cell candidate found.\n', mfilename);
    cellgroupsindexes = 1;
    nGroups = size(cellgroupsindexes,1);
    groupedCells = cell(nGroups,1);
    groupedCells{1,1} = cellcandidates{1};
elseif nCells == 2
    fprintf('%s. Only two cell candidates found.\n', mfilename);
    cellgroupsindexes = [1 2];
    nGroups = size(cellgroupsindexes,1);
    groupedCells = cell(nGroups,1);
    groupedCells{1,1} = cellcandidates{1} + 2.*cellcandidates{2};
else
    fprintf('%s. Grouping candidates according to groups.\n', mfilename);
    cellgroupsindexes = nchoosek(1:nCells,numNuclei);

    nGroups = size(cellgroupsindexes,1);
    
    groupedCells = cell(nGroups,1);
    for ix=1:nGroups
        groupedCells{ix} = zeros(M,N);
        for jx=1:numNuclei
            groupedCells{ix} = groupedCells{ix} + ...
                jx.*cellcandidates{cellgroupsindexes(ix,jx)};
        end
    end
    
end
