function [cornies, cornyLoc, cornyhands] = computeCorners(anglematrix, boundy, opts)
% COMPUTE CORNERS. Calculates corners from the anglegram matrix. The
% anglegram is shrunk to ensure a better interpretation of the data. 
% 

if nargin < 3
    agsize = [64 64];
    offst = agsize(1)/2;
    statsfname = 'max';
else
    [agsize, offst, statsfname] = getoptions(opts);
end
wrapN = @(x, N) (1 + mod(x-1, N));

anglegram = imresize(anglematrix, agsize);
anglegram = anglegram(:,1:offst);

switch lower(statsfname)
    case 'max'
        statfn = @(x) max(x, [],2);
    case 'mean'
        statfn = @(x) mean(x, 2);
end

anglesumve = statfn(anglegram);

[minval, minlocations] = findpeaks(-[anglesumve;anglesumve]);
minval = -minval;

[minval, ic,~] = unique(minval, 'stable');
minlocations = wrapN(minlocations(ic), agsize(1));

cornyLoc = fix((minlocations./64)*size(boundy,1));
cornies = boundy(cornyLoc,:);

if nargouut > 2
    cornyhands.minlocations = minlocations;
    cornyhands.minval = minval;
end
end

function [agsize, offst, statsfname] = getoptions(opts)
%
agsize = [64 64];
offst = agsize(1)/2;
statsfname = 'max';

fnames = fieldnames(opts);
for ix=1:length(fnames)
    switch fnames{ix}
        case 'agsize'
            agsize = opts.(fnames{ix});
        case 'offst'
            offst = opts.(fnames{ix});
        case 'statsfname'
            statsfname = opts.(fnames{ix});
        otherwise
            fprintf('%s: ERROR, option %s not recognised.\n',...
                mfilename, upper(fnames{ix}));
    end
end
end