function plotagsummaryonshape(image, XY, ch, options)
% PLOT ANGLE SUMMARY VECTOR ON SHAPE. Display the anglegram in the XY
% plane as well the anglesummaryvector needed.
%
%

if nargin < 4
    cmap = parula;
    fontsize = 20;
    xlimits = [1 size(image,2)];
    ylimits = [1 size(image,1)];
else
    [cmap, fontsize, xlimits, ylimits] = getoptions(options);
    if xlimits==0; xlimits = [1 size(image,2)]; end
    if ylimits==0; ylimits = [1 size(image,1)]; end
end

if ~iscell(XY)
    XY = {XY};
end

if size(XY{1},1)~=length(ch.angleSummaryVector)
    XY{1} = imresize(XY{1}, [length(ch.angleSummaryVector) size(XY{1},2)]);
end

[XX, YY] = meshgrid(1:size(image,2), 1:size(image,1));
ZZ = ones(size(image));

npoints = length(ch.angleSummaryVector);
lowval = min(ch.angleSummaryVector);

surf(XX, YY, lowval.*ZZ, image, 'EdgeColor', 'none');
zlabel('Angle (DEG)', 'FontSize', fontsize);
%set(gca, 'FontSize', 14)

colormap(cmap);
hold on
plot3(XY{1}(:,2), XY{1}(:,1), ch.angleSummaryVector, 'k-', 'LineWidth', 2.5);
if ~isempty(ch.intensityLocations)
    n = length(ch.intensityLocations);
    for jx=1:n
        plot3(XY{1}(ch.intensityLocations(jx),2).*[1 1],...
            XY{1}(ch.intensityLocations(jx),1).*[1 1],...
            [lowval ch.intensityPeaks(jx)], ...
            ':m', 'Marker' ,...
            'd', 'MarkerEdgeColor', 'm', 'MarkerFaceColor', 'none', ...
            'MarkerSize', 8, 'LineWidth', 2.2);
    end
%     plot3(XY{1}(:,2), XY{1}(:,1), ...
%         ch.meanAM.*ones(size(XY{1}, 1),1),...
%         'LineWidth', 1.5);
%     plot3(XY{1}(:,2), XY{1}(:,1), ...
%         (ch.meanAM+0.75*ch.stdAM).*ones(size(XY{1}, 1),1), ...
%         'LineWidth', 1);
    plot3(XY{1}(:,2), XY{1}(:,1), ...
        lowval.*ones(size(XY{1}, 1),1),...
        'k', 'LineWidth', 1);
    plot3(XY{1}(ch.intensityLocations,2),...
        XY{1}(ch.intensityLocations,1),...
        ch.intensityPeaks, ...
        'd', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'm', ...
        'MarkerSize', 8, 'LineWidth', 2.2);
end
axis tight;
%axis equal;
axis ij;
xlim(xlimits);
ylim(ylimits);
%set(gcf, 'Position', [2   562   958   434]);
view(56.9, 36);
end

function [cmap, fontsize, xlimits, ylimits] = getoptions(s)
%
cmap = parula;
fontsize = 20;
xlimits = 0;
ylimits = 0;
fnames = fieldnames(s);
for ix=1:length(fnames)
    switch fnames{ix}
        case 'cmap'
            cmap = s.(fnames{ix});
        case 'fontsize'
            fontsize = s.(fnames{ix});
        case 'xlimits'
            xlimits = s.(fnames{ix});
        case 'ylimits'
            ylimits = s.(fnames{ix});
        otherwise
            fprintf('%s. ERROR. Unrecognised option: %s', ...
                mfilename, upper(fnames{ix}));
    end
end
end