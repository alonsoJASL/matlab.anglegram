function plotProjectionPeaks(ag, hh)
% PLOT PROJECTION FOR PEAKS.
% ag - anglegram
% hh - handles for corner detection.
% 

n=size(ag,1);
t=linspace(1,n,64);

%clf;
plot(t, hh.anglesumve, t(hh.minlocations), hh.minval,'d',...
    'markersize', 10, 'linewidth',2);
plotHorzLine(t,[hh.mam (hh.mam-hh.stam)]);

ylim([90 200]);
xlim([0 n]);
ylabel('Min angles per row', 'fontsize', 24);
xlabel('Points along boundary', 'fontsize', 24);
grid on;

set(gca,'fontsize',20);