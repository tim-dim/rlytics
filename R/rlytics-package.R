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

globalVariables("ggthemes_data")


# cleans out umlaute
clean_umlaute <- function (x) {
  x = gsub("â€“", "–", x)
  x = gsub("Ãœ", "Ü", x)
  x = gsub("Ã¤", "ä", x)
  x = gsub("Â»", "»", x)
  x = gsub("Ã¼", "ü", x)
  x = gsub("â€˜", "‘", x)
  x = gsub("Ã¶", "ö", x)
  x = gsub("âˆ’", "?", x)
  x
}
