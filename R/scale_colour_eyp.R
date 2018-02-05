#' EYP Color Palette (Discrete) and Scales
#'
#' An 8-color eyp safe qualitative discrete palette.
#'
#' @rdname eyp
#' @references
#' Umrechnung EYP-Farbschema in Hex-Werte.pptx
#'
#'
#' @export
#' @inheritParams ggplot2::scale_colour_hue
#' @family colour
#' @example inst/examples/ex-eyp.R
eyp_pal <- function() {
  manual_pal(unname(ggthemes_data$eyp))
}

#' @rdname eyp
#' @export
scale_colour_eyp <- function(...) {
  discrete_scale("colour", "eyp", eyp_pal(), ...)
}

#' @rdname eyp
#' @export
scale_color_eyp <- scale_colour_eyp

#' @rdname eyp
#' @export
scale_fill_eyp <- function(...) {
  discrete_scale("fill", "eyp", eyp_pal(), ...)
}
