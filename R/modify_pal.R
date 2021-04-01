#' @title Modify alpha transparency of the colors in the palette
#'
#' @description \code{modify_pal} modifies alpha transparency of the colors in the palette.
#'
#' @param pal a vector of hexadecimal color codes (not necessarily returned from \code{\link[PalCreatoR:create_pal]{create_pal}).
#' @param alpha a single number or a vector of numbers between 0 and 1. These values define the degree
#'     of transparency of the colors in the palette. If \code{alpha} is a single number, the transparency of
#'     all the colors in the palette will be set to that value; if \code{alpha} is a vector of numbers, the
#'     transparency of the colors in the palette will be set to the corresponding alpha values.
#'     Also note that if the vector lengths of \code{pal} and \code{alpha} differ, extra elements in the longer
#'     vector will be omitted to match the length of the shorter one. See 'Details' section for more information
#'     on the concept of alpha transparency.
#' @param show.pal logical. Whether to display the modified palette or not. Default to \code{TRUE}.
#' @param title a character string giving the title of the displayed palette.
#' @param ... additional arguments passed to \code{\link[ggplot2:theme]{ggplot2::theme}}.
#'
#' @details An alpha value defines the "transparency", or "opacity" of the color. A value of 0 means completely
#'     transparent (i.e., the background will completely “show through”); a value of 1 means completely opaque
#'     (i.e., none of the background will “show through”). In short, the lower the alpha value is, the lower "amount"
#'     of the color will be.
#'
#' @return A vector of hexadecimal color codes with two additional digits defining the degree of transparency.
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
#' My_new_pal <- modify_pal(pal = My_pal,
#'                          alpha = c(0.2, 0.4, 0.6, 0.8, 1.0),
#'                          show.pal = TRUE,
#'                          title = "My New Palette")
#' print(My_new_pal)}
modify_pal <- function(pal,
                       alpha,
                       show.pal = TRUE,
                       title = "",
                       ...) {
  # Error messages -------------------------------------------------------------------------

  # 1. pal argument
  if (grepl(pattern = "^#[0-9A-Fa-f]{6}$", x = pal) == F) {
    stop('One or more incorrect hex color codes passed in the "pal" argument!')
  }

  # 2. alpha argument
  if (any(!alpha <= 1) || any(!alpha >= 0)) {
    stop('One or more incorrect values passed in the "alpha" argument!')
  }

  # 3. show.pal argument
  if (is.logical(show.pal) == F) {
    stop('Argument passed to "show.pal" is not logical!')
  }


  # Function body -----------------------------------------------------------

  # 1. Check the lengths of the pal and alpha vectors
  if (length(pal) != length(alpha) &&
      length(pal) != 1 && length(alpha) != 1) {
    warning(
      'The lengths of "pal"" and "alpha" differ; extra elements in the longer vector
  are omitted to match the length of the shorter one!'
    )
  }

  df <- data.frame(hex = pal, alpha = alpha)

  # 2. Get the hex codes with the additional two alpha digits
  hex_codes <- purrr::map2(
    .x = df$hex,
    .y = df$alpha,
    .f = function(x, y) {
      rgb_val <- col2rgb(x, alpha = F) %>% as.vector()
      hex_code <-
        rgb(
          r = rgb_val[1],
          g = rgb_val[2],
          b = rgb_val[3],
          alpha = y * 255,
          maxColorValue = 255
        )
      return(hex_code)
    }
  ) %>% unlist()

  # 3. Visualize the palette
  n <- length(hex_codes)

  if (show.pal == T) {
    if (n <= 10) {
      Pal_df <- hex_codes %>%
        data.frame(Hex_code = .) %>%
        dplyr::mutate(x = rep(1, n),
                      y = 10:(10 - n + 1))
    }

    if (n > 10 & n %% 10 != 0) {
      q <- n %/% 10
      m <- n %% 10

      Pal_df <- hex_codes %>%
        data.frame(Hex_code = .) %>%
        dplyr::mutate(x = c(rep(1:q, each = 10), rep(q + 1, m)),
                      y = c(rep(10:1, q), 10:(10 - m + 1)))
    }

    if (n > 10 & n %% 10 == 0) {
      q <- n %/% 10

      Pal_df <- hex_codes %>%
        data.frame(Hex_code = .) %>%
        dplyr::mutate(x = c(rep(1:q, each = 10)),
                      y = c(rep(10:1, q)))
    }

    p <- ggplot2::ggplot(Pal_df, ggplot2::aes(x = x, y = y)) +
      ggplot2::geom_tile(ggplot2::aes(fill = Hex_code)) +
      ggplot2::geom_label(ggplot2::aes(label = Hex_code),
                          fill = "grey",
                          size = 4) +
      ggplot2::scale_fill_identity() +
      ggplot2::theme_void() +
      ggplot2::labs(title = title) +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, size = 18)) +
      ggplot2::theme(...)

    print(p)
  }

  # 9. Return the palette vector
  return(hex_codes)
}











