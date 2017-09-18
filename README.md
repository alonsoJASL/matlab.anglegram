# Anglegram analysis: baseline code
This project is the implementation of the anglegram and the detection
of junctions in the boundary of a clump.
The algorithm detects junctions between the boundaries of overlapping
objects based on the angles between points of the overlapping
boundary.

The anglegram matrix is a 2D matrix with the multiscale angle variation.
The anglegram is used to find junctions of overlapping cells.

## Publication
The development of this algorithm was published in the Medical Image
Understanding and Analysis Conference
[MIUA 2017.](https://doi.org/10.1007/978-3-319-60964-5_69)


### Licensing and Citation
This project is part of the GNU GENERAL PUBLIC LICENSE v3, read all the
terms and conditions in the [LICENSE](./LICENSE) file. If this code
is useful in your research consider citing:
```BibTeX
@Inbook{Solís-Lemus2017,
  author="Sol{\'i}s-Lemus, Jos{\'e} Alonso
    and Stramer, Brian and Slabaugh, Greg
    and Reyes-Aldasoro, Constantino Carlos",
  editor="Vald{\'e}s Hern{\'a}ndez, Mar{\'i}a
    and Gonz{\'a}lez-Castro, V{\'i}ctor",
  title="Segmentation of Overlapping Macrophages Using Anglegram Analysis",
  bookTitle="Medical Image Understanding and Analysis: 21st Annual 
     Conference, MIUA 2017, Edinburgh, UK, July 11--13, 2017, Proceedings",
  year="2017",
  publisher="Springer International Publishing",
  isbn="978-3-319-60964-5",
  doi="10.1007/978-3-319-60964-5_69",
}
```
