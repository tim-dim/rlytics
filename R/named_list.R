#' Function to create names for dataframes inside a list
#'
#'
#' @rdname named_list
#' @references
#' Function to create names for dataframes inside a list
#' @param ...


#' @export
#' @rdname named_list
named_list <- function (...)
{
  L <- list(...)
  nms <- names(L)
  if (is.null(nms)) {
    nms <- rep("", length(L))
  }
  if (any(needsName <- is.na(nms) | !nzchar(nms))) {
    nms[needsName] <- vapply(substitute(...())[needsName],
                             function(x) deparse(x, nlines = 1L), FUN.VALUE = "")
    names(L) <- nms
  }
  L
}
