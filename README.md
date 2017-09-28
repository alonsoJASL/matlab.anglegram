# Anglegram analysis: baseline code
This project is the implementation of the anglegram and the detection
of junctions in the boundary of a clump.
The algorithm detects junctions between the boundaries of overlapping
objects based on the angles between points of the overlapping
boundary.

The anglegram matrix is a 2D matrix with the multiscale angle variation.
The anglegram is used to find junctions of overlapping cells.

## Quick start guide
In order to use the code as shown in our MIUA
[publication](https://doi.org/10.1007/978-3-319-60964-5_69), you need to
do the following:

1. Get a binary image with your clump or cell, let `bw0` be such binary image.
With it, get the boundary of such binary object
```Matlab
boundy=bwboundaries(bw0);
```

2. Compute the _anglegram_. For a simple test with just one clump `bw0` and one
boundary `boundy`, nothing else needs to be done:
```Matlab
[anglegram] = computeAngleMatrix(boundy);
```

3. Get the junction points (we call them `candies`) via the `anglegram` matrix.
You may need to tweak some of the parameters, but the default values are a good
starting point.
```Matlab
[candies, candyhandles] = computeCandidatePoints(anglemgram, boundy);
```

3. (optional) If you feel you need to tweak the parameters, you can do it via an
options structure `opts`:
```Matlab
opts.mainthr = 150;
opts.offsetvar = 7;
opts.statsfname = 'max';
[candies, candyhandles] = computeCandidatePoints(anglemgram, boundy, opts);
```

The structure `candyhandles` contains a lot of useful information from the
junctions detected:
+ `candieshandles.angleSummaryVector` Maximum (mean or integral) intensity
  projection.
+ `candieshandles.meanAM` Mean of the `angleSummaryVector`.
+ `candieshandles.stdAM` Standard deviation of the `angleSummaryVector`.
+ `candieshandles.intensityLocations` Locations in the boundary `boundy` where
  the candidates are located.
+ `candieshandles.intensityPeaks` Value of the angles where the locations
  are presented `candieshandles.intensityLocations`.

### Junction slicing (JS)
To compute the Junction Slicing technique from our publication, the (beta) code
following from the previous section.

4. Get cell candidates from the junctions found, using using the binary image of
the nuclei, `nuclei`.
```Matlab
cl = candieshandles.intensityLocations; % candidate locations
[bwcells, boundcells, ~] = getCellCandidatesFromSegments(cl, boundy, bw0, nuclei);
```

## Future developments
A future development of the _anglegram_ matrix involves the function
`computeMultiAnglegram`.

# Publication
The development of this algorithm was published in the Medical Image
Understanding and Analysis Conference
[MIUA 2017.](https://doi.org/10.1007/978-3-319-60964-5_69)


## Licensing and Citation
This project is part of the GNU GENERAL PUBLIC LICENSE v3, read all the
terms and conditions in the [LICENSE](./LICENSE) file. If this code
is useful in your research consider citing:
```BibTeX
@Inbook{Solís-Lemus2017,
  author="Sol{\'i}s-Lemus, Jos{\'e} Alonso and Stramer, Brian
  and Slabaugh, Greg and Reyes-Aldasoro, Constantino Carlos",
  editor="Vald{\'e}s Hern{\'a}ndez, Mar{\'i}a and Gonz{\'a}lez-Castro, V{\'i}ctor",
  title="Segmentation of Overlapping Macrophages Using Anglegram Analysis",
  bookTitle="Medical Image Understanding and Analysis: 21st Annual
     Conference, MIUA 2017, Edinburgh, UK, July 11--13, 2017, Proceedings",
  year="2017",
  publisher="Springer International Publishing",
  isbn="978-3-319-60964-5",
  doi="10.1007/978-3-319-60964-5_69",
}
```