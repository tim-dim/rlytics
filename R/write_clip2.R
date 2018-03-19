

#' Writes data to clipboard
#'
#'
#' @rdname write.clip2
#' @references
#' Writes data to clipboard, with "." as dec
#' @param dec decimal seperator, default is "."
#' @param column.names column.names = TRUE is default
#' @param row.names row.names = FALSE is default


#' @export
#' @rdname write.clip2
write.clip2 <- function (x, dec = ".",col.names=TRUE, row.names=FALSE) {
  write.table(x, "clipboard", sep="\t", dec = ".",col.names=TRUE, row.names=FALSE)
}
