#' @title Example images included in this package
#'
#' @description Three example images (Mountain.JPG, Cicada.JPG, Alpine Flower.JPG)
#'      are available in this package (photo credit: Gen-Chang Hsu).
#'      See 'Examples' for how to load the images.
#'
#' @format .JPG file.
#'
#' @examples
#' library(PalCreatoR)
#' library(magick)
#'
#' image_path_Mountain <- system.file("Mountain.JPG", package = "PalCreatoR")
#' Mountain <- image_read(image_path_Mountain)
#' plot(Mountain)
#'
#' image_path_Cicada <- system.file("Cicada.JPG", package = "PalCreatoR")
#' Cicada <- image_read(image_path_Cicada)
#' plot(Cicada)
#'
#' image_path_Alpine_flower <- system.file("Alpine Flower.JPG", package = "PalCreatoR")
#' Alpine_flower <- image_read(image_path_Alpine_flower)
#' plot(Alpine_flower)
#'
"example_images"
