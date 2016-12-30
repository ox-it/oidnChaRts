## Test environments
* local OS X install, R 3.3.2
* ubuntu 12.04 (on travis-ci), R 3.3.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 2 note

* installed size is  9.1Mb 
  sub-directories of 1Mb or more:
  doc   9.0Mb

This is due to the vignettes including multiple htmlwidget outputs, and the package does not clear the HTML outputs. I can further investigate reducing these as necessary. Thanks!

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.
