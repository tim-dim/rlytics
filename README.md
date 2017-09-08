# rlytics

## Overview

Provides often used functions and themes for working with R and
[ggplot](http://ggplot2.org), including:

### Functions

- ``calc_dist``: calculates distance between geocoded locations
- ``as_numeric_ger``: changes german number format to english number format
- ``clean_ger``: changes special german characters to normal characters

### Scales

- ``scale_colour_occ``: color and shape palettes in OC&C colours.
- ``scale_colour_colorblind``: Colorblind safe palette from <http://jfly.iam.u-tokyo.ac.jp/color/>.

## Install 

To install the development version from github, use the
**devtools** package:

```r
library("devtools")
install_github("tim-dim/rlytics")
```


# Examples


```r
library("ggplot2")
library("rlytics")

ggplot(mpg, aes(displ, hwy, colour = class)) +
  geom_point() +
  theme_classic() +
  scale_colour_occ() 
```

