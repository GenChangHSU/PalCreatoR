
# PalCreatoR <img src = "man/figures/Hex Sticker.png" align = "right" height = "200" />

<!-- badges: start -->

<!-- badges: end -->

The PalCreatoR package is designed to create an R palette using colors
from an image. It streamlines the process of pulling out a number of
representative colors from the given image and returning the
corresponding hexadecimal codes. It also offers the option to get
colorblind-friendly colors. Just pick an image of your favorite and pass
it into the
[function](https://genchanghsu.github.io/PalCreatoR/reference/create_pal.html):
a customized palette is readily available for you\! Use it for
presentation, publication, or simply for fun\!

## Background

The idea of creating color palettes from an image is not something new
in the R community. Several packages (e.g.,
[imgpalr](https://cran.rstudio.com/web/packages/imgpalr/index.html),
[paletteR](https://github.com/AndreaCirilloAC/paletter),
[PNWColors](https://github.com/jakelawlor/PNWColors),
[RImagePalette](https://cran.r-project.org/web/packages/RImagePalette/index.html))
and functions (e.g.,
[palettebuildr](https://gist.github.com/jonesor/1818babb03783dc41a1a))
have been developed for this purpose, with a wide range of arguments
available. Inspired by these works, the PalCreatoR package aims to
provide an easy-to-use tool that does the same job while keeping the
arguments as simple as possible. It incorporates two features that have
so far not yet been implemented in the current functions of its kind:
(1) allowing user to get colorblind-friendly colors converted from the
original colors in the palette; (2) using multivariate Gaussian mixture
modeling (GMM), besides the most-used kmeans algorithm, to extract the
representative colors from the image.

## Installation

The latest version of PalCreatoR can be installed from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("GenChangHSU/PalCreatoR")
```

## Examples

Here are some example palettes created with the function
[`create_pal`](https://genchanghsu.github.io/PalCreatoR/reference/create_pal.html).
See [Quick
Demonstration](https://genchanghsu.github.io/PalCreatoR/articles/Quick_Demonstration.html)
for more details on its usage.

<br>

<img src = "inst/Mountain.JPG" align = "left" height = "300" />
<img src="man/figures/README-palette example 1-1.png" width="30%" />

<br> <br>

<img src = "inst/Cicada.JPG" align = "left" height = "300" />
<img src="man/figures/README-palette example 2-1.png" width="30%" />

<br> <br>

<img src = "inst/Alpine Flower.JPG" align = "left" height = "300" />
<img src="man/figures/README-palette example 3-1.png" width="30%" />

<br>

## Contact

Like it? Feel free to reach us at <genchanghsu@gmail.com> and
<willemou@gmail.com>. Any suggestions or cool ideas are welcome\!
