########## Hexagon Sticker for the PalCreatoR Package ###########
########## Author: Gen-Chang Hsu ##########

library(tidyverse)
library(hexSticker)
library(magick)

### Sticker subplot
spiral_df <- data.frame(x = seq(0, 13, length.out = 5000)) %>%
  mutate(y = exp(0.30635 * x)) %>%
  mutate(
    x = rev(x),
    y = rev(y),
    polar_x = y * cos(x),
    polar_y = y * sin(x),
    x_start = rep(0, 5000),
    y_start = rep(0, 5000)
  )

spiral_p <- ggplot(spiral_df) +
  geom_segment(aes(x = x_start, y = y_start, xend = polar_x, yend = polar_y),
    color = rev(rainbow(5000)),
    size = 1
  ) +
  geom_point(aes(x = polar_x, y = polar_y),
    color = "black",
    size = 0.1
  ) +
  coord_fixed(ratio = 1) +
  theme_void()

### Create the hex sticker
sticker(

  # Sticker image
  subplot = spiral_p,
  s_x = 1,
  s_y = 1.1,
  s_width = 1.1,
  s_height = 2.1,

  # Package name
  package = "PalCreatoR",
  p_x = 1,
  p_y = 0.5,
  p_color = "black",
  p_family = "Aller_Rg",
  p_fontface = "bold",
  p_size = 36,

  # Hexagon background
  h_size = 1.8,
  h_fill = "#9BCD9B",
  h_color = "black",

  # Spotlight
  spotlight = F,
  l_x = 1,
  l_y = 0.5,
  l_width = 3,
  l_height = 3,
  l_alpha = 0.4,

  # URL
  url = "",
  u_x = 1,
  u_y = 0.08,
  u_color = "black",
  u_family = "Aller_Rg",
  u_size = 1.5,
  u_angle = 30,

  # Sticker border
  white_around_sticker = F,

  # Save the file
  filename = "man/figures/Hex Sticker.png",
  asp = 1,
  dpi = 600
)
