#' occ Color Palette (Discrete) and Scales
#'
#' An 8-color occ safe qualitative discrete palette.
#'
#' @rdname occ
#' @references
#' Umrechnung OCC-Farbschema in Hex-Werte.pptx
#'
#'
#' @export
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour
#' @example inst/examples/ex-occ.R
occ_pal <- function() {
  manual_pal(unname(ggthemes_data$occ))
}

#' @rdname occ
#' @export
scale_colour_occ <- function(...) {
  discrete_scale("colour", "occ", occ_pal(), ...)
}

#' @rdname occ
#' @export
scale_color_occ <- scale_colour_occ

#' @rdname occ
#' @export
scale_fill_occ <- function(...) {
  discrete_scale("fill", "occ", occ_pal(), ...)
}
