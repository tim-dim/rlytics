#' rlytics
#'
#' This package contains extra themes, scales, and
#' functions for and related to \pkg{ggplot2}.
#'
#'
#' @name rlytics
#' @docType package
#' @import stats
#' @import utils
#' @import colorspace
#' @import ggplot2
#' @import assertthat
#' @import scales
#' @importFrom grid grobTree grobName gTree gList segmentsGrob gpar
#' @importFrom scales manual_pal div_gradient_pal seq_gradient_pal
#' @importFrom graphics abline axis text points
#' @importFrom methods hasArg as
#' @importFrom graphics par
NULL

# copied from ggplot2
ggname <- function (prefix, grob) {
  grob$name <- grobName(grob, prefix)
  grob
}

style_path <- system.file("extdata", "eyp_styles.xlsx", package = "rlytics")
xltabr::set_style_path(style_path)
num_path <- system.file("extdata", "eyp_style_to_excel_number_format.csv", package = "rlytics")
xltabr::set_cell_format_path(num_path)

globalVariables("ggthemes_data")



