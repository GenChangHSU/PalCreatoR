#' @title Create a palette using colors extracted from an image
#'
#' @description \code{create_pal} creates a colorblind-friendly palette using
#'     colors extracted from an image.
#'
#' @param image a path to the raster image (JPG, JPEG, PNG, TIFF) from which the
#'     colors are to be extracted.
#' @param n a positive integer. The number of colors in the palette.
#' @param resize a number between 0 and 1. This indicates the fraction by which
#'     the width/height (pixels) of the original image is resized while keeping
#'     the aspect ratio. Default to 0.1.
#' @param method the clustering method for classifying pixels into groups based
#'     on the RGB values. Options are \code{"kmeans"} and \code{"Gaussian_mix"}.
#'     Default to \code{"kmeans"}.
#' @param colorblind logical. Whether to render the palette colorblind-friendly
#'     (also see the ‘Details’ section). Default to \code{FALSE}.
#' @param sort a character indicating how the colors should be sorted. Options
#'     are \code{"none"}, \code{"hue"}, \code{"saturation"}, and \code{"value"}.
#'     Default to \code{"none"}(unsorted).
#' @param show.pal logical. Whether to display the palette or not. Default to \code{TRUE}.
#' @param title a character string giving the title of the displayed palette.
#' @param ... additional arguments passed to \code{\link[ggplot2:theme]{ggplot2::theme}}.
#'
#' @details Two clustering methods are available. For \code{method = "kmeans"},
#'     pixels are partitioned into clusters using \code{\link[stats::kmeans]{kmeans}},
#'     and the RGB values of the cluster centers are converted into the corresponding
#'     hexadecimal color codes. For \code{method = "Gaussian_mix"}, pixel components
#'     are identified via multivariate Gaussian mixture modeling using \code{\link[ClusterR:GMM]{ClusterR::GMM}},
#'     and the RGB values of the component centroids are converted into the
#'     corresponding hexadecimal color codes.
#'
#'     If \code{"colorblind = TRUE"}, the original colors are replaced with
#'     colorblind-friendly colors using \code{\link[colorBlindness:replacePlotColor]{colorBlindness::replacePlotColor}}.
#'
#'     The colors in the palette can be sorted in the HSV color space.
#'     If \code{sort = "hue"}, the colors are sorted by hue in an ascending order.
#'     If \code{sort = "saturation"}, the colors are sorted by saturation in a descending order.
#'     If \code{sort = "value"}, the colors are sorted by value in a descending order.
#'
#' @return A vector of hexadecimal color codes.
#'
#' @importFrom magrittr "%>%"
#'
#' @examples \dontrun{
#' library(PalCreatoR)
#' image_path <- system.file("Mountain.JPG", package = "PalCreatoR")
#'
#' My_pal <- create_pal(image = image_path,
#'                      n = 5,
#'                      resize = 0.1,
#'                      method = "kmeans",
#'                      colorblind = FALSE,
#'                      sort = "value",
#'                      show.pal = TRUE,
#'                      title = "My Palette")
#'
#' print(My_pal)}
create_pal <- function(image,
                       n,
                       resize = 0.1,
                       method = "kmeans",
                       colorblind = FALSE,
                       sort = "none",
                       show.pal = TRUE,
                       title = "",
                       ...) {

  # Error messages -------------------------------------------------------------------------

  # 1. n argument
  is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) {
    abs(x - round(x)) < tol
  }

  if (is.wholenumber(n) == F || n <= 0) {
    stop("Incorrect n value. Use positive integer only!")
  }

  # 2. resize argument
  if (!resize <= 1 || !resize >= 0) {
    stop("Incorrect resize value!")
  }

  # 3. method argument
  if (!method %in% c("kmeans", "Gaussian_mix")) {
    stop("Incorrect clustering method!")
  }

  # 4. colorblind argument
  if (is.logical(colorblind) == F) {
    stop('Argument passed to "colorblind" is not logical!')
  }

  # 5. sort argument
  if (!sort %in% c("none", "hue", "saturation", "value")) {
    stop("Unknown sorting method!")
  }

  # 6. title argument
  if (is.character(title) == F) {
    stop("Incorrect title for the palette!")
  }

  # 7. show.pal argument
  if (is.logical(show.pal) == F) {
    stop('Argument passed to "show.pal" is not logical!')
  }


  # Function body -----------------------------------------------------------

  # 1. Read the image
  img <- magick::image_read(image)

  # 2. Get the width and height of the image
  img_width <- magick::image_info(img)["width"]
  img_height <- magick::image_info(img)["height"]


  # 3. Resize the image to reduce the computation load
  img_resize <- magick::image_resize(
    img,
    magick::geometry_size_pixels(
      width = img_width * resize,
      height = img_height * resize,
      preserve_aspect = TRUE
    )
  )


  # 4. Convert the image object into a dataframe of RGB values
  RGB_raw <- imager::magick2cimg(img_resize) %>%
    as.data.frame(wide = "c") %>%
    dplyr::rename(Red = c.1, Green = c.2, Blue = c.3)


  # 5. Cluster analysis on the RGB values
  # 5.1 kmeans clustering
  if (method == "kmeans") {
    set.seed(123)
    kmeans_out <- kmeans(RGB_raw[, c("Red", "Green", "Blue")], centers = n)
    if (kmeans_out$ifault == 4) {
      kmeans_out <-  kmeans(RGB_raw[, c("Red", "Green", "Blue")],
                            centers = n,
                            algorithm = "MacQueen")
      }

    RGB_values <- kmeans_out$centers %>%
      as.data.frame() %>%
      dplyr::mutate(
        Cluster = 1:n,
        Hex_code = grDevices::rgb(
          red = Red,
          green = Green,
          blue = Blue
        )
      )
  }

  # 5.2 Gaussian mixture modeling
  if (method == "Gaussian_mix") {
    GMM_out <- ClusterR::GMM(RGB_raw[, c("Red", "Green", "Blue")],
      gaussian_comps = n,
      dist_mode = "eucl_dist",
      seed_mode = "random_subset",
      km_iter = 10,
      em_iter = 10,
      verbose = F
    )
    RGB_values <- GMM_out$centroids %>%
      as.data.frame() %>%
      dplyr::rename(Red = V1, Green = V2, Blue = V3) %>%
      dplyr::mutate(
        Cluster = 1:n,
        Hex_code = grDevices::rgb(
          red = Red,
          green = Green,
          blue = Blue
        )
      )
  }


  # 6. Make the original colors colorblind-friendly
  if (colorblind == T) {
    Pal_vector <- colorBlindness::displayColors(RGB_values$Hex_code) %>%
      colorBlindness::replacePlotColor() %>%
      .[["grobs"]] %>%
      .[[6]] %>%
      .[["children"]] %>%
      .[[3]] %>%
      .[["gp"]] %>%
      .[["fill"]] %>%
      stringr::str_sub(., start = 1, end = 7)
  } else {
    Pal_vector <- RGB_values$Hex_code
  }


  # 7. Sort the colors based on their HSV
  if (sort == "none") {
    Pal_vector <- Pal_vector
  }

  if (sort == "hue") {
    Pal_vector <- grDevices::col2rgb(Pal_vector) %>%
      grDevices::rgb2hsv() %>%
      t() %>%
      as.data.frame() %>%
      dplyr::arrange(h) %>%
      dplyr::transmute(Pal = hsv(h, s, v)) %>%
      dplyr::pull(Pal)
  }

  if (sort == "saturation") {
    Pal_vector <- grDevices::col2rgb(Pal_vector) %>%
      grDevices::rgb2hsv() %>%
      t() %>%
      as.data.frame() %>%
      dplyr::arrange(desc(s)) %>%
      dplyr::transmute(Pal = hsv(h, s, v)) %>%
      dplyr::pull(Pal)
  }

  if (sort == "value") {
    Pal_vector <- grDevices::col2rgb(Pal_vector) %>%
      grDevices::rgb2hsv() %>%
      t() %>%
      as.data.frame() %>%
      dplyr::arrange(desc(v)) %>%
      dplyr::transmute(Pal = hsv(h, s, v)) %>%
      dplyr::pull(Pal)
  }


  # 8. Visualize the palette
  if (n <= 10) {
    Pal_df <- Pal_vector %>%
      data.frame(Hex_code = .) %>%
      dplyr::mutate(
        x = rep(1, n),
        y = 10:(10 - n + 1)
      )
  }

  if (n > 10 & n %% 10 != 0) {
    q <- n %/% 10
    m <- n %% 10

    Pal_df <- Pal_vector %>%
      data.frame(Hex_code = .) %>%
      dplyr::mutate(
        x = c(rep(1:q, each = 10), rep(q + 1, m)),
        y = c(rep(10:1, q), 10:(m + 1))
      )
  }

  if (n > 10 & n %% 10 == 0) {
    q <- n %/% 10

    Pal_df <- Pal_vector %>%
      data.frame(Hex_code = .) %>%
      dplyr::mutate(
        x = c(rep(1:q, each = 10)),
        y = c(rep(10:1, q))
      )
  }

  p <- ggplot2::ggplot(Pal_df, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_tile(ggplot2::aes(fill = Hex_code)) +
    ggplot2::geom_label(ggplot2::aes(label = Hex_code), fill = "grey", size = 5) +
    ggplot2::scale_fill_identity() +
    ggplot2::theme_void() +
    ggplot2::labs(title = title) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, size = 18)) +
    ggplot2::theme(...)

  if (show.pal == T) {
    print(p)
  }

  # 9. Return the palette vector
  return(Pal_vector)
}


