

#' Writes data to clipboard
#'
#'
#' @rdname write.clip
#' @references
#' Writes data to clipboard
#'


#' @export
#' @rdname write.clip
write.clip <- function (x) {
  write.table(x, "clipboard", sep="\t", dec = ",", row.names=FALSE)
}


