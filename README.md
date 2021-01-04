
# PalCreatoR <img src = "man/figures/Hex Sticker.png" align = "right" height = "200" />

<!-- badges: start -->

<!-- badges: end -->

The PalCreatoR package is designed to create an R palette using colors
from an image. It streamlines the process of pulling out a number of
representative colors from the given image based on user’s request and
returning the corresponding hexadecimal codes. It also provides an
option for generating colorblind-friendly colors. Just pick an image of
your favorite and pass it into the
[function](https://genchanghsu.github.io/PalCreatoR/reference/create_pal.html):
a customized palette is readily available for you\! Use it for
presentation, publication, or simply for fun\!

## Background

The idea of creating color palettes from an image is not something new
in R. Several packages (e.g.,
[imgpalr](https://cran.rstudio.com/web/packages/imgpalr/index.html),
[paletteR](https://github.com/AndreaCirilloAC/paletter),
[PNWColors](https://github.com/jakelawlor/PNWColors),
[RImagePalette](https://cran.r-project.org/web/packages/RImagePalette/index.html))
and functions (e.g.,
[palettebuildr](https://gist.github.com/jonesor/1818babb03783dc41a1a))
have been developed for this purpose, with a wide range of arguments
available. Inspired by these works, the PalCreatoR package aims to
provide an easy-to-use tool that achieves the same goal while keeping
the syntax as simple as possible. It features two options so far not yet
been implemented in the functions of its kind: (1) allowing the choice
of colorblind-friendly colors, and (2) using a multivariate Gaussian
mixture modeling (GMM) approach to clustering pixels based on the RGB
values.

## Installation

The latest version of PalCreatoR can be installed from GitHub:

``` r
# install.packages("devtools")
# devtools::install_github("GenChangHSU/PalCreatoR")
```

## Examples

Here are some example palettes generated using the function
[`create_pal`](https://genchanghsu.github.io/PalCreatoR/reference/create_pal.html).
For more details, see `vignette(PalCreatoR)`.

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

Like it? Feel free to reach us at <ymstrknp@gmail.com> and
<willemou@gmail.com>. Any suggestions or cool ideas are welcome\!

Have fun and enjoy\!\!\!
