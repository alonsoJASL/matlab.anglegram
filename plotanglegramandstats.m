function plotanglegramandstats(ag, ch, options)
% PLOT ANGLEGRAM AND ANGLE SUMMARY VECTOR. Display the anglegram in the XY
% plane as well the anglesummaryvector needed.
%
% USAGE: plotanglegramandstats(ag, ch, options)
% 
% INPUT: 
%           ag := anglegram matrix
%           ch := structure containing (at least): 
%               .angleSummaryVector: vector containing the projection of
%               ag's columns
%               .meanAM: mean(angleSummaryVector)
%               .stdAM: std(angleSummaryVector)
%               .intensityLocations: locations of junctions
%               .intensityPeaks: value of angleSummaryVector at junction
%               position
%

if nargin < 3
    cmap = parula;
    fontsize = 20;
else
    [cmap, fontsize] = getoptions(options);
end

[XX, YY] = meshgrid(1:size(ag,2), 1:size(ag,1));
ZZ = ones(size(ag));

npoints = length(ch.angleSummaryVector);
lowval = min(ch.angleSummaryVector);

surf(XX, YY, lowval.*ZZ, ag, 'EdgeColor', 'none');
ylabel('Points along boundary', 'FontSize', fontsize);
xlabel('Separation', 'FontSize', fontsize);
zlabel('Angle (DEG)', 'FontSize', fontsize);
%set(gca, 'FontSize', 14)

colormap(cmap);
hold on
plot3(ones(1,npoints), 1:npoints, ch.angleSummaryVector, ...
    'k', 'LineWidth', 2.5);
if ~isempty(ch.intensityLocations)
    n = length(ch.intensityLocations);
    plot3(ones(1,n), ch.intensityLocations, ch.intensityPeaks, ...
        'd', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'm', ...
        'MarkerSize', 10, 'LineWidth', 1.5);
    plot3([1 1], [1 npoints], [ch.meanAM ch.meanAM],'LineWidth', 3);
    plot3([1 1], [1 npoints], ...
        [ch.meanAM+0.75*ch.stdAM ch.meanAM+0.75*ch.stdAM], ...
        'LineWidth', 3);
end
axis tight;
%axis equal;
axis ij;
set(gcf, 'Position', [2   562   958   434]);
view(-59.1, 16);
end

function [cmap] = getoptions(s)
% 
cmap = parula;
fintsize = 20;
fnames = fieldnames(s);
for ix=1:length(fnames)
    switch fnames{ix}
        case 'cmap'
            cmap = s.(fname{ix});
        case 'fontsize'
            fontsize = s.(fname{ix});
        otherwise 
            fprintf('%s. ERROR. Unrecognised option: %s', ...
                mfilename, upper(fname{ix}));
    end
end
end