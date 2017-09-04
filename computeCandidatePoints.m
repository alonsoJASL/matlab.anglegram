function [candidatePoints, candieshandles] = computeCandidatePoints(angleMatrix, ...
    thisBoundy, mainthresh, offsetVar, statsfname)
% COMPUTE CANDIDATE POINTS from the anglegram matrix (angleMatrix).
%

if nargin < 2
    fprintf('%s: ERROR. Not enough input arguments.', mfilename);
    candidatePoints = [] ;
    candieshandles = [];
    return;
elseif nargin < 3
    mainthresh = 150;
    offsetVar = 7;
    statsfname = 'max';
else
    [mainthresh, offsetVar, statsfname] = getoptions(angleopts);
end

aMthresh = angleMatrix;
aMthresh(aMthresh < mainthresh) = NaN;
f = ones(5)/25;
aMthresh = imfilter(aMthresh,f, 'replicate');

str1 = strcat('[computeCandidatePoints].Calculating: ',...
    upper(statsfname));
disp(str1);
minpeakdist = 25;
switch lower(statsfname)
    case {'mean', 'median'}
        angleSummaryVector = feval(statsfname,aMthresh(:,offsetVar:end),...
            2,'omitnan');
        meanAM = mean(angleSummaryVector, 'omitnan');
        stdAM = std(angleSummaryVector, 'omitnan');
        minpeakheight = meanAM + 0.75*stdAM;
    case {'max'}
        angleSummaryVector = max(aMthresh(:,offsetVar:end),[],2);
        meanAM = mean(angleSummaryVector, 'omitnan');
        stdAM = std(angleSummaryVector, 'omitnan');
        minpeakheight = meanAM + 0.75*stdAM;
    case {'integral', 'trapz'}
        aMthresh(isnan(aMthresh)) = 0;
        angleSummaryVector = trapz(aMthresh(:,offsetVar:end),2);
        %angleSummaryVector = sqrt(angleSummaryVector);

        angleSummaryVector(angleSummaryVector==0) = nan;
        meanAM = mean(angleSummaryVector, 'omitnan');
        stdAM = std(angleSummaryVector, 'omitnan');
        minpeakheight = meanAM+0.1*stdAM;
        minpeakdist = 50;
    otherwise
        str1 = strcat('[computeCandidatePoints]',...
            'ERROR. Not a valid function to evaluate angleMatrix.');
        disp(str1);
        candidatePoints = [] ;
        candieshandles = [];
        return;
end

[intensityPeaks, intensityLocations] = findpeaks(angleSummaryVector,...
    'MinPeakDistance',minpeakdist,'MinPeakHeight',minpeakheight,...
    'SortStr','descend');

if isempty(intensityLocations)
    str1 = strcat('[computeCandidatePoints]',...
        'Search for candidates over "optimised threshold" not succesful.');
    str2 = strcat('[computeCandidatePoints]',...
        'Starting search for candidates using baseline threshold of 180.');
    disp(str1);
    disp(str2);
    [intensityPeaks, intensityLocations] = findpeaks(angleSummaryVector,...
        'MinPeakDistance',25,'MinPeakHeight',meanAM,'SortStr','descend');
end

candidatePoints = thisBoundy(intensityLocations,:);

candieshandles.meanAM = meanAM;
candieshandles.stdAM = stdAM;
candieshandles.aMtresh = aMthresh;
candieshandles.angleSummaryVector = angleSummaryVector;
candieshandles.intensityLocations = intensityLocations;
candieshandles.intensityPeaks = intensityPeaks;

% to compute corners
maxOffset = max(sum(aMthresh>0,2));
aMfiltered = imfilter(angleMatrix,ones(3)./9);
aMsection = aMfiltered(:,offsetVar:maxOffset);
angleCornerVector = mean(aMsection,2);
[envHigh, envLow] = envelope(angleCornerVector,8,'peaks');
envMean = (envHigh+envLow)./2;
[~ ,corners] = findpeaks(-angleCornerVector, 'MinPeakHeight',...
    mean(-angleCornerVector));

candieshandles.angleCornerVector = angleCornerVector;
candieshandles.envMean = envMean;
candieshandles.corners = corners;
candieshandles.cornerCandidates = thisBoundy(corners, :);

end

function [mainthresh, offsetVar, statsfname] = getoptions(s)
% Get the options for calculating the candidate points.
mainthresh = 150;
offsetVar = 7;
statsfname = 'max';

fnames = fieldnames(s);
for ix=1:length(fnames)
    name = fnames{ix};
    switch name
        case 'mainthresh'
            mainthresh = s.(name);
        case 'offsetVar'
            offsetVar = s.(name);
        case 'statsfname'
            statsfname = s.(name);
        otherwise
            fprintf('%s: ERROR. Incorrect option [%s] is NOT defined.\n',...
                mfilename, upper(name));
    end
end

end
