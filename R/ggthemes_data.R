#' Palette data for the rlytics package
#'
#' Data used by the palettes in the rlytics package.
#'
#' @format A \code{list}.
#' @export
ggthemes_data <- {
  ## x to hold value of list as I create it
  x <- list()

  x$eyp <-    c(    akzent5 = "#274f77",
                    akzent4 = "#336699",
                    akzent3 = "#3d8bcb",
                    akzent2 = "#79bae7",
                    akzent1 = "#bcddf2",
                    gray_accent5 = "#4b4b4b",
                    gray_accent4 = "#646464",
                    gray_accent3 = "#838383"
  )

  x$occ <-    c(    akzent1 = "#CCDDEC",
                    akzent2 = "#99BAD9",
                    akzent3 = "#669DC5",
                    akzent4 = "#3375B2",
                    akzent5 = "#FF9933",
                    akzent6 = "#C0C0C0",
                    hell2 = "#00539F",
                    dunkel2 = "#002C54"
                    )

  x$colorblind <- c(black = "#000000",
                    orange = "#E69F00",
                    sky_blue = "#56B4E9",
                    bluish_green = "#009E73",
                    yellow = "#F0E442",
                    blue = "#0072B2",
                    vermillion = "#D55E00",
                    reddish_purple = "#CC79A7")
  x
}
